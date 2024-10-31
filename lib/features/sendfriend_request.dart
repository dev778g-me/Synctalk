import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class SendFriendRequest {
  Future<void> sendFriendRequest(
    String recipientUid,
    String senderUid,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(recipientUid)
          .update({
        "friendrequests": FieldValue.arrayUnion([
          {
            "sender_uid": senderUid,
            "status": "pending",
          }
        ])
      });
      debugPrint("Friend request sent successfully!");
    } catch (e) {
      debugPrint("Error sending friend request: $e");
    }
  }
}
