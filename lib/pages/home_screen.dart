import 'package:chat/pages/contacts_screen/contactsscreen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Contactsscreen()));
        },
        child: const Icon(Iconsax.message_21),
      ),
      appBar: AppBar(
        elevation: 0,
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
        title: const Text("Start Messaging !!"),
      ),
    );
  }
}
