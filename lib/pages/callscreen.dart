import 'package:chat/pages/profile_page.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat/provider/peopleprovider.dart';

class Callscreen extends StatelessWidget {
  const Callscreen({super.key});

  @override
  Widget build(BuildContext context) {
    final peopleprovider = Provider.of<Peopleprovider>(context);

    Future<void> _refreshData() async {
      await peopleprovider.fetchuser();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Peoples"),
      ),
      body: peopleprovider.isLoading
          ? RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: 10, // Only show 10 shimmer items while loading
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: FadeShimmer.round(
                      size: 50, // Set size for shimmer effect
                      fadeTheme: FadeTheme.light,
                    ),
                    title: const FadeShimmer(
                      height: 16,
                      width: 100,
                      radius: 8,
                      fadeTheme: FadeTheme.light,
                    ),
                    subtitle: const FadeShimmer(
                      height: 14,
                      width: 150,
                      radius: 8,
                      fadeTheme: FadeTheme.light,
                    ),
                  );
                },
              ),
            )
          : RefreshIndicator(
              onRefresh: _refreshData,
              child: ListView.builder(
                itemCount: peopleprovider.users.length,
                itemBuilder: (context, index) {
                  final user = peopleprovider.users[index];
                  return ListTile(
                    onTap: () {
                      print(user.name);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(
                            userId: user.id,
                            name: user.name,
                            imageUrl: user.imageurl,
                            about: user.about,
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.imageurl),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.about),
                  );
                },
              ),
            ),
    );
  }
}
