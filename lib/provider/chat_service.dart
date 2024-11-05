import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatService {
  // Generates a unique chat room ID for two users
  String generateChatId({required String uid1, required String uid2}) {
    List<String> uids = [uid1, uid2];
    uids.sort();
    return uids.join();
  }

  // Checks if a chat exists between two users
  Future<bool> checkChatExist(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    final result =
        await FirebaseFirestore.instance.collection('chats').doc(chatId).get();
    debugPrint(result.exists.toString());
    return result.exists;
  }

  // Creates a new chat between two users if one does not already exist
  Future<void> createNewChat(String uid1, String uid2) async {
    String chatId = generateChatId(uid1: uid1, uid2: uid2);
    try {
      await FirebaseFirestore.instance.collection('chats').doc(chatId).set({
        'senderId': uid1,
        'receiverId': uid2,
        'text': [], // Initialize the text array to store messages
        'createdAt': Timestamp.now(),
        'chatId': chatId,
      });
    } catch (e) {
      debugPrint("Error creating chat: $e");
    }
  }

  // Adds a new message to the chat's text array
  Future<void> sendMessage(String chatId, String message) async {
    try {
      await FirebaseFirestore.instance.collection('chats').doc(chatId).update({
        'text': FieldValue.arrayUnion([
          {
            'message': message,
            'timestamp': Timestamp.now(),
          }
        ]),
      });
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }
}
