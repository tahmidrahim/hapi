import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // FIX 1: Use the singleton instance (No constructor '()')
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  // NOTE: If the line above still fails, replace it with:
  // static final GoogleSignIn _googleSignIn = GoogleSignIn.standard(scopes: ['email', 'profile']);

  // Get current user
  static User? get currentUser => _auth.currentUser;

  // Auth state changes
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with Google
  static Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      // FIX 2: Ensure we are using the correct method.
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign in cancelled');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Check if user exists in Firestore, if not create
      await _createUserIfNotExists(userCredential.user!);

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with Facebook
  static Future<UserCredential> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );

      if (loginResult.status != LoginStatus.success) {
        throw Exception('Facebook login failed');
      }

      final AccessToken? accessToken = loginResult.accessToken;

      if (accessToken == null) {
        throw Exception('Facebook access token is null');
      }

      // FIX 3: Use 'tokenString' instead of 'token'
      final OAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      await _createUserIfNotExists(userCredential.user!);

      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  // Complete user profile
  static Future<void> completeProfile({
    required String name,
    required String gender,
    required String country,
    required DateTime dateOfBirth,
    String? bio,
  }) async {
    try {
      final userId = currentUser!.uid;

      await _firestore.collection('users').doc(userId).update({
        'name': name,
        'gender': gender,
        'country': country,
        'dateOfBirth': Timestamp.fromDate(dateOfBirth),
        'bio': bio ?? '',
        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _createUserIfNotExists(User user) async {
    final userDoc = await _firestore.collection('users').doc(user.uid).get();

    if (!userDoc.exists) {
      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email ?? '',
        'name': user.displayName ?? '',
        'profileImage': user.photoURL ?? '',
        'phoneNumber': user.phoneNumber ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'profileCompleted': false,
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'username': _generateUsername(user.email ?? user.uid),
      });
    } else {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }

  static String _generateUsername(String email) {
    if (email.contains('@')) {
      return email.split('@')[0] +
          DateTime.now().millisecondsSinceEpoch.toString().substring(8);
    }
    return email +
        DateTime.now().millisecondsSinceEpoch.toString().substring(8);
  }

  static Future<void> signOut() async {
    try {
      if (currentUser != null) {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'isOnline': false,
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }

      await _auth.signOut();
      await _googleSignIn.signOut();
      await FacebookAuth.instance.logOut();
    } catch (e) {
      rethrow;
    }
  }

  static bool get isAuthenticated => currentUser != null;
  static String? get userId => currentUser?.uid;
}
