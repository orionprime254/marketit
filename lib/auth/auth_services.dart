import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) {
        // If the sign-in process was canceled by the user
        throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      }

      // Obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Create a new credential for the user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Finally, sign in
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Store user data to Firestore
      if (user != null) {
        await _firestore
            .collection('Users')
            .doc(userCredential.user!.email)
            .set({
          //        'uid': user.uid,
//'email': user.email,
          'email': userCredential.user!.email,
          //'displayName': user.displayName,
          //'photoURL': user.photoURL,
        }, SetOptions(merge: true)); // Merge to avoid overwriting existing data
      }

      return userCredential;
    } on SocketException catch (_) {
      // Handle network errors
      throw FirebaseAuthException(
        code: 'NETWORK_ERROR',
        message: 'No Internet connection',
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      rethrow;
    } catch (e) {
      // Handle other errors
      throw FirebaseAuthException(
        code: 'UNKNOWN_ERROR',
        message: 'An unknown error occurred: ${e.toString()}',
      );
    }
  }

// Future<void> signOut() async {
//   await GoogleSignIn().signOut();
//   await _auth.signOut();
// }
}
