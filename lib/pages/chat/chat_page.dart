import 'package:chat/api.dart';
import 'package:chat/provider/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

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
  List<ChatMessage> messages = [];

  @override
  void initState() {
    super.initState();
    currentuser = ChatUser(
      id: Api.useruid,
      firstName: 'h',
    );
    otheruser = ChatUser(
        id: widget.reciverId,
        firstName: widget.name,
        profileImage: widget.imageUrl);
    fetchMessages(); // Call fetchMessages when the chat page initializes
  }

  void fetchMessages() async {
    String chatId =
        ChatService().generateChatId(uid1: Api.useruid, uid2: widget.reciverId);

    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final chatData = snapshot.data() as Map<String, dynamic>;
        final List<dynamic> textData = chatData['text'] ?? [];

        // Sort messages by timestamp
        final sortedMessages = textData.map((message) {
          return ChatMessage(
            text: message['message'],
            user: ChatUser(id: message['senderid']),
            createdAt: message['timestamp'].toDate(),
          );
        }).toList();

        // Sort messages based on createdAt (timestamp)
        sortedMessages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        setState(() {
          messages = sortedMessages; // Update messages with sorted messages
        });
      }
    });
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
        body: DashChat(
            messageOptions: MessageOptions(
              onLongPressMessage: (p0) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog();
                    });
              },
              containerColor: Theme.of(context).colorScheme.primaryFixed,
              currentUserContainerColor: Theme.of(context).colorScheme.primary,
              showOtherUsersAvatar: true,
              showTime: true,
            ),
            inputOptions: InputOptions(
              inputDecoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .primaryContainer, // Background color
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none, // No border when not focused
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  // Light border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  // Color when focused
                ),
                prefixIcon: IconButton(
                  icon: const Icon(Icons.emoji_emotions_outlined,
                      color: Colors.grey),
                  onPressed: () {
                    // Add emoji picker functionality here
                  },
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.attach_file, color: Colors.grey),
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
                    size: 25, color: Theme.of(context).colorScheme.primary),
                onPressed: send,
              ),
            ),
            currentUser: currentuser!,
            onSend: sendMessage,
            messages:
                messages.reversed.toList() // Bind the sorted messages here
            ));
  }
}
