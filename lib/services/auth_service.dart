import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Google Sign in
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      if (gUser != null) {
        // Obtain auth details from request
        final GoogleSignInAuthentication gAuth = await gUser.authentication;

        // Create new credential for the user
        final credential = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken,
          idToken: gAuth.idToken,
        );

        // Finally, let's sign in
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        return userCredential;
      }
    } catch (e) {
      // Handle sign-in error here
      // You can show an error message or log the error for debugging
      print('Error during Google sign-in: $e');
    }

    return null;
  }
}
