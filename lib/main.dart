import 'package:chat/authentication/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Your container screen import
import 'package:google_fonts/google_fonts.dart';

// Import your color schemes
import 'themes/themes.dart'; // Assuming the ColorScheme definitions are here

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
  );

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Chat App",

      // Apply the light and dark themes
      theme: ThemeData.from(
          colorScheme: flexSchemeLight,
          textTheme: GoogleFonts.poppinsTextTheme()),
      darkTheme: ThemeData.from(
          colorScheme: flexSchemeDark,
          textTheme: GoogleFonts.poppinsTextTheme()),

      themeMode:
          ThemeMode.system, // Automatically switch based on system setting
      home: Wrapper(),
    );
  }
}
