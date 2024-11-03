import 'package:chat/api.dart';
import 'package:chat/provider/chat_service.dart';
import 'package:chat/models/message_model.dart'; // Ensure this model exists and is mapped correctly
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

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
  final ChatUser currentUser = ChatUser(id: Api.useruid, firstName: 'You');
  final ChatService chatService = ChatService();

  void sendMessage(String message) async {
    await chatService.sendmessage(widget.reciverId, message);
  }

  String formatMessageTime(DateTime time) {
    final now = DateTime.now();
    if (now.year == time.year &&
        now.month == time.month &&
        now.day == time.day) {
      return DateFormat.Hm().format(time);
    } else {
      return DateFormat.yMd().format(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.imageUrl),
              radius: 20,
            ),
            const SizedBox(width: 12),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Iconsax.video), onPressed: () {}),
          IconButton(icon: const Icon(Iconsax.call), onPressed: () {}),
          IconButton(icon: const Icon(Iconsax.more), onPressed: () {}),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatService.getmessages(Api.useruid, widget.reciverId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading messages'));
          }

          // Convert Firestore documents to ChatMessage instances
          final messages = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return ChatMessage(
                user: ChatUser(id: data['senderid']),
                text: data['text'],
                createdAt: (data['createdat'] as Timestamp).toDate());
          }).toList();

          return DashChat(
            messageListOptions: const MessageListOptions(
                scrollPhysics: BouncingScrollPhysics()),
            currentUser: currentUser,
            onSend: (ChatMessage message) {
              sendMessage(message.text); // Trigger message sending
            },
            messages: messages,
            inputOptions: InputOptions(
              sendButtonBuilder: (send) => IconButton(
                icon: Icon(Iconsax.send_1,
                    color: Theme.of(context).colorScheme.primary),
                onPressed: send,
              ),
              inputDecoration: InputDecoration(
                prefixIcon: IconButton(
                    onPressed: () {}, icon: const Icon(Iconsax.emoji_happy)),
                hintText: 'Type a message...',
                filled: true,
                fillColor: Theme.of(context).colorScheme.inversePrimary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
            ),
            messageOptions: MessageOptions(
              showTime: true,
              textBeforeMedia: true,
              currentUserContainerColor: Colors.deepPurple.shade400,
              showOtherUsersName: true,
              messageTimeBuilder: (message, isOwnMessage) {
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    formatMessageTime(message.createdAt),
                    style: TextStyle(
                      fontSize: 12,
                      color: isOwnMessage ? Colors.black54 : Colors.black38,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
