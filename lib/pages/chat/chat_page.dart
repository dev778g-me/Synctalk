import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'package:chat/api.dart';

import 'package:chat/provider/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String reciverId;
  final String imageUrl;
  final String name;

  const ChatPage({
    super.key,
    required this.reciverId,
    required this.imageUrl,
    required this.name,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  ChatUser? currentuser;
  ChatUser? otheruser;

  @override
  void initState() {
    currentuser = ChatUser(
      id: Api.useruid,
      firstName: 'user1',
    );
    otheruser = ChatUser(
        id: widget.reciverId,
        firstName: widget.name,
        profileImage: widget.imageUrl);
    super.initState();
  }

  // METHOD FOR SENDING MESSAGE
  Future<void> sendMessage(ChatMessage message) async {
    try {
      String chatId = ChatService()
          .generateChatId(uid1: Api.useruid, uid2: widget.reciverId);
      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        "participents": FieldValue.arrayUnion([Api.useruid, widget.reciverId]),
        "text": FieldValue.arrayUnion([
          {
            'message': message.text,
            "senderid": currentuser!.id,
            "timestamp": Timestamp.now()
          }
        ])
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    String chatId =
        ChatService().generateChatId(uid1: Api.useruid, uid2: widget.reciverId);

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 30,
          elevation: 10,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.imageUrl),
                radius: 20,
              ),
              const SizedBox(width: 12),
              Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Iconsax.video),
              onPressed: () {},
            ),
            IconButton(icon: const Icon(Iconsax.call), onPressed: () {}),
            IconButton(icon: const Icon(Iconsax.more), onPressed: () {}),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .doc(chatId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || !snapshot.data!.exists) {
                return const Center(child: Text('Start a conversation!'));
              }

              final chatData = snapshot.data!.data() as Map<String, dynamic>;
              final List<dynamic> textData = chatData['text'] ?? [];

              final messages = textData.map((message) {
                return ChatMessage(
                  text: message['message'],
                  user: ChatUser(id: message['senderid']),
                  createdAt: message['timestamp'].toDate(),
                );
              }).toList();

              // Sort messages based on createdAt (timestamp)
              messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

              return DashChat(
                  messageOptions: MessageOptions(
                    messageTextBuilder:
                        (message, previousMessage, nextMessage) {
                      int hour = message.createdAt.hour;
                      int minute = message.createdAt.minute;
                      bool isCurrentUser = message.user.id == currentuser!.id;
                      // Convert to 12-hour format
                      String ampm = hour >= 12 ? 'PM' : 'AM';
                      hour = hour % 12;
                      hour = hour == 0
                          ? 12
                          : hour; // If hour is 0, set it to 12 for 12 AM

                      // Format minute to ensure two digits
                      String formattedTime =
                          '  $hour:${minute.toString().padLeft(2, '0')} $ampm';

                      return RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: message.text,
                            style: TextStyle(
                                color: isCurrentUser
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.shadow)),
                        TextSpan(
                          style: TextStyle(
                              fontSize: 10,
                              color: isCurrentUser
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.shadow),
                          text: formattedTime,
                        )
                      ]));
                    },
                    messagePadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    onLongPressMessage: (p0) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog();
                          });
                    },
                    currentUserContainerColor: const Color(0xFF2962FF),
                    containerColor:
                        Theme.of(context).colorScheme.surfaceContainerLow,
                    showOtherUsersAvatar: true,
                    avatarBuilder: (p0, onPressAvatar, onLongPressAvatar) {
                      p0.profileImage = widget.imageUrl;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(widget.imageUrl),
                        ),
                      );
                    },
                    showTime: true,
                  ),
                  inputOptions: InputOptions(
                    inputTextStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    inputDecoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),

                      filled: true,
                      fillColor: Theme.of(context)
                          .colorScheme
                          .surfaceContainerLow, // Background color
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide:
                            BorderSide.none, // No border when not focused
                      ),

                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.emoji_emotions_outlined,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          // Add emoji picker functionality here
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          Icons.attach_file,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        onPressed: () {
                          // Attach files or images
                        },
                      ),
                    ),
                    alwaysShowSend: true, // Show send button at all times
                    sendButtonBuilder: (send) => IconButton.filledTonal(
                      splashRadius: 10,
                      iconSize: 30,
                      icon: Icon(Iconsax.send_14,
                          size: 25,
                          color: Theme.of(context).colorScheme.primary),
                      onPressed: send,
                    ),
                  ),
                  currentUser: currentuser!,
                  onSend: sendMessage,
                  messages: messages.reversed
                      .toList() // Bind the sorted messages here
                  );
            }));
  }
}
