import 'package:cloud_firestore/cloud_firestore.dart';

class SendFriendRequest {
  Future<void> sendFriendRequest(String recipientUid, String senderUid) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(recipientUid)
          .collection('friendRequests')
          .doc(senderUid)
          .set({
        "senderUid": senderUid,
        "status": "pending",
        "time": FieldValue.serverTimestamp(),
      });
      print("Friend request sent successfully!");
    } catch (e) {
      print("Error sending friend request: $e");
    }
  }
}
