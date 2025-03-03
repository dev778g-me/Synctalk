import 'package:chat/test.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          requestStoragePermission(context);
        },
        label: const Text("Add Story"),
        icon: const Icon(Iconsax.slider_horizontal_1),
      ),
      appBar: AppBar(
        title: const Text("Status"),
      ),
    );
  }
}
