import 'package:chat/api.dart';
import 'package:chat/models/friendrequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Chathome extends ChangeNotifier {
  List<FriendRequestUser> friends = [];
  bool isLoading = true;
  Chathome() {
    getfriendlist();
  }

  Future<void> getfriendlist() async {
    try {
      DocumentSnapshot friendlistsnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(Api.useruid)
          .get();

      // Retrieve friend data - adjust to handle both string or map format
      List<dynamic> friendsData = friendlistsnap["friends"] ?? [];

      // Map to retrieve UIDs based on format
      friends = await Future.wait(friendsData.map((friend) async {
        // Case where each friend entry is a simple UID (String)
        String friendUid;
        if (friend is String) {
          friendUid = friend;
        }
        // Case where each friend entry is a map containing the UID
        else if (friend is Map<String, dynamic>) {
          friendUid = friend['friend_uid'] as String;
        } else {
          throw Exception("Unexpected friend entry format: $friend");
        }

        // Fetch friend data from Firestore using the UID
        DocumentSnapshot friendDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(friendUid)
            .get();

        return FriendRequestUser.fromFirestore(
            friendUid, friendDoc.data() as Map<String, dynamic>);
      }).toList());
    } on Exception catch (e) {
      debugPrint("Error fetching friend list: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getlastmessage() async {}
}
