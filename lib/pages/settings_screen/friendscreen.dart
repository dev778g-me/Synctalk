import 'package:chat/pages/chat/chat_page.dart';
import 'package:chat/pages/profile_page.dart';
import 'package:chat/provider/friend_requestuid.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class Friendscreen extends StatelessWidget {
  const Friendscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friendsProvider =
        Provider.of<FriendRequestuidprovider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends"),
      ),
      body: friendsProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : friendsProvider.friends.isEmpty
              ? const Center(child: Text('You Have No Friends'))
              : ListView.builder(
                  itemCount: friendsProvider.friends.length,
                  itemBuilder: (context, index) {
                    final friend = friendsProvider.friends[index];
                    return ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                userId: friend.uid,
                                name: friend.name,
                                imageUrl: friend.imageUrl,
                                about: friend.about,
                              ),
                            ),
                          );
                        },
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(friend.imageUrl),
                        ),
                      ),
                      title: Text(friend.name),
                      subtitle: Text(friend.about),
                      trailing: FilledButton.tonalIcon(
                        icon: const Icon(
                          Iconsax.message_21,
                          color: Colors.greenAccent,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        imageUrl: friend.imageUrl,
                                        name: friend.name,
                                        reciverId: friend.uid,
                                      )));
                          // Add chat functionality here
                        },
                        label: const Text('Chat'),
                      ),
                    );
                  },
                ),
    );
  }
}
