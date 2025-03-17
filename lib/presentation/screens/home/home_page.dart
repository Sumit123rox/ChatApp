import 'package:chat_app/data/models/chat_room_model.dart';
import 'package:chat_app/data/repositories/auth_repository.dart';
import 'package:chat_app/data/repositories/chat_repository.dart';
import 'package:chat_app/data/repositories/contact_repository.dart';
import 'package:chat_app/data/services/service.locator.dart';
import 'package:chat_app/logic/cubits/auth/auth_cubit.dart';
import 'package:chat_app/presentation/screens/auth/login_page.dart';
import 'package:chat_app/presentation/screens/chat/chat_message_page.dart';
import 'package:chat_app/presentation/widgets/chat_list_tile.dart';
import 'package:chat_app/router/app_rounter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ContactRepository _contactRepository;
  late final ChatRepository _chatRepository;
  late final String _currentUserId;
  @override
  void initState() {
    _contactRepository = locator<ContactRepository>();
    _chatRepository = locator<ChatRepository>();
    _currentUserId = locator<AuthRepository>().currentUser?.uid ?? '';
    super.initState();
  }

  void fetchUserContacts() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Contacts",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _contactRepository.getContacts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshot.hasError) {
                      return Expanded(
                        child: Center(
                          child: Text(
                            "Error loading contacts: ${snapshot.error}",
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Expanded(
                        child: Center(child: Text("No contacts found")),
                      );
                    } else {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data?.length ?? 0,
                          itemBuilder: (context, index) {
                            final contact = snapshot.data![index];
                            return ListTile(
                              leading: CircleAvatar(
                                child:
                                    contact['photo'] != null
                                        ? ClipOval(
                                          child: Image.memory(
                                            contact['photo'],
                                            fit: BoxFit.cover,
                                            width: 40,
                                            height: 40,
                                          ),
                                        )
                                        : Text(
                                          contact['name'][0],
                                          style: TextStyle(color: Colors.white),
                                        ),
                              ),
                              title: Text(contact['name']),
                              subtitle: Text(contact['phoneNumber']),
                              onTap: () {
                                // Handle contact selection
                                locator<AppRouter>().pop();
                                locator<AppRouter>().push(
                                  ChatMessagePage(
                                    receiverId: contact['id'],
                                    receiverName: contact['name'],
                                    receiverImageOrText: CircleAvatar(
                                      child:
                                          contact['photo'] != null
                                              ? ClipOval(
                                                child: Image.memory(
                                                  contact['photo'],
                                                  fit: BoxFit.cover,
                                                  width: 40,
                                                  height: 40,
                                                ),
                                              )
                                              : Text(
                                                contact['name'][0],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await locator<AuthCubit>().signOut();
              locator<AppRouter>().pushAndRemoveUntil(LoginPage());
            },
            tooltip: "Logout",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fetchUserContacts,
        child: Icon(Icons.message, color: Colors.white),
      ),
      body: StreamBuilder<List<ChatRoomModel>>(
        stream: _chatRepository.getChatRooms(_currentUserId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No chats found"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final chat = snapshot.data![index];
              return ChatListTile(
                chat: chat,
                onTap: () {
                  final otherUserId = chat.participants.firstWhere(
                    (id) => id != _currentUserId,
                  );
                  locator<AppRouter>().push(
                    ChatMessagePage(
                      receiverId: otherUserId,
                      receiverName:
                          chat.participantsName![otherUserId] ?? 'Unknown',
                      receiverImageOrText: CircleAvatar(
                        child: Text(
                          (chat.participantsName![otherUserId] ?? 'U')[0],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
                currentUserId: _currentUserId,
              );
            },
          );
        },
      ),
    );
  }
}
