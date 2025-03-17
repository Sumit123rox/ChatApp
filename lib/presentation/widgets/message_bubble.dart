import 'package:chat_app/data/models/chat_message_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isOwner;
  final bool showTime;
  const MessageBubble({
    super.key,
    required this.message,
    required this.isOwner,
    required this.showTime,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: isOwner ? 64 : 8,
          right: isOwner ? 8 : 64,
          bottom: 4,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isOwner ? Color(0xFFDCF8C6) : Colors.grey,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(message.content, style: TextStyle(color: Colors.black54)),
            // Time and status - always aligned to end
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('h:mm a').format(message.timestamp.toDate()),
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
                if (isOwner) SizedBox(width: 5),
                if (isOwner)
                  Icon(
                    message.status == MessageStatus.read
                        ? Icons.done_all
                        : Icons.done,
                    size: 14,
                    color:
                        message.status == MessageStatus.read
                            ? Colors.blue
                            : Colors.black54,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
