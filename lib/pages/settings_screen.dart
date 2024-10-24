import 'package:chat/authentication/authservice.dart';
import 'package:chat/pages/settings_screen/apprence_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool selected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: const Text(
              "Settings",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                  'https://imgs.search.brave.com/3u5I5rzNjzhXUJHMzKUGmOphFLl3H73lDHcGYkTHwtc/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly90ZWNo/bG9naXRpYy5uZXQv/d3AtY29udGVudC91/cGxvYWRzLzIwMjIv/MDgvTW9ua2V5LUQt/THVmZnktUGZwLmpw/ZWc'),
            ),
            title: const Text("Nomad Happy"),
            trailing:
                FilledButton.tonal(onPressed: () {}, child: const Text("Edit")),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Text(
              "General",
              style: TextStyle(color: Theme.of(context).indicatorColor),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Iconsax.notification4),
            title: const Text("Notification"),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ApprenceScreen()));
            },
            leading: const Icon(Iconsax.teacher),
            title: const Text("Apprence"),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Iconsax.lock),
            title: const Text("Privacy "),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Iconsax.cloud),
            title: const Text("Storage & Data"),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Iconsax.info_circle),
            title: const Text("About"),
          ),
          ListTile(
            onTap: () {
              Authservice().logout();
            },
            leading: const Icon(Iconsax.logout),
            title: const Text(
              "Log Out",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
