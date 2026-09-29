import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static String _verificationId = '';
  static int? _resendToken;

  /// Send OTP to phone number
  Future<bool> sendOTP({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
    required Function(PhoneAuthCredential) onAutoVerify,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (on some Android devices)
          onAutoVerify(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            onError('Invalid phone number format');
          } else if (e.code == 'too-many-requests') {
            onError('Too many requests. Please try again later');
          } else {
            onError(e.message ?? 'Verification failed');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _resendToken = resendToken;
          onCodeSent('OTP sent successfully');
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        forceResendingToken: _resendToken,
      );
      return true;
    } catch (e) {
      onError(e.toString());
      return false;
    }
  }

  /// Verify OTP and sign in
  Future<User?> verifyOTP({
    required String otpCode,
    required Function(String) onError,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otpCode,
      );

      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        onError('Invalid OTP. Please try again');
      } else if (e.code == 'session-expired') {
        onError('OTP expired. Please request a new one');
      } else {
        onError(e.message ?? 'Verification failed');
      }
      return null;
    } catch (e) {
      onError(e.toString());
      return null;
    }
  }

  /// Sign in with credential (for auto-verification)
  Future<User?> signInWithCredential(PhoneAuthCredential credential) async {
    try {
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      return userCredential.user;
    } catch (e) {
      debugPrint('Error signing in: $e');
      return null;
    }
  }

  /// Check if user exists in Firestore
  Future<bool> checkUserExists(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      return doc.exists;
    } catch (e) {
      debugPrint('Error checking user: $e');
      return false;
    }
  }

  /// Create user profile in Firestore
  Future<bool> createUserProfile({
    required String uid,
    required String phoneNumber,
    String? name,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'phoneNumber': phoneNumber,
        'name': name ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        ...?additionalData,
      });
      return true;
    } catch (e) {
      debugPrint('Error creating user profile: $e');
      return false;
    }
  }

  /// Update last login time
  Future<void> updateLastLogin(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('Error updating last login: $e');
    }
  }

  /// Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user data: $e');
      return null;
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Check if user is signed in
  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

  /// Format phone number to E.164 format
  String formatPhoneNumber(String phoneNumber) {
    // Remove all non-numeric characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // If number starts with 0, replace with country code
    if (cleaned.startsWith('0')) {
      cleaned = '+91${cleaned.substring(1)}'; // India country code
    } else if (!cleaned.startsWith('+')) {
      cleaned = '+91$cleaned';
    }

    return cleaned;
  }

  /// Validate phone number
  bool isValidPhoneNumber(String phoneNumber) {
    // Remove all non-numeric characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it's a valid 10-digit Indian phone number
    if (cleaned.length == 10 && cleaned.startsWith(RegExp(r'[6-9]'))) {
      return true;
    }

    // Check if it's already in E.164 format
    if (phoneNumber.startsWith('+91') && cleaned.length == 12) {
      return true;
    }

    return false;
  }
}
