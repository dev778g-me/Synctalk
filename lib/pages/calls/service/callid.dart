import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CallIdService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final Uuid _uuid = Uuid();

  // Generate a unique call ID
  static String generateCallId() {
    return _uuid.v4(); // Generates a random UUID
  }

  // Check if call ID exists
  static Future<bool> isCallIdAvailable(String callId) async {
    final doc = await _firestore.collection('calls').doc(callId).get();
    return !doc.exists;
  }

  // Create a new call entry
  static Future<String> createCall(String userId) async {
    String callId;
    do {
      callId = generateCallId();
    } while (!await isCallIdAvailable(callId));

    await _firestore.collection('calls').doc(callId).set({
      'creatorId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'status': 'pending'
    });

    return callId;
  }
}
