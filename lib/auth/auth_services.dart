import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin interactive sign in process
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
      return await FirebaseAuth.instance.signInWithCredential(credential);
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
}
