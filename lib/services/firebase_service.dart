// firebase_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String?> registerUser(String email, String password) async {
    try {
      print('🚀 Starting registration for: $email');

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );

      print('✅ User created successfully: ${userCredential.user!.uid}');

      print('📧 Sending verification email...');
      await userCredential.user!.sendEmailVerification();

      print('✅ Verification email sent to: $email');

      return null;
    } on FirebaseAuthException catch (e) {
      print('❌ Registration error: ${e.code} - ${e.message}');
      return _getErrorMessage(e);
    } catch (e) {
      print('❌ General registration error: $e');
      return "Registration failed: $e";
    }
  }

  Future<Map<String, dynamic>> sendPasswordResetEmail(String email) async {
    try {
      print('📧 Sending password reset email to: $email');

      await _auth.sendPasswordResetEmail(email: email);

      print('✅ Password reset email sent successfully');
      return {
        'success': true,
        'message': 'Password reset email sent to $email'
      };
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      return {
        'success': false,
        'message': _getErrorMessage(e),
        'errorCode': e.code
      };
    } catch (e) {
      print('❌ General Error: $e');
      return {
        'success': false,
        'message': 'Failed to send reset email. Please try again.'
      };
    }
  }

  String _getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'invalid-continue-uri':
        return 'The reset link configuration is invalid.';
      case 'unauthorized-continue-uri':
        return 'The reset link domain is not authorized.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'email-already-in-use':
        return 'Email already in use. Please use a different email.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      default:
        return e.message ?? 'An unexpected error occurred.';
    }
  }

  Future<String?> loginUser(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e);
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return "Google sign in cancelled";

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e);
    }
  }

  Future<bool> isEmailVerified() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    }
    return false;
  }

  Future<String?> resendVerificationEmail() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        return null;
      }
      return "No user logged in";
    } on FirebaseAuthException catch (e) {
      return _getErrorMessage(e);
    }
  }
}