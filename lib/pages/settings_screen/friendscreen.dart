import 'package:chat/provider/friend_requestuid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Friendscreen extends StatelessWidget {
  const Friendscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final friensprovider =
        Provider.of<FriendRequestuidprovider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
      ),
      body: friensprovider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : friensprovider.friends.isEmpty
              ? const Center(
                  child: Text('You Have No friends'),
                )
              : ListView.builder(
                  itemBuilder: (context, index) {
                    final friend = friensprovider.friends[index];
                    return ListTile(
                      title: Text(friend.name),
                    );
                  },
                ),
    );
  }
}
