import 'package:chat/pages/callscreen.dart';
import 'package:chat/pages/home_screen.dart';
import 'package:chat/pages/settings_screen.dart';
import 'package:chat/pages/status_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class ContainerScreen extends StatefulWidget {
  const ContainerScreen({super.key});

  @override
  State<ContainerScreen> createState() => _ContainerScreenState();
}

class _ContainerScreenState extends State<ContainerScreen> {
  int currentindex = 0;
  List<Widget> pages = [
    const HomeScreen(),
    const StatusScreen(),
    const Callscreen(),
    SettingsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Iconsax.send_14),
      ),
      bottomNavigationBar: NavigationBar(
          selectedIndex: currentindex,
          onDestinationSelected: (value) {
            HapticFeedback.selectionClick();
            setState(() {
              currentindex = value;
            });
          },
          destinations: const [
            NavigationDestination(
                icon: Icon(Iconsax.message_text), label: "Chat"),
            NavigationDestination(icon: Icon(Iconsax.status), label: "Status"),
            NavigationDestination(icon: Icon(Icons.call_made), label: "Call"),
            NavigationDestination(
                icon: Icon(Iconsax.settings), label: "Settings")
          ]),
      body: pages[currentindex],
    );
  }
}
