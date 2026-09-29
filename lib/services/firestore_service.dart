import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';

/// Centralized Firestore service to replace all Google Apps Script providers
/// Collections:
/// - users: User profile and registration data
/// - test_results: Mental health assessment results
/// - appointments: Counselor appointment bookings
/// - counselors: Counselor contact information
/// - faqs: Frequently asked questions
/// - problem_reports: User-reported issues
class FirestoreService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==================== USER MANAGEMENT ====================

  /// Add or update user registration data
  Future<String> addUser(UserModel user) async {
    try {
      await _db
          .collection('users')
          .doc(user.registerNumber)
          .set(user.toFirestore(), SetOptions(merge: true));
      return 'SUCCESS';
    } catch (e) {
      debugPrint('Error adding user: $e');
      return 'ERROR';
    }
  }

  /// Update user profile data
  Future<String> updateUserProfile({
    required String uid,
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
      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (age != null) updates['age'] = age;
      if (gender != null) updates['gender'] = gender;
      if (emergencyContact != null) {
        updates['emergencyContact'] = emergencyContact;
      }
      if (emergencyContactName != null) {
        updates['emergencyContactName'] = emergencyContactName;
      }
      if (preferredContactMethod != null) {
        updates['preferredContactMethod'] = preferredContactMethod;
      }

      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _db
          .collection('user_profiles')
          .doc(uid)
          .set(updates, SetOptions(merge: true));
      return 'SUCCESS';
    } catch (e) {
      debugPrint('Error updating user profile: $e');
      return 'ERROR: ${e.toString()}';
    }
  }

  /// Get user profile by UID
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('user_profiles').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user profile: $e');
      return null;
    }
  }

  /// Get user by register number
  Future<UserModel?> getUser(String registerNumber) async {
    try {
      final doc = await _db.collection('users').doc(registerNumber).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  /// Get all users (admin functionality)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final snapshot = await _db.collection('users').get();
      return snapshot.docs
          .map((doc) => UserModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting users: $e');
      return [];
    }
  }

  /// Delete all user data from Firestore
  /// Deletes from: user_profiles, users (by registerNumber), test_results, and appointments
  Future<String> deleteUserData({
    required String uid,
    String? registerNumber,
  }) async {
    try {
      // Delete user profile
      await _db.collection('user_profiles').doc(uid).delete();

      // Delete user registration data if registerNumber is provided
      if (registerNumber != null && registerNumber.isNotEmpty) {
        await _db.collection('users').doc(registerNumber).delete();

        // Delete test results
        final testResultsSnapshot = await _db
            .collection('test_results')
            .doc(registerNumber)
            .collection('results')
            .get();

        for (var doc in testResultsSnapshot.docs) {
          await doc.reference.delete();
        }

        // Delete the test_results parent document
        await _db.collection('test_results').doc(registerNumber).delete();

        // Delete appointments
        final appointmentsSnapshot = await _db
            .collection('appointments')
            .where('registerNumber', isEqualTo: registerNumber)
            .get();

        for (var doc in appointmentsSnapshot.docs) {
          await doc.reference.delete();
        }
      }

      // Delete appointments by UID as fallback
      final appointmentsByUidSnapshot = await _db
          .collection('appointments')
          .where('uid', isEqualTo: uid)
          .get();

      for (var doc in appointmentsByUidSnapshot.docs) {
        await doc.reference.delete();
      }

      return 'SUCCESS';
    } catch (e) {
      debugPrint('Error deleting user data: $e');
      return 'ERROR: ${e.toString()}';
    }
  }

  // ==================== TEST RESULTS ====================

  /// Add test result for a user
  Future<String> addTestResult(TestResultModel result) async {
    try {
      // Use registerNumber if available, otherwise use Firebase UID from current user
      String userId = result.registerNumber;

      // If registerNumber is empty, try to get current user's UID
      if (userId.isEmpty) {
        final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          return 'ERROR: No authenticated user';
        }
        userId = currentUser.uid;
      }

      await _db
          .collection('test_results')
          .doc(userId)
          .collection('results')
          .add(result.toFirestore());
      return 'SUCCESS';
    } catch (e) {
      debugPrint('Error adding test result: $e');
      return 'ERROR: ${e.toString()}';
    }
  }

  /// Get all test results for a user
  /// Accepts either registerNumber or uses current user's UID if empty
  Future<List<TestResultModel>> getTestResults([String? registerNumber]) async {
    try {
      // Use registerNumber if provided, otherwise use Firebase UID from current user
      String userId = registerNumber ?? '';

      if (userId.isEmpty) {
        final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          debugPrint('No authenticated user');
          return [];
        }
        userId = currentUser.uid;
      }

      final snapshot = await _db
          .collection('test_results')
          .doc(userId)
          .collection('results')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TestResultModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting test results: $e');
      return [];
    }
  }

  /// Get all test results (admin functionality)
  Future<List<TestResultModel>> getAllTestResults() async {
    try {
      final List<TestResultModel> allResults = [];
      final usersSnapshot = await _db.collection('test_results').get();

      for (var userDoc in usersSnapshot.docs) {
        final resultsSnapshot = await userDoc.reference
            .collection('results')
            .get();
        allResults.addAll(
          resultsSnapshot.docs.map(
            (doc) => TestResultModel.fromFirestore(doc.data()),
          ),
        );
      }

      return allResults;
    } catch (e) {
      debugPrint('Error getting all test results: $e');
      return [];
    }
  }

  // ==================== APPOINTMENTS ====================

  /// Add appointment booking
  Future<String> addAppointment(AppointmentModel appointment) async {
    try {
      await _db.collection('appointments').add(appointment.toFirestore());
      return 'SUCCESS';
    } catch (e) {
      debugPrint('Error adding appointment: $e');
      return 'ERROR';
    }
  }

  /// Get all appointments
  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final snapshot = await _db
          .collection('appointments')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting appointments: $e');
      return [];
    }
  }

  /// Get appointments for a specific user
  Future<List<AppointmentModel>> getUserAppointments(
    String registerNumber,
  ) async {
    try {
      final snapshot = await _db
          .collection('appointments')
          .where('registerNumber', isEqualTo: registerNumber)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AppointmentModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting user appointments: $e');
      return [];
    }
  }

  // ==================== COUNSELORS ====================

  /// Add or update counselor information
  Future<String> addCounselor(CounselorModel counselor) async {
    try {
      await _db.collection('counselors').add(counselor.toFirestore());
      return 'SUCCESS';
    } catch (e) {
      debugPrint('Error adding counselor: $e');
      return 'ERROR';
    }
  }

  /// Get all counselors
  Future<List<CounselorModel>> getCounselors() async {
    try {
      final snapshot = await _db
          .collection('counselors')
          .orderBy('professorName')
          .get();

      return snapshot.docs
          .map((doc) => CounselorModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting counselors: $e');
      return [];
    }
  }

  // ==================== FAQs ====================

  /// Add FAQ
  Future<String> addFaq(FaqModel faq) async {
    try {
      await _db.collection('faqs').add(faq.toFirestore());
      return 'SUCCESS';
    } catch (e) {
      debugPrint('Error adding FAQ: $e');
      return 'ERROR';
    }
  }

  /// Get all FAQs
  Future<List<FaqModel>> getFaqs() async {
    try {
      final snapshot = await _db.collection('faqs').get();
      return snapshot.docs
          .map((doc) => FaqModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting FAQs: $e');
      return [];
    }
  }

  // ==================== PROBLEM REPORTS ====================

  /// Add problem report
  Future<String> addProblemReport(ProblemReportModel problem) async {
    try {
      await _db.collection('problem_reports').add(problem.toFirestore());
      return 'SUCCESS';
    } catch (e) {
      debugPrint('Error adding problem report: $e');
      return 'ERROR';
    }
  }

  /// Get all problem reports
  Future<List<ProblemReportModel>> getProblemReports() async {
    try {
      final snapshot = await _db
          .collection('problem_reports')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ProblemReportModel.fromFirestore(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting problem reports: $e');
      return [];
    }
  }

  /// Update problem report status
  Future<String> updateProblemStatus(String reportId, String status) async {
    try {
      await _db.collection('problem_reports').doc(reportId).update({
        'status': status,
      });
      return 'SUCCESS';
    } catch (e) {
      debugPrint('Error updating problem status: $e');
      return 'ERROR';
    }
  }
}

// ==================== DATA MODELS ====================

class UserModel {
  final String email;
  final String name;
  final String registerNumber;
  final String gender;
  final String sslc;
  final String hsc;
  final String income;

  UserModel({
    required this.email,
    required this.name,
    required this.registerNumber,
    required this.gender,
    required this.sslc,
    required this.hsc,
    required this.income,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'registerNumber': registerNumber,
      'gender': gender,
      'sslc': sslc,
      'hsc': hsc,
      'income': income,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      registerNumber: json['registerNumber'] ?? '',
      gender: json['gender'] ?? '',
      sslc: json['sslc'] ?? '',
      hsc: json['hsc'] ?? '',
      income: json['income'] ?? '',
    );
  }
}

class TestResultModel {
  final String date;
  final String registerNumber;
  final String phqFifteen;
  final String gadSeven;
  final String phqNine;
  final String dass;
  final String phqFifteenScore;
  final String gadSevenScore;
  final String phqNineScore;
  final String depressionDass;
  final String anxietyDass;
  final String stressDass;
  final Timestamp? timestamp;

  TestResultModel({
    required this.date,
    required this.registerNumber,
    required this.phqFifteen,
    required this.gadSeven,
    required this.phqNine,
    required this.dass,
    required this.phqFifteenScore,
    required this.gadSevenScore,
    required this.phqNineScore,
    required this.depressionDass,
    required this.anxietyDass,
    required this.stressDass,
    this.timestamp,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'registerNumber': registerNumber,
      'phqFifteen': phqFifteen,
      'gadSeven': gadSeven,
      'phqNine': phqNine,
      'dass': dass,
      'phqFifteenScore': phqFifteenScore,
      'gadSevenScore': gadSevenScore,
      'phqNineScore': phqNineScore,
      'depressionDass': depressionDass,
      'anxietyDass': anxietyDass,
      'stressDass': stressDass,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory TestResultModel.fromFirestore(Map<String, dynamic> json) {
    return TestResultModel(
      date: json['date'] ?? '',
      registerNumber: json['registerNumber'] ?? '',
      phqFifteen: json['phqFifteen'] ?? '',
      gadSeven: json['gadSeven'] ?? '',
      phqNine: json['phqNine'] ?? '',
      dass: json['dass'] ?? '',
      phqFifteenScore: json['phqFifteenScore'] ?? '',
      gadSevenScore: json['gadSevenScore'] ?? '',
      phqNineScore: json['phqNineScore'] ?? '',
      depressionDass: json['depressionDass'] ?? '',
      anxietyDass: json['anxietyDass'] ?? '',
      stressDass: json['stressDass'] ?? '',
      timestamp: json['timestamp'],
    );
  }
}

class AppointmentModel {
  final String email;
  final String name;
  final String registerNumber;
  final String date;
  final String department;

  AppointmentModel({
    required this.email,
    required this.name,
    required this.registerNumber,
    required this.date,
    required this.department,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'registerNumber': registerNumber,
      'date': date,
      'department': department,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory AppointmentModel.fromFirestore(Map<String, dynamic> json) {
    return AppointmentModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      registerNumber: json['registerNumber'] ?? '',
      date: json['date'] ?? '',
      department: json['department'] ?? '',
    );
  }
}

class CounselorModel {
  final String professorName;
  final String department;
  final String email;
  final String phoneNumber;
  final String pictureUrl;
  final String profileUrl;

  CounselorModel({
    required this.professorName,
    required this.department,
    required this.email,
    required this.phoneNumber,
    required this.pictureUrl,
    required this.profileUrl,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'professorName': professorName,
      'department': department,
      'email': email,
      'phoneNumber': phoneNumber,
      'pictureUrl': pictureUrl,
      'profileUrl': profileUrl,
    };
  }

  factory CounselorModel.fromFirestore(Map<String, dynamic> json) {
    return CounselorModel(
      professorName: json['professorName'] ?? '',
      department: json['department'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      pictureUrl: json['pictureUrl'] ?? '',
      profileUrl: json['profileUrl'] ?? '',
    );
  }
}

class FaqModel {
  final String question;
  final String answer;

  FaqModel({required this.question, required this.answer});

  Map<String, dynamic> toFirestore() {
    return {'question': question, 'answer': answer};
  }

  factory FaqModel.fromFirestore(Map<String, dynamic> json) {
    return FaqModel(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }
}

class ProblemReportModel {
  final String date;
  final String summary;
  final String description;
  final String status;

  ProblemReportModel({
    required this.date,
    required this.summary,
    required this.description,
    required this.status,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'summary': summary,
      'description': description,
      'status': status,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }

  factory ProblemReportModel.fromFirestore(Map<String, dynamic> json) {
    return ProblemReportModel(
      date: json['date'] ?? '',
      summary: json['summary'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
    );
  }
}
