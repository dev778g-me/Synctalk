import 'package:chat/pages/calls/zego.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class Callz extends StatelessWidget {
  Callz({super.key});
  final callid = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextField(
                controller: callid,
                decoration: const InputDecoration(
                    labelText: "Enter caller id ",
                    border: OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FilledButton.tonalIcon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CallPage(
                    callId: "1234",
                  );
                }));
              },
              label: const Text("Start Call"),
              icon: const Icon(Iconsax.call),
            )
          ],
        ),
      ),
    );
  }
}
