import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  uploaddata(String name, String about, String uid) async {
    if (name.isEmpty || about.isEmpty) {
      print("please fill name ad abot");
    } else {
      try {
        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          "name": name,
          "about": about,
          "uid": uid,
          "updated_at": FieldValue.serverTimestamp()
        }, SetOptions(merge: true));
      } catch (e) {}
    }
  }

  Future<String?> uploadImage(File imageFile, String uid) async {
    try {
      // Create a reference to the storage location
      final ref = _storage.ref().child(
          "User Images/${uid}/${DateTime.now().millisecondsSinceEpoch}.png");

      // Upload the file to the storage
      await ref.putFile(imageFile);

      // Once the upload is complete, get the download URL
      final String imageUrl = await ref.getDownloadURL();

      print("Image uploaded successfully: $imageUrl");
      return imageUrl; // Return the download URL
    } catch (e) {
      print("Error uploading image: ${e.toString()}");
      return null; // Return null if there's an error
    }
  }
}
