import 'package:chat_app/data/models/chat_message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus { initial, loading, loaded, error }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ChatMessageModel> messages;
  final String? error;
  final String? receiverId;
  final String? chatRoomId;
  final bool isReceiverOnline;
  final bool isReceiverTyping;
  final Timestamp? receiverLastSeen;
  final bool hasMoreMessages;
  final bool isLoadingMoreMessages;
  final bool isUserBlocked;
  final bool isAmIBlocked;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.error,
    this.receiverId,
    this.chatRoomId,
    this.isReceiverOnline = false,
    this.isReceiverTyping = false,
    this.receiverLastSeen,
    this.hasMoreMessages = false,
    this.isLoadingMoreMessages = false,
    this.isUserBlocked = false,
    this.isAmIBlocked = false,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatMessageModel>? messages,
    String? error,
    String? receiverId,
    String? chatRoomId,
    bool? isReceiverOnline,
    bool? isReceiverTyping,
    Timestamp? receiverLastSeen,
    bool? hasMoreMessages,
    bool? isLoadingMoreMessages,
    bool? isUserBlocked,
    bool? isAmIBlocked,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      error: error ?? this.error,
      receiverId: receiverId ?? this.receiverId,
      chatRoomId: chatRoomId ?? this.chatRoomId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    messages,
    error,
    receiverId,
    chatRoomId,
    isReceiverOnline,
    isReceiverTyping,
    receiverLastSeen,
    hasMoreMessages,
    isLoadingMoreMessages,
    isUserBlocked,
    isAmIBlocked,
  ];
}
