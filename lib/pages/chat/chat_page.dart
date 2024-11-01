import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChatPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leadingWidth: 30, // Optimal width for back button
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            CircleAvatar(backgroundImage: NetworkImage(imageUrl), radius: 20),
            const SizedBox(width: 12), // Adds spacing between avatar and name
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.video),
            onPressed: () {
              // Add video call functionality here
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.call),
            onPressed: () {
              // Add voice call functionality here
            },
          ),
          IconButton(
            icon: const Icon(Iconsax.more),
            onPressed: () {
              // Add more options functionality here
            },
          ),
        ],
      ),
      body: const Center(
        child: Text("Chat content goes here"),
      ),
    );
  }
}
