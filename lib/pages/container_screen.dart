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
    const Callscreen(),
    const StatusScreen(),
    SettingsScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: currentindex,
          onDestinationSelected: (value) {
            HapticFeedback.selectionClick();
            setState(() {
              currentindex = value;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.message_2),
              label: "Chat",
              selectedIcon: Icon(Iconsax.message_25),
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              label: "People",
              selectedIcon: Icon(Icons.people),
            ),
            NavigationDestination(
              icon: Icon(Iconsax.status),
              label: "Status",
              selectedIcon: Icon(Iconsax.status5),
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              label: "Settings",
              selectedIcon: Icon(Icons.settings),
            )
          ]),
      body: pages[currentindex],
    );
  }
}
