import 'package:chat_app/data/models/chat_room_model.dart';
import 'package:chat_app/data/repositories/chat_repository.dart';
import 'package:chat_app/data/services/service.locator.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  final ChatRoomModel chat;
  final VoidCallback onTap;
  final String currentUserId;

  const ChatListTile({
    super.key,
    required this.chat,
    required this.onTap,
    required this.currentUserId,
  });

  String _getContactName() {
    final otherUserId = chat.participants.firstWhere(
      (id) => id != currentUserId,
    );
    return chat.participantsName![otherUserId] ?? 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        child: Text(
          _getContactName()[0],
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        _getContactName(),
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Row(
        children: [
          Expanded(
            child: Text(
              chat.lastMessage ?? '',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      trailing: StreamBuilder<int>(
        stream: locator<ChatRepository>().getUnreadCount(
          chat.id,
          currentUserId,
        ),
        builder: (context, snapshot) {
          return snapshot.data != 0
              ? ClipOval(
                child: Container(
                  width: 20,
                  height: 20,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      snapshot.data?.toString() ?? '0',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
              : SizedBox.shrink();
        },
      ),
    );
  }
}
