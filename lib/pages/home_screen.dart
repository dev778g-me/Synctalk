import 'package:chat/api.dart';
import 'package:chat/pages/chat/chat_page.dart';
import 'package:chat/pages/settings_screen.dart';
import 'package:chat/provider/chathome.dart';
import 'package:chat/provider/userdataprovider.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load the data when the screen is initialized
    Provider.of<Chathome>(context, listen: false).getfriendlist();
    Provider.of<UserProvider>(context, listen: false)
        .fetchUserData(Api.useruid);
  }

  // Function to handle refresh
  Future<void> _refreshData() async {
    await Provider.of<Chathome>(context, listen: false).getfriendlist();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.userData;
    final friendshow = Provider.of<Chathome>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.search_normal)),
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.more_2))
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, right: 2),
          child: GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
            child: CircleAvatar(
              backgroundImage: userData == null
                  ? const AssetImage('assets/synctalk.png')
                  : NetworkImage(userData['imageurl']),
            ),
          ),
        ),
        title: const Text("SyncTalk"),
      ),
      body: friendshow.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData, // Trigger refresh when pulled
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: friendshow.friends.length,
                  itemBuilder: (context, index) {
                    final friendchat = friendshow.friends[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    reciverId: friendchat.uid,
                                    imageUrl: friendchat.imageUrl,
                                    name: friendchat.name)));
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(friendchat.imageUrl),
                      ),
                      title: Text(friendchat.name),
                      subtitle: const Text('data'),
                      trailing: const Icon(
                        Icons.adb,
                        color: Colors.green,
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }
}
