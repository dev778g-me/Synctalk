import 'package:chat/pages/callscreen.dart';
import 'package:chat/pages/home_screen.dart';
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
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
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
              icon: const Icon(Iconsax.story),
              label: "Status",
              selectedIcon: Icon(
                Iconsax.story5,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ]),
      body: pages[currentindex],
    );
  }
}
