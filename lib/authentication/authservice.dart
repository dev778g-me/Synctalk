import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authservice {
  // Sign in with email and password
  Future<UserCredential?> signin(String email, String password) async {
    try {
      final usercred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return usercred;
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth specific exceptions
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
      }
      print(errorMessage); // Log the error message
      return null; // Return null or handle further as needed
    } catch (e) {
      // Handle general errors
      print('Error: $e');
      return null;
    }
  }

  // Create account with email and password
  Future<UserCredential?> createaccount(String email, String password) async {
    try {
      final usercred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return usercred;
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth specific exceptions
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage =
              'The email address is already in use by another account.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        default:
          errorMessage = 'An unknown error occurred. Please try again.';
      }
      print(errorMessage); // Log the error message
      return null; // Return null or handle further as needed
    } catch (e) {
      // Handle general errors
      print('Error: $e');
      return null;
    }
  }

  // Log out the user
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  // Sign in with Google
  Future<UserCredential?> googlesignin() async {
    try {
      final GoogleSignInAccount? googleuser = await GoogleSignIn().signIn();
      if (googleuser == null) {
        print('Google sign-in aborted by user');
        return null; // The user canceled the sign-in
      }
      final GoogleSignInAuthentication googleauth =
          await googleuser.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: googleauth.accessToken,
        idToken: googleauth.idToken,
      );
      final usercred = await FirebaseAuth.instance.signInWithCredential(cred);
      return usercred;
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth specific exceptions
      print('Google sign-in failed: ${e.message}'); // Log the error message
      return null; // Return null or handle further as needed
    } catch (e) {
      // Handle general errors
      print('Error: $e');
      return null;
    }
  }
}
