import 'package:chat_app/data/models/chat_message_model.dart';
import 'package:chat_app/data/models/chat_room_model.dart';
import 'package:chat_app/data/repositories/base_repository.dart';
import 'package:chat_app/data/services/service.locator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository extends BaseRepository {
  final FirebaseFirestore _firestore = locator<FirebaseFirestore>();
  CollectionReference get _chatRoom => _firestore.collection('chatRooms');
  CollectionReference getChatRoomMessages(String chatRoomId) =>
      _chatRoom.doc(chatRoomId).collection('messages');

  Future<ChatRoomModel> getOrCreateChatRoom(
    String currentUserId,
    String othersuserid,
  ) async {
    if (currentUserId == othersuserid) {
      throw Exception('You cannot chat with yourself');
    }

    final currentUser =
        await _firestore.collection('users').doc(currentUserId).get();
    final otherUser =
        await _firestore.collection('users').doc(othersuserid).get();

    if (!currentUser.exists || !otherUser.exists) {
      throw Exception('User not found');
    }

    final users = [othersuserid, currentUserId]..sort();
    final chatRoomId = users.join('_');
    final roomDoc = await _chatRoom.doc(chatRoomId).get();

    if (roomDoc.exists) {
      return ChatRoomModel.fromFirestore(roomDoc);
    }

    final currentUserData =
        (await _firestore.collection('users').doc(currentUserId).get()).data()
            as Map<String, dynamic>;
    final otherUserData =
        (await _firestore.collection('users').doc(othersuserid).get()).data()
            as Map<String, dynamic>;

    final participantsName = {
      currentUserId: currentUserData['fullName']?.toString() ?? '',
      othersuserid: otherUserData['fullName']?.toString() ?? '',
    };

    final chatRoomData = ChatRoomModel(
      id: chatRoomId,
      participants: users,
      participantsName: participantsName,
      lastReadTime: {
        currentUserId: Timestamp.now(),
        othersuserid: Timestamp.now(),
      },
    );

    await _chatRoom.doc(chatRoomId).set(chatRoomData.toMap());
    return chatRoomData;
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String receiverId,
    required String message,
    MessageType messageType = MessageType.text,
  }) async {
    final chatRoomDoc = await _chatRoom.doc(chatRoomId).get();
    if (!chatRoomDoc.exists) {
      throw Exception('Chat room not found');
    }

    final batch = _firestore.batch();

    final messageDoc = getChatRoomMessages(chatRoomId).doc();

    final messageData = ChatMessageModel(
      id: messageDoc.id,
      chatRoomId: chatRoomId,
      content: message,
      senderId: senderId,
      receiverId: receiverId,
      type: messageType,
      timestamp: Timestamp.now(),
      readBy: [senderId],
    );

    batch.set(messageDoc, messageData.toMap());
    batch.update(chatRoomDoc.reference, {
      'lastMessage': message,
      'lastMessageSenderId': senderId,
      'lastMessageTime': messageData.timestamp,
    });

    await batch.commit();
  }

  Stream<List<ChatMessageModel>> getMessageStream(
    String chatRoomId, {
    DocumentSnapshot? lastDocument,
  }) {
    var query = getChatRoomMessages(
      chatRoomId,
    ).orderBy('timestamp', descending: true).limit(20);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.snapshots().map(
      (snapshot) =>
          snapshot.docs
              .map((doc) => ChatMessageModel.fromFirestore(doc))
              .toList(),
    );
  }

  Future<List<ChatMessageModel>> getMoreMessages(
    String chatRoomId, {
    required DocumentSnapshot lastDocument,
  }) async {
    final query = getChatRoomMessages(chatRoomId)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastDocument)
        .limit(20);

    final snapshot = await query.get();

    return snapshot.docs
        .map((doc) => ChatMessageModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<ChatRoomModel>> getChatRooms(String userId) {
    return _chatRoom
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ChatRoomModel.fromFirestore(doc))
                  .toList(),
        );
  }

  Stream<int> getUnreadCount(String chatRoomId, String userId) {
    return getChatRoomMessages(chatRoomId)
        .where('receiverId', isEqualTo: userId)
        .where('status', isEqualTo: MessageStatus.sent.toString())
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Future<void> markMessageAsRead(String chatRoomId, String userId) async {
    try {
      final batch = _firestore.batch();
      final messageDoc =
          await getChatRoomMessages(chatRoomId)
              .where('receiverId', isEqualTo: userId)
              .where('status', isEqualTo: MessageStatus.sent.toString())
              .get();

      for (var doc in messageDoc.docs) {
        batch.update(doc.reference, {
          'readBy': FieldValue.arrayUnion([userId]),
          'status': MessageStatus.read.toString(),
        });
      }
      await batch.commit();
    } catch (e) {
      print(e);
    }
  }

  Stream<Map<String, dynamic>> getUserStatus(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((
      snapshot,
    ) {
      final data = snapshot.data() as Map<String, dynamic>;
      return {
        'isOnline': data['isOnline'] ?? false,
        'lastSeen': data['lastSeen'],
      };
    });
  }

  Future<void> setUserOnline(String userId, bool isOnline) async {
    await _firestore.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': Timestamp.now(),
    });
  }

  Future<void> setUserTypingStatus(String chatRoomId, String userId) async {
    await _chatRoom.doc(chatRoomId).update({
      'typingUserId': userId,
      'isTyping': true,
    });
  }

  Stream<Map<String, dynamic>> getUserTypingStatus(String chatRoomId) {
    return _chatRoom.doc(chatRoomId).snapshots().map((snapshot) {
      if (!snapshot.exists) {
        return {'isTyping': false, 'typingUserId': null};
      }
      final data = snapshot.data() as Map<String, dynamic>;
      return {
        'isTyping': data['isTyping'] ?? false,
        'typingUserId': data['typingUserId'],
      };
    });
  }
}
