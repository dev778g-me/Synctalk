import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  signin(String email, String password) async {
    try {
      final usercred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return usercred;
    } on FirebaseAuthException catch (e) {
      // TODO
      print(e);
    }
  }

  craeteaccount(String email, String password) async {
    try {
      final usercred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return usercred;
    } on FirebaseAuthException catch (e) {
      // TODO
      print(e);
    }
  }

  logout() async {
    FirebaseAuth.instance.signOut();
  }
}
