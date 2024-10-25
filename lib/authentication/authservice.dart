import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  googlesignin() async {
    final GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleauth =
        await googleuser?.authentication;
    final cred = GoogleAuthProvider.credential(
        accessToken: googleauth?.accessToken, idToken: googleauth?.idToken);
    await FirebaseAuth.instance.signInWithCredential(cred);
  }
}
