import 'package:chat/provider/friend_requestuid.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final frienduidprovider = Provider.of<FriendRequestuidprovider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Notifications"),
          actions: [
            IconButton(
                onPressed: () async {
                  await frienduidprovider.fetchFriendRequests();
                },
                icon: const Icon(Iconsax.refresh))
          ],
        ),
        body: frienduidprovider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : frienduidprovider.friendRequests.isEmpty
                ? const Center(child: Text("No friend requests"))
                : ListView.builder(
                    itemCount: frienduidprovider.friendRequests.length,
                    itemBuilder: (context, index) {
                      final user = frienduidprovider.friendRequests[index];
                      return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.imageUrl),
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.about),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton.filledTonal(
                                  onPressed: () {
                                    frienduidprovider
                                        .acceptfriendrequest(user.uid);
                                  },
                                  icon: const Icon(
                                    Iconsax.user_add,
                                    color: Colors.greenAccent,
                                  )),
                              IconButton.filledTonal(
                                  onPressed: () {
                                    frienduidprovider
                                        .rejectfriendrequest(user.uid);
                                  },
                                  icon: const Icon(
                                    Iconsax.user_remove,
                                    color: Colors.red,
                                  )),
                            ],
                          ));
                    },
                  ));
  }
}
