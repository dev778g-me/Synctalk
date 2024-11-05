import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String chatid;
  final String senderid;
  final String receiverid;
  final List text;
  final Timestamp createdat; // Store as Timestamp

  MessageModel({
    required this.chatid,
    required this.senderid,
    required this.receiverid,
    required this.text,
    required this.createdat,
  });

  // Convert MessageModel to a Map
  Map<String, dynamic> tomap() {
    return {
      'chatid': chatid,
      'senderid': senderid,
      'receiverid': receiverid,
      'text': [],
      'createdat': createdat, // Store directly as Timestamp
    };
  }
}
