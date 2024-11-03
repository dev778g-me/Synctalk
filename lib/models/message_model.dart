import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderid;
  final String receiverid;
  final String text;
  final Timestamp createdat; // Store as Timestamp

  MessageModel({
    required this.senderid,
    required this.receiverid,
    required this.text,
    required this.createdat,
  });

  // Convert MessageModel to a Map
  Map<String, dynamic> tomap() {
    return {
      'senderid': senderid,
      'receiverid': receiverid,
      'text': text,
      'createdat': createdat, // Store directly as Timestamp
    };
  }
}
