import 'package:chat/api.dart';
import 'package:chat/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  Future<void> sendmessage(String reciverid, String message) async {
    final Timestamp timestamp = Timestamp.now();
    final currentuseruid = Api.useruid;

    // Create a new MessageModel with Timestamp
    MessageModel newmessage = MessageModel(
      senderid: currentuseruid,
      receiverid: reciverid,
      text: message,
      createdat: timestamp, // Directly use Timestamp here
    );

    List<String> ids = [currentuseruid, reciverid];
    ids.sort();
    String chatroomid = ids.join("_");

    await FirebaseFirestore.instance
        .collection("chats")
        .doc(chatroomid)
        .collection('messages')
        .add(newmessage.tomap()); // Store MessageModel as Map
  }

  Stream<QuerySnapshot> getmessages(String userid, String otheruserid) {
    List<String> ids = [userid, otheruserid];
    ids.sort();
    String chatroomid = ids.join("_");
    return FirebaseFirestore.instance
        .collection("chats")
        .doc(chatroomid)
        .collection('messages')
        .orderBy("createdat", descending: false)
        .snapshots();
  }
}
