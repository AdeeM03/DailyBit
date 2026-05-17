import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:isar_plus/isar_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';
import '../models/habit_log.dart';
import '../models/diary_entry.dart';
import 'database_helper.dart';

class SyncService {
  static final SyncService instance = SyncService._();
  SyncService._();

  FirebaseFirestore get _db => FirebaseFirestore.instance;
  Isar get _isar => DatabaseHelper.instance.isar;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  bool get canSync {
    final user = FirebaseAuth.instance.currentUser;
    return user != null && !user.isAnonymous;
  }

  Future<void> _write(void Function(Isar isar) operation) async {
    if (kIsWeb) {
      _isar.write(operation);
    } else {
      await _isar.writeAsync(operation);
    }
  }

  // ─────────────────────────── UPLOAD ───────────────────────────

  Future<void> uploadToCloud() async {
    if (!canSync) throw Exception('Login required to sync');
    final uid = _uid!;

    final habits = await DatabaseHelper.instance.readAllHabits();
    final logs = _isar.habitLogs.where().findAll();
    final diary = await DatabaseHelper.instance.readAllDiaryEntries();

    debugPrint('SyncService: Preparing upload — ${habits.length} habits, ${logs.length} logs, ${diary.length} diary');

    final prefs = await SharedPreferences.getInstance();
    final photoBase64 = prefs.getString('photoBase64');
    final displayName = prefs.getString('displayName');

    final userDoc = _db.collection('users').doc(uid);

    // Upload profile photo to Firebase Storage (not Firestore)
    String? photoUrl;
    if (photoBase64 != null && photoBase64.isNotEmpty) {
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('users/$uid/profile.jpg');
        await ref.putData(
          base64Decode(photoBase64),
          SettableMetadata(contentType: 'image/jpeg'),
        );
        photoUrl = await ref.getDownloadURL();
      } catch (e) {
        debugPrint('SyncService: Photo upload failed: $e');
      }
    }

    // Upload metadata
    await userDoc.set({
      'lastSync': FieldValue.serverTimestamp(),
      'habitCount': habits.length,
      'logCount': logs.length,
      'diaryCount': diary.length,
      'photoUrl': photoUrl,
      'displayName': displayName,
    });

    // Batch delete old cloud data, then write new
    await _clearCollection(userDoc.collection('habits'));
    await _clearCollection(userDoc.collection('habitLogs'));
    await _clearCollection(userDoc.collection('diaryEntries'));

    // Upload habits
    for (final h in habits) {
      await userDoc.collection('habits').doc('${h.id}').set({
        'id': h.id,
        'title': h.title,
        'subtitle': h.subtitle,
        'iconCodePoint': h.iconCodePoint,
        'iconFontFamily': h.iconFontFamily,
        'colorHex': h.colorHex,
        'bgColorHex': h.bgColorHex,
        'isCurrentFocus': h.isCurrentFocus,
        'createdAt': h.createdAt,
        'timeOfDay': h.timeOfDay,
        'goalType': h.goalType,
        'goalValue': h.goalValue,
      });
    }

    // Upload logs
    for (final l in logs) {
      await userDoc.collection('habitLogs').doc('${l.id}').set({
        'id': l.id,
        'habitId': l.habitId,
        'date': l.date,
        'isCompleted': l.isCompleted,
        'progress': l.progress,
      });
    }

    // Upload diary
    for (final d in diary) {
      await userDoc.collection('diaryEntries').doc('${d.id}').set({
        'id': d.id,
        'date': d.date,
        'dateLabel': d.dateLabel,
        'emoji': d.emoji,
        'emojiColorHex': d.emojiColorHex,
        'moodLevel': d.moodLevel,
        'title': d.title,
        'body': d.body,
      });
    }

    debugPrint('SyncService: Upload complete — ${habits.length} habits, ${logs.length} logs, ${diary.length} diary entries');
  }

  Future<void> syncInBackground() async {
    if (!canSync) return;
    try {
      await uploadToCloud();
    } catch (e) {
      debugPrint('SyncService Background Sync Error: $e');
    }
  }

  Timer? _syncDebouncer;
  bool _isSyncing = false;

  /// Debounced sync — coalesces rapid mutations into one upload after 5s of quiet.
  void scheduleSync() {
    if (!canSync) return;
    _syncDebouncer?.cancel();
    _syncDebouncer = Timer(const Duration(seconds: 5), () async {
      if (_isSyncing) return;
      _isSyncing = true;
      try {
        await uploadToCloud();
      } catch (e) {
        debugPrint('SyncService Scheduled Sync Error: $e');
      } finally {
        _isSyncing = false;
      }
    });
  }

  /// Auto-restore from cloud if user is authenticated and cloud data exists.
  /// Returns true if data was restored, false otherwise.
  /// Safe to call from any context — never throws.
  Future<bool> autoRestoreIfAvailable() async {
    if (!canSync) return false;
    try {
      final hasData = await hasCloudData();
      if (!hasData) return false;
      await restoreFromCloud();
      return true;
    } catch (e) {
      debugPrint('SyncService auto-restore failed: $e');
      return false;
    }
  }

  // ─────────────────────────── DOWNLOAD / RESTORE ───────────────────────────

  Future<bool> hasCloudData() async {
    if (!canSync) return false;
    final doc = await _db.collection('users').doc(_uid!).get();
    return doc.exists;
  }

  Future<void> restoreFromCloud() async {
    if (!canSync) throw Exception('Login required to restore');
    final uid = _uid!;
    final userDoc = _db.collection('users').doc(uid);

    // Read cloud data
    final metaDoc = await userDoc.get();
    final habitsSnap = await userDoc.collection('habits').get();
    final logsSnap = await userDoc.collection('habitLogs').get();
    final diarySnap = await userDoc.collection('diaryEntries').get();

    if (habitsSnap.docs.isEmpty && logsSnap.docs.isEmpty && diarySnap.docs.isEmpty) {
      throw Exception('No cloud data found');
    }

    if (metaDoc.exists) {
      final prefs = await SharedPreferences.getInstance();
      final metaData = metaDoc.data()!;
      final cloudName = metaData['displayName'] as String?;
      final cloudPhotoUrl = metaData['photoUrl'] as String?;
      // Legacy fallback: old docs may still have base64
      final cloudPhotoBase64 = metaData['photoBase64'] as String?;
      if (cloudName != null) {
        await prefs.setString('displayName', cloudName);
      }
      // Prefer Firebase Storage URL; fallback to legacy base64
      if (cloudPhotoUrl != null && cloudPhotoUrl.isNotEmpty) {
        await prefs.setString('photoUrl', cloudPhotoUrl);
        // Also cache base64 by downloading the image
        try {
          final ref = FirebaseStorage.instance
              .ref()
              .child('users/$uid/profile.jpg');
          final data = await ref.getData();
          if (data != null) {
            await prefs.setString('photoBase64', base64Encode(data));
          }
        } catch (e) {
          debugPrint('SyncService: Photo download failed: $e');
        }
      } else if (cloudPhotoBase64 != null) {
        await prefs.setString('photoBase64', cloudPhotoBase64);
      }
    }

    // Clear local data
    await _write((isar) {
      isar.habits.where().deleteAll();
      isar.habitLogs.where().deleteAll();
      isar.diaryEntrys.where().deleteAll();
    });

    // Restore habits
    for (final doc in habitsSnap.docs) {
      final m = doc.data();
      await _write((isar) {
        isar.habits.put(Habit(id: m['id'] as int)
          ..title = m['title'] as String? ?? ''
          ..subtitle = m['subtitle'] as String? ?? ''
          ..iconCodePoint = m['iconCodePoint'] as int? ?? 0
          ..iconFontFamily = m['iconFontFamily'] as String? ?? 'MaterialIcons'
          ..colorHex = m['colorHex'] as int? ?? 0
          ..bgColorHex = m['bgColorHex'] as int? ?? 0
          ..isCurrentFocus = m['isCurrentFocus'] as bool? ?? false
          ..createdAt = m['createdAt'] as String? ?? ''
          ..timeOfDay = m['timeOfDay'] as String? ?? 'Anytime'
          ..goalType = m['goalType'] as String? ?? 'off'
          ..goalValue = m['goalValue'] as int? ?? 0);
      });
    }

    // Restore logs
    for (final doc in logsSnap.docs) {
      final m = doc.data();
      await _write((isar) {
        isar.habitLogs.put(HabitLog(id: m['id'] as int)
          ..habitId = m['habitId'] as int? ?? 0
          ..date = m['date'] as String? ?? ''
          ..isCompleted = m['isCompleted'] as bool? ?? false
          ..progress = m['progress'] as int? ?? 0);
      });
    }

    // Restore diary
    for (final doc in diarySnap.docs) {
      final m = doc.data();
      await _write((isar) {
        isar.diaryEntrys.put(DiaryEntry(id: m['id'] as int)
          ..date = m['date'] as String? ?? ''
          ..dateLabel = m['dateLabel'] as String? ?? ''
          ..emoji = m['emoji'] as String? ?? ''
          ..emojiColorHex = m['emojiColorHex'] as int? ?? 0
          ..moodLevel = m['moodLevel'] as int? ?? 3
          ..title = m['title'] as String? ?? ''
          ..body = m['body'] as String? ?? '');
      });
    }

    debugPrint('SyncService: Restored ${habitsSnap.docs.length} habits, ${logsSnap.docs.length} logs, ${diarySnap.docs.length} diary entries');
  }

  // ─────────────────────────── HELPERS ───────────────────────────

  Future<void> _clearCollection(CollectionReference col) async {
    final snap = await col.get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
  }
}
