import 'package:chat/pages/chat/chat_page.dart';
import 'package:chat/provider/chathome.dart';
import 'package:flutter/material.dart';
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
  }

  // Function to handle refresh
  Future<void> _refreshData() async {
    await Provider.of<Chathome>(context, listen: false).getfriendlist();
  }

  @override
  Widget build(BuildContext context) {
    final friendshow = Provider.of<Chathome>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Messaging"),
      ),
      body: friendshow.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshData, // Trigger refresh when pulled
              child: ListView.builder(
                itemCount: friendshow.friends.length,
                itemBuilder: (context, index) {
                  final friendchat = friendshow.friends[index];
                  return ListTile(
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
    );
  }
}
