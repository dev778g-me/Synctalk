import 'package:chat/features/sendfriend_request.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class ProfilePage extends StatelessWidget {
  final String userId; // To uniquely identify each user
  final String name;
  final String imageUrl;
  final String about;
  const ProfilePage(
      {super.key,
      required this.userId,
      required this.name,
      required this.imageUrl,
      required this.about});

  @override
  Widget build(BuildContext context) {
    final currentuserid = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(imageUrl),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                name,
                style: TextStyle(
                    fontSize: 30, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            FilledButton.tonalIcon(
              onPressed: () {
                SendFriendRequest().sendFriendRequest(userId, currentuserid);
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("send friend request ")));
              },
              label: const Text("Send Friend Request"),
              icon: const Icon(Iconsax.user_cirlce_add),
            )
          ],
        ),
      ),
    );
  }
}
