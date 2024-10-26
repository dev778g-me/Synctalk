import 'package:cloud_firestore/cloud_firestore.dart';

class Getdata {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Map<String, dynamic>?> getuserdata(String uid) async {
    try {
      DocumentSnapshot userdoc =
          await _firestore.collection('users').doc(uid).get();
      if (userdoc.exists) {
        return userdoc.data() as Map<String, dynamic>?;
      } else {
        print("user document does not exist");
        return null;
      }
    } catch (e) {
      print("error${e.toString()}");
      return null;
    }
  }
}
