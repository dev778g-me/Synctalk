import 'package:chat/models/usermodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Peopleprovider extends ChangeNotifier {
  List<Usermodel> _users = [];
  bool _isloading = true;
  List<Usermodel> get users => _users;
  bool get isLoading => _isloading;
  Peopleprovider() {
    fetchuser();
  }

  fetchuser() async {
    try {
      _isloading = true;
      final currentuser = FirebaseAuth.instance.currentUser;
      final currentuserid = currentuser!.uid;
      final snapshot =
          await FirebaseFirestore.instance.collection('users').get();
      _users = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Usermodel(
            id: doc.id,
            imageurl: data["imageurl"],
            name: data["name"],
            about: data["about"]);
      }).toList();
      _users.removeWhere((users) => users.id == currentuserid);
    } catch (e) {
      print(e.toString());
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
