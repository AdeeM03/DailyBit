import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  static const String _googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '899681256715-ias4lan5iv2vpbc36tafqfi45dv51gcs.apps.googleusercontent.com',
  );

  FirebaseAuth get _auth => FirebaseAuth.instance;
  GoogleSignIn get _googleSignIn => GoogleSignIn(clientId: _googleClientId);

  User? get currentUser {
    try {
      return _auth.currentUser;
    } catch (_) {
      return null;
    }
  }

  bool get isAuthenticated => currentUser != null && !currentUser!.isAnonymous;

  Stream<User?> get authStateChanges {
    try {
      return _auth.authStateChanges();
    } catch (_) {
      return const Stream.empty();
    }
  }

  // 1. Email & Password Sign Up
  Future<UserCredential?> signUpWithEmail(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return credential;
    } catch (e) {
      debugPrint('AuthService Sign Up Error: $e');
      rethrow;
    }
  }

  // 2. Email & Password Sign In
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();
      return credential;
    } catch (e) {
      debugPrint('AuthService Sign In Error: $e');
      rethrow;
    }
  }

  // 3. Google Sign In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // The user canceled the sign-in

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final result = await _auth.signInWithCredential(credential);
      notifyListeners();
      return result;
    } catch (e) {
      debugPrint('AuthService Google Sign In Error: $e');
      rethrow;
    }
  }

  // 4. Anonymous (Guest)
  Future<UserCredential?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      notifyListeners();
      return credential;
    } catch (e) {
      debugPrint('AuthService Anonymous Sign In Error: $e');
      rethrow;
    }
  }

  // 5. Sign Out
  Future<void> signOut() async {
    try {
      try {
        await _googleSignIn.signOut();
      } catch (e) {
        debugPrint('Google SignOut ignored: $e');
      }
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      debugPrint('AuthService Sign Out Error: $e');
      rethrow;
    }
  }

  // 6. Password Reset
  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      debugPrint('AuthService Password Reset Error: $e');
      rethrow;
    }
  }
}
