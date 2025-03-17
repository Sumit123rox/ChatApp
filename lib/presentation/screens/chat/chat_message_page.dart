import 'package:chat_app/core/utils/common_extensions.dart';
import 'package:chat_app/data/services/service.locator.dart';
import 'package:chat_app/logic/cubits/chat/chat_cubit.dart';
import 'package:chat_app/logic/cubits/chat/chat_state.dart';
import 'package:chat_app/presentation/widgets/back_button.dart';
import 'package:chat_app/presentation/widgets/message_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessagePage extends StatefulWidget {
  final String receiverId;
  final String receiverName;
  final Widget receiverImageOrText;

  const ChatMessagePage({
    super.key,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImageOrText,
  });

  @override
  State<ChatMessagePage> createState() => _ChatMessagePageState();
}

class _ChatMessagePageState extends State<ChatMessagePage> {
  final TextEditingController _messageController = TextEditingController();
  late ChatCubit _chatCubit;

  @override
  void initState() {
    _chatCubit = locator<ChatCubit>();
    _chatCubit.enterChat(widget.receiverId);
    super.initState();
  }

  Future<void> _handleSendMessage() async {
    await _chatCubit.sendMessage(
      message: _messageController.text.trim(),
      receiverid: widget.receiverId,
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(),
        title: Row(
          children: [
            widget.receiverImageOrText,
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.receiverName),
                SizedBox(height: 2),
                BlocBuilder<ChatCubit, ChatState>(
                  bloc: _chatCubit,
                  builder: (context, state) {
                    return Text(state.isReceiverOnline ? 'Online' : 'Offline');
                  },
                )
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: BlocBuilder<ChatCubit, ChatState>(
        bloc: _chatCubit,
        builder: (context, state) {
          if (state.status == ChatStatus.loading ||
              state.status == ChatStatus.initial) {
            return Center(child: CircularProgressIndicator());
          } else if (state.status == ChatStatus.error) {
            return Center(child: Text(state.error ?? 'An error occurred'));
          } else if (state.status == ChatStatus.loaded) {
            return Column(
              children: [
                Expanded(
                  child: CustomScrollView(
                    reverse: true,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.all(10),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            // Reverse the index to display messages in reverse order
                            /* final reversedIndex =
                                state.messages.length - 1 - index; */
                            final message = state.messages[index];
                            return Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: MessageBubble(
                                message: message,
                                isOwner: message.senderId.isOwn(),
                                showTime: true,
                                /* isDelivered: true,
                                    isRead: true, */
                              ),
                            );
                          }, childCount: state.messages.length),
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Emoji button
                      IconButton(
                        icon: Icon(Icons.emoji_emotions),
                        onPressed: () {},
                      ),

                      // Text field
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Type a message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                      ),

                      // Camera button
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () {},
                      ),

                      // Send button
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: _handleSendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center();
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatCubit.leaveChat();
    super.dispose();
  }
}
