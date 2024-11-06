import 'package:chat/api.dart';
import 'package:chat/models/friendrequest.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FriendRequestuidprovider extends ChangeNotifier {
  List<FriendRequestUser> friendRequests = [];
  List<FriendRequestUser> friends = [];
  bool isLoading = true;

  FriendRequestuidprovider() {
    fetchFriendRequests();
  }
  Future<void> fetchFriendRequests() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(Api.useruid)
          .get();
      //storing the friendrequest array
      List<dynamic> requests = documentSnapshot['friendrequests'] ?? [];
      friendRequests = await Future.wait(requests.map((requests) async {
        String senderuid = requests['sender_uid'];
//getting the user data from the firebase
        DocumentSnapshot senderdoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(senderuid)
            .get();
        return FriendRequestUser.fromFirestore(
            senderuid, senderdoc.data() as Map<String, dynamic>);
      }));
    } catch (e) {
      debugPrint("Error fetching friend requests: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptfriendrequest(String senderuid) async {
    try {
      final currentuserid = Api.useruid;
      //update friend list of the current user
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentuserid)
          .update({
        "friends": FieldValue.arrayUnion([
          {"friend_uid": senderuid}
        ])
      });

      //update the friend list of the sender
      await FirebaseFirestore.instance
          .collection('users')
          .doc(senderuid)
          .update({
        "friends": FieldValue.arrayUnion([
          {"friend_uid": currentuserid}
        ])
      });
//removing the userid from the friend request array from firebase firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentuserid)
          .update({
        "friendrequests": FieldValue.arrayRemove([
          {"sender_uid": senderuid, "status": "pending"}
        ])
      });
      friendRequests.removeWhere((request) => request.uid == senderuid);

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//reject friend request it will remove the sender id from the friend requests list
  Future<void> rejectfriendrequest(String senderid) async {
    try {
      final currentuseruid = Api.useruid;
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentuseruid)
          .update({
        'friendrequests': FieldValue.arrayRemove([
          {"sender_uid": senderid, "status": "pending"}
        ])
      });
      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //get your friend list
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
}
