import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Service for tracking user moods with Firestore sync
/// Stores mood data in Firestore for cross-device synchronization
class MoodTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Save mood entry to Firestore
  Future<bool> saveMood({required String emoji, required String label}) async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return false;
      }

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final now = DateTime.now();

      // Save mood entry to Firestore
      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('mood_entries')
          .doc(today)
          .set({
            'date': today,
            'emoji': emoji,
            'label': label,
            'timestamp': FieldValue.serverTimestamp(),
            'year': now.year,
            'month': now.month,
            'day': now.day,
          });

      // Update streak
      await _updateStreak(currentUser.uid, today);

      return true;
    } catch (e) {
      debugPrint('Error saving mood: $e');
      return false;
    }
  }

  /// Update mood streak calculation
  Future<void> _updateStreak(String uid, String today) async {
    try {
      // Get user's mood metadata
      final metaDoc = await _firestore
          .collection('users')
          .doc(uid)
          .collection('mood_metadata')
          .doc('stats')
          .get();

      int currentStreak = 1;
      final yesterday = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.now().subtract(Duration(days: 1)));

      if (metaDoc.exists) {
        final data = metaDoc.data()!;
        final lastMoodDate = data['lastMoodDate'] as String?;
        final existingStreak = data['currentStreak'] as int? ?? 0;

        if (lastMoodDate == yesterday) {
          // Consecutive day
          currentStreak = existingStreak + 1;
        } else if (lastMoodDate == today) {
          // Already logged today (updating)
          currentStreak = existingStreak;
        }
        // else: Streak broken, currentStreak = 1
      }

      // Update metadata
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('mood_metadata')
          .doc('stats')
          .set({
            'currentStreak': currentStreak,
            'lastMoodDate': today,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error updating streak: $e');
    }
  }

  /// Get today's mood entry
  Future<Map<String, dynamic>?> getTodaysMood() async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return null;
      }

      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('mood_entries')
          .doc(today)
          .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('Error getting today\'s mood: $e');
      return null;
    }
  }

  /// Get mood streak
  Future<int> getMoodStreak() async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return 0;
      }

      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('mood_metadata')
          .doc('stats')
          .get();

      if (doc.exists) {
        final data = doc.data()!;
        final lastMoodDate = data['lastMoodDate'] as String?;
        final currentStreak = data['currentStreak'] as int? ?? 0;

        if (lastMoodDate == null) {
          return 0;
        }

        // Check if streak should be reset
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
        final yesterday = DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.now().subtract(Duration(days: 1)));

        // If last mood was today or yesterday, streak is valid
        if (lastMoodDate == today || lastMoodDate == yesterday) {
          return currentStreak;
        }

        // Streak is broken - reset it
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('mood_metadata')
            .doc('stats')
            .set({
              'currentStreak': 0,
              'lastMoodDate': lastMoodDate,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

        return 0;
      }
      return 0;
    } catch (e) {
      debugPrint('Error getting mood streak: $e');
      return 0;
    }
  }

  /// Get last 7 days of mood entries
  Future<List<Map<String, dynamic>>> getLast7DaysMoods() async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return [];
      }

      List<Map<String, dynamic>> moods = [];

      for (int i = 6; i >= 0; i--) {
        final date = DateTime.now().subtract(Duration(days: i));
        final dateStr = DateFormat('yyyy-MM-dd').format(date);

        final doc = await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('mood_entries')
            .doc(dateStr)
            .get();

        final docData = doc.data();
        moods.add({
          'date': dateStr,
          'mood': doc.exists && docData != null ? docData['emoji'] : null,
          'label': doc.exists && docData != null ? docData['label'] : null,
          'day': DateFormat('E').format(date),
        });
      }

      return moods;
    } catch (e) {
      debugPrint('Error getting last 7 days moods: $e');
      return [];
    }
  }

  /// Get mood entries for a specific month
  Future<List<Map<String, dynamic>>> getMoodsByMonth({
    required int year,
    required int month,
  }) async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return [];
      }

      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('mood_entries')
          .where('year', isEqualTo: year)
          .where('month', isEqualTo: month)
          .orderBy('day', descending: false)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error getting moods by month: $e');
      return [];
    }
  }

  /// Get mood statistics
  Future<Map<String, dynamic>> getMoodStatistics() async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return {};
      }

      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(Duration(days: 30));
      final startDate = DateFormat('yyyy-MM-dd').format(thirtyDaysAgo);

      final snapshot = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('mood_entries')
          .where('date', isGreaterThanOrEqualTo: startDate)
          .get();

      // Count mood occurrences
      Map<String, int> moodCounts = {
        'Sad': 0,
        'Fine': 0,
        'Well': 0,
        'Excellent': 0,
      };

      for (var doc in snapshot.docs) {
        final label = doc.data()['label'] as String?;
        if (label != null && moodCounts.containsKey(label)) {
          moodCounts[label] = moodCounts[label]! + 1;
        }
      }

      return {
        'totalEntries': snapshot.docs.length,
        'moodCounts': moodCounts,
        'last30Days': true,
      };
    } catch (e) {
      debugPrint('Error getting mood statistics: $e');
      return {};
    }
  }

  /// Delete a mood entry (for testing/admin purposes)
  Future<bool> deleteMoodEntry(String date) async {
    try {
      final currentUser = firebase_auth.FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        return false;
      }

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .collection('mood_entries')
          .doc(date)
          .delete();

      return true;
    } catch (e) {
      debugPrint('Error deleting mood entry: $e');
      return false;
    }
  }

  /// Check if mood is logged for today (quick check)
  Future<bool> isMoodLoggedToday() async {
    final mood = await getTodaysMood();
    return mood != null;
  }
}
