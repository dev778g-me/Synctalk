import 'package:chat/authentication/login_screen.dart';
import 'package:chat/pages/container_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    var logsignauth = FirebaseAuth.instance.authStateChanges();
    return Scaffold(
      body: StreamBuilder(
        stream: logsignauth,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const ContainerScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
