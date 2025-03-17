import 'dart:async';
import 'dart:math';

import 'package:chat_app/data/repositories/chat_repository.dart';
import 'package:chat_app/logic/cubits/chat/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final String currentUserId;
  bool _isInChat = false;

  StreamSubscription? _messageSubscription;
  StreamSubscription? _onlineStatusSubscription;
  StreamSubscription? _typingStatusSubscription;

  ChatCubit({
    required ChatRepository chatRepository,
    required this.currentUserId,
  }) : _chatRepository = chatRepository,
       super(ChatState());

  void enterChat(String receiverId) async {
    _isInChat = true;
    emit(ChatState(receiverId: receiverId));

    try {
      final chatRoom = await _chatRepository.getOrCreateChatRoom(
        currentUserId,
        receiverId,
      );

      emit(
        state.copyWith(
          chatRoomId: chatRoom.id,
          receiverId: receiverId,
          status: ChatStatus.loaded,
        ),
      );
      _subscitbeToMessage(chatRoom.id);
      _subscribeToOnlineStatus(receiverId);
      _subscribeToTypingStatus(chatRoom.id);
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: "Failed to create chat room, $e",
        ),
      );
    }
  }

  Future<void> sendMessage({
    required String message,
    required String receiverid,
  }) async {
    try {
      if (state.chatRoomId == null) {
        emit(
          state.copyWith(
            status: ChatStatus.error,
            error: "Chat room not found",
          ),
        );
        return;
      }

      await _chatRepository.sendMessage(
        chatRoomId: state.chatRoomId!,
        senderId: currentUserId,
        receiverId: receiverid,
        message: message,
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ChatStatus.error,
          error: "Failed to send message, $e",
        ),
      );
    }
  }

  void _subscitbeToMessage(String chatRoomId) {
    _messageSubscription?.cancel();
    _messageSubscription = _chatRepository
        .getMessageStream(chatRoomId)
        .listen(
          (messages) {
            if (_isInChat) {
              markMessageAsRead();
            }
            emit(state.copyWith(messages: messages, error: null));
          },
          onError: (error) {
            emit(
              state.copyWith(
                error: 'Failed to fetch messages, ${error.toString()}',
                status: ChatStatus.error,
              ),
            );
          },
        );
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    return super.close();
  }

  Future<void> markMessageAsRead() async {
    if (state.chatRoomId == null) {
      return;
    }
    await _chatRepository.markMessageAsRead(state.chatRoomId!, currentUserId);
  }

  Future<void> leaveChat() async {
    _isInChat = false;
    await markMessageAsRead();
  }

  void _subscribeToOnlineStatus(String userId) {
    _onlineStatusSubscription?.cancel();
    _onlineStatusSubscription = _chatRepository
        .getUserStatus(userId)
        .listen(
          (status) {
            final isOnline = status['isOnline'] as bool;
            final lastSeen = status['lastSeen'] as Timestamp?;
            emit(
              state.copyWith(
                isReceiverOnline: isOnline,
                receiverLastSeen: lastSeen,
              ),
            );
          },
          onError: (e) {
            emit(state.copyWith(error: 'Error fetching online status'));
          },
        );
  }

  void _subscribeToTypingStatus(String chatRoomId) {
    _typingStatusSubscription?.cancel();
    _typingStatusSubscription = _chatRepository
        .getUserTypingStatus(chatRoomId)
        .listen(
          (status) {
            final isTyping = status['isTyping'] as bool;
            final typingUserId = status['typingUserId'] as String?;
            emit(
              state.copyWith(
                isReceiverTyping: isTyping && typingUserId != currentUserId,
              ),
            );
          },
          onError: (e) {
            emit(state.copyWith(error: 'Error fetching typing status'));
          },
        );
  }
}
