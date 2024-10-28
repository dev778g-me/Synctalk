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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Peoples"),
      ),
      body: peopleprovider.isLoading
          ? ListView.builder(
              itemCount:
                  100, // Showing a fixed number of shimmer items while loading
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
            )
          : ListView.builder(
              itemCount: peopleprovider.users.length,
              itemBuilder: (context, index) {
                final user = peopleprovider.users[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                                userId: user.id,
                                name: user.name,
                                imageUrl: user.imageurl,
                                about: user.about)));
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user.imageurl),
                  ),
                  title: Text(user.name),
                  subtitle: Text(user.about),
                );
              },
            ),
    );
  }
}
