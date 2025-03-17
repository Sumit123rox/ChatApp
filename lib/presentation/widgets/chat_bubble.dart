import 'package:chat_app/data/models/chat_message_model.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessageModel message;
  final bool isOwner;
  final bool showTime;
  final bool isDelivered;
  final bool isRead;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isOwner,
    required this.showTime,
    this.isDelivered = false,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    // final timeString = DateFormat('h:mm a').format(showTime);

    return Align(
      alignment: isOwner ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 5),
          decoration: BoxDecoration(
            color:
                isOwner ? Color(0xFFDCF8C6) : Colors.white, // WhatsApp colors
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isOwner ? 16 : 0),
              topRight: Radius.circular(isOwner ? 0 : 16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: Colors.black.withValues(alpha: 0.1),
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
                isOwner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Message content
              Text(
                message.content,
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),

              // Spacer
              SizedBox(height: 3),

              // Time and status - always aligned to end
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "1:20 PM",
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    if (isOwner) SizedBox(width: 5),
                    if (isOwner)
                      Icon(
                        isRead
                            ? Icons.done_all
                            : (isDelivered ? Icons.done_all : Icons.done),
                        size: 14,
                        color: isRead ? Colors.blue : Colors.black54,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
