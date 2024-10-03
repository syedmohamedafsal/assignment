import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Sign up with email and password
  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      // Create user
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store the user ID securely
      await _secureStorage.write(key: 'user_id', value: credential.user?.uid);

      // Store user data in Firestore
      await _saveUserData(credential.user);

      return credential.user;
    } catch (e) {
      print('Error during sign up: $e');
      throw _handleAuthException(e);
    }
  }

  Future<void> saveUserDetails(String userId, String fullName, String email,
      String profileImageUrl,String intrest) async {
    await _firestore.collection('signup').doc(userId).set({
      'fullName': fullName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'intrest':intrest,
    });
  }

  /// Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // Sign in user
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store the user ID securely
      await _secureStorage.write(key: 'user_id', value: credential.user?.uid);

      return credential.user;
    } catch (e) {
      print('Error during sign in: $e');
      throw _handleAuthException(e);
    }
  }

  /// Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return null; // User canceled the sign-in
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Store user data in Firestore
      await _saveUserData(userCredential.user, {
        'displayName': googleUser.displayName,
        'email': googleUser.email,
        'photoURL': googleUser.photoUrl,
      });

      return userCredential.user;
    } catch (e) {
      print('Error during Google sign in: $e');
      throw _handleAuthException(e);
    }
  }

  /// Sign in with Apple


  /// Sign in with Facebook
  // Future<User?> signInWithFacebook() async {
  //   try {
  //     // Start the Facebook login process
  //     final LoginResult result = await FacebookAuth.instance.login();

  //     // Check if the login was successful
  //     if (result.status == LoginStatus.success) {
  //       // Retrieve the access token from the result
  //       final accessToken = result.accessToken;

  //       if (accessToken != null) {
  //         // Use the access token for Firebase authentication
  //         final OAuthCredential credential =
  //             FacebookAuthProvider.credential(accessToken.token);

  //         // Sign in with Firebase using the Facebook credential
  //         UserCredential userCredential =
  //             await _auth.signInWithCredential(credential);

  //         // Fetch user data from Facebook
  //         final userData = await FacebookAuth.instance.getUserData();

  //         // Store user data in Firestore
  //         await _saveUserData(userCredential.user, {
  //           'displayName': userData['name'],
  //           'email': userData['email'],
  //           'photoURL': userData['picture']['data']['url'],
  //         });

  //         return userCredential.user;
  //       } else {
  //         print("Access token is null");
  //         return null;
  //       }
  //     } else {
  //       print("Facebook login failed: ${result.status}");
  //       return null; // The user canceled the login
  //     }
  //   } catch (e) {
  //     print('Error during Facebook sign in: $e');
  //     throw _handleAuthException(e);
  //   }
  // }

  /// Store user data in Firestore
  Future<void> _saveUserData(User? user,
      [Map<String, dynamic>? additionalData]) async {
    if (user == null) return;

    final userData = {
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? '',
      'photoURL': user.photoURL ?? '',
      ...?additionalData,
    };

    // Store or update user data in Firestore
    await _firestore
        .collection('users')
        .doc(user.uid)
        .set(userData, SetOptions(merge: true));
  }

  /// Handle authentication exceptions
  String _handleAuthException(dynamic e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'The email address is already in use by another account.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'weak-password':
          return 'The password provided is too weak.';
        case 'user-not-found':
          return 'No user found for that email.';
        case 'wrong-password':
          return 'The password is invalid for the email address.';
        default:
          return 'An unknown error occurred. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}
