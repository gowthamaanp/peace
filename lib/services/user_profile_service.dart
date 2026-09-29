import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:peace/models/user.dart';
import 'package:peace/services/firestore_service.dart';

/// Helper service for managing user profile operations
/// Provides convenient methods to load and save user profiles
class UserProfileService {
  final FirestoreService _firestoreService = FirestoreService();

  /// Load user profile from Firestore and update global user object
  /// Returns true if successful, false otherwise
  Future<bool> loadUserProfile() async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return false;
      }

      final userData = await _firestoreService.getUserProfile(currentUser.uid);

      if (userData != null) {
        // Update global user object
        user.name = userData['name'] ?? '';
        user.email = userData['email'] ?? '';
        user.phoneNumber = userData['phoneNumber'] ?? '';
        user.age = userData['age'] ?? '';
        user.gender = userData['gender'] ?? '';
        user.emergencyContact = userData['emergencyContact'] ?? '';
        user.emergencyContactName = userData['emergencyContactName'] ?? '';
        user.preferredContactMethod = userData['preferredContactMethod'] ?? '';
        user.uid = currentUser.uid;

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error loading user profile: $e');
      return false;
    }
  }

  /// Save current user profile to Firestore
  /// Returns true if successful, false otherwise
  Future<bool> saveUserProfile() async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return false;
      }

      final result = await _firestoreService.updateUserProfile(
        uid: currentUser.uid,
        name: user.name,
        email: user.email,
        phoneNumber: user.phoneNumber,
        age: user.age,
        gender: user.gender,
        emergencyContact: user.emergencyContact,
        emergencyContactName: user.emergencyContactName,
        preferredContactMethod: user.preferredContactMethod,
      );

      return result == 'SUCCESS';
    } catch (e) {
      debugPrint('Error saving user profile: $e');
      return false;
    }
  }

  /// Update specific fields of user profile
  /// Only updates the fields that are provided (non-null)
  Future<bool> updateUserProfileFields({
    String? name,
    String? email,
    String? phoneNumber,
    String? age,
    String? gender,
    String? emergencyContact,
    String? emergencyContactName,
    String? preferredContactMethod,
  }) async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return false;
      }

      final result = await _firestoreService.updateUserProfile(
        uid: currentUser.uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        age: age,
        gender: gender,
        emergencyContact: emergencyContact,
        emergencyContactName: emergencyContactName,
        preferredContactMethod: preferredContactMethod,
      );

      if (result == 'SUCCESS') {
        // Update global user object with provided fields
        if (name != null) user.name = name;
        if (email != null) user.email = email;
        if (phoneNumber != null) user.phoneNumber = phoneNumber;
        if (age != null) user.age = age;
        if (gender != null) user.gender = gender;
        if (emergencyContact != null) user.emergencyContact = emergencyContact;
        if (emergencyContactName != null) {
          user.emergencyContactName = emergencyContactName;
        }
        if (preferredContactMethod != null) {
          user.preferredContactMethod = preferredContactMethod;
        }

        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error updating user profile fields: $e');
      return false;
    }
  }

  /// Check if user has completed their profile
  /// Returns true if all required fields are filled
  bool isProfileComplete() {
    return user.name.isNotEmpty &&
        user.email.isNotEmpty &&
        user.phoneNumber.isNotEmpty &&
        user.age.isNotEmpty &&
        user.gender.isNotEmpty;
  }

  /// Get completion percentage of user profile (0.0 to 1.0)
  double getProfileCompletionPercentage() {
    int filledFields = 0;
    const int totalFields = 8;

    if (user.name.isNotEmpty) filledFields++;
    if (user.email.isNotEmpty) filledFields++;
    if (user.phoneNumber.isNotEmpty) filledFields++;
    if (user.age.isNotEmpty) filledFields++;
    if (user.gender.isNotEmpty) filledFields++;
    if (user.emergencyContact.isNotEmpty) filledFields++;
    if (user.emergencyContactName.isNotEmpty) filledFields++;
    if (user.preferredContactMethod.isNotEmpty) filledFields++;

    return filledFields / totalFields;
  }

  /// Clear user profile data (for logout)
  void clearUserProfile() {
    user.name = '';
    user.email = '';
    user.phoneNumber = '';
    user.age = '';
    user.gender = '';
    user.emergencyContact = '';
    user.emergencyContactName = '';
    user.preferredContactMethod = '';
    user.uid = '';
    user.registerNumber = '';
    user.department = '';
  }

  /// Sync user profile: Load from Firestore if exists, otherwise save current data
  Future<bool> syncUserProfile() async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return false;
      }

      // Try to load from Firestore first
      final userData = await _firestoreService.getUserProfile(currentUser.uid);

      if (userData != null) {
        // Profile exists in Firestore, load it
        return await loadUserProfile();
      } else {
        // Profile doesn't exist in Firestore, save current data
        return await saveUserProfile();
      }
    } catch (e) {
      debugPrint('Error syncing user profile: $e');
      return false;
    }
  }
}
