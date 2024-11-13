import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? _userData;
  bool _isloading = false;
  Map<String, dynamic>? get userData => _userData;
  bool get isloading => _isloading;

  Future<void> fetchUserData(String uid) async {
    try {
      _isloading = true;
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      _userData = userDoc.data() as Map<String, dynamic>?;
      _isloading = false;
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
