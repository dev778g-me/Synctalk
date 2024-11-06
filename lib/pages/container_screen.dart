import 'package:chat/pages/callscreen.dart';
import 'package:chat/pages/home_screen.dart';
import 'package:chat/pages/settings_screen.dart';
import 'package:chat/pages/status_screen.dart';
import 'package:flutter/material.dart';
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
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          selectedIndex: currentindex,
          onDestinationSelected: (value) {
            setState(() {
              currentindex = value;
            });
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Iconsax.message_2),
              label: "Chat",
              selectedIcon: Icon(
                Iconsax.message_25,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            NavigationDestination(
              icon: const Icon(Icons.people_outline),
              label: "People",
              selectedIcon: Icon(
                Icons.people,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            NavigationDestination(
              icon: const Icon(Iconsax.status),
              label: "Status",
              selectedIcon: Icon(
                Iconsax.status5,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              label: "Settings",
              selectedIcon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary,
              ),
            )
          ]),
      body: pages[currentindex],
    );
  }
}
