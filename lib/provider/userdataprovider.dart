import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  Map<String, dynamic>? get userData => _userData;

  Future<void> fetchUserData(String uid) async {
    try {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      _userData = userDoc.data() as Map<String, dynamic>?;
      notifyListeners();
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  Future getfriendrequest(String uid) async {
    try {
      var uname =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      print(uname);
    } catch (e) {}
  }
}
