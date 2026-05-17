import 'package:isar_plus/isar_plus.dart';
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../models/diary_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  late Isar _isar;
  Isar get isar => _isar;

  static const String _keyMigrated = 'data_migrated_to_isar';

  /// Initialize Isar and optionally migrate data from SharedPreferences
  Future<void> init(String directory) async {
    // On web, Isar must be initialized explicitly
    if (kIsWeb) {
      await Isar.initialize();
    }

    _isar = Isar.open(
      schemas: [HabitSchema, HabitLogSchema, DiaryEntrySchema],
      directory: kIsWeb ? Isar.sqliteInMemory : directory,
      engine: kIsWeb ? IsarEngine.sqlite : IsarEngine.isar,
      inspector: !kIsWeb,
    );

    // Try to migrate old SharedPreferences data
    await _migrateFromSharedPreferences();
  }

  // ─────── Platform-aware write helper ───────
  Future<void> _write(void Function(Isar isar) operation) async {
    if (kIsWeb) {
      _isar.write(operation);
    } else {
      await _isar.writeAsync(operation);
    }
  }

  // ─────────────────────────── DATA MIGRATION ───────────────────────────

  Future<void> _migrateFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final alreadyMigrated = prefs.getBool(_keyMigrated) ?? false;

    if (alreadyMigrated) return;

    final oldHabits = prefs.getStringList('habits_list');
    final oldLogs = prefs.getStringList('habit_logs_list');
    final oldDiary = prefs.getStringList('diary_entries_list');

    if (oldHabits == null && oldLogs == null && oldDiary == null) {
      await prefs.setBool(_keyMigrated, true);
      return;
    }

    if (oldHabits != null && oldHabits.isNotEmpty) {
      await _write((isar) {
        for (final jsonStr in oldHabits) {
          final map = json.decode(jsonStr) as Map<String, dynamic>;
          final habit = Habit(
            id: map['id'] as int? ?? isar.habits.autoIncrement(),
          )
            ..title = map['title'] as String? ?? ''
            ..subtitle = map['subtitle'] as String? ?? ''
            ..iconCodePoint = map['iconCodePoint'] as int? ?? 0
            ..iconFontFamily = map['iconFontFamily'] as String? ?? 'MaterialIcons'
            ..colorHex = map['colorHex'] as int? ?? 0
            ..bgColorHex = map['bgColorHex'] as int? ?? 0
            ..isCurrentFocus = map['isCurrentFocus'] == 1 || map['isCurrentFocus'] == true
            ..createdAt = map['createdAt'] as String? ?? '';
          isar.habits.put(habit);
        }
      });
    }

    if (oldLogs != null && oldLogs.isNotEmpty) {
      await _write((isar) {
        for (final jsonStr in oldLogs) {
          final map = json.decode(jsonStr) as Map<String, dynamic>;
          final log = HabitLog(
            id: map['id'] as int? ?? isar.habitLogs.autoIncrement(),
          )
            ..habitId = map['habitId'] as int? ?? 0
            ..date = map['date'] as String? ?? ''
            ..isCompleted = map['isCompleted'] == 1 || map['isCompleted'] == true;
          isar.habitLogs.put(log);
        }
      });
    }

    if (oldDiary != null && oldDiary.isNotEmpty) {
      await _write((isar) {
        for (final jsonStr in oldDiary) {
          final map = json.decode(jsonStr) as Map<String, dynamic>;
          final entry = DiaryEntry(
            id: map['id'] as int? ?? isar.diaryEntrys.autoIncrement(),
          )
            ..date = map['date'] as String? ?? ''
            ..dateLabel = map['dateLabel'] as String? ?? ''
            ..emoji = map['emoji'] as String? ?? ''
            ..emojiColorHex = map['emojiColorHex'] as int? ?? 0
            ..moodLevel = map['moodLevel'] as int? ?? (map['mood'] != null ? 3 : 3)
            ..title = map['title'] as String? ?? ''
            ..body = map['body'] as String? ?? '';
          isar.diaryEntrys.put(entry);
        }
      });
    }

    await prefs.setBool(_keyMigrated, true);
  }



  // ─────────────────────────── HABITS CRUD ───────────────────────────

  Future<List<Habit>> readAllHabits() async {
    return _isar.habits.where().findAll();
  }

  Future<Habit> createHabit(Habit habit) async {
    final newHabit = Habit(id: _isar.habits.autoIncrement())
      ..title = habit.title
      ..subtitle = habit.subtitle
      ..iconCodePoint = habit.iconCodePoint
      ..iconFontFamily = habit.iconFontFamily
      ..colorHex = habit.colorHex
      ..bgColorHex = habit.bgColorHex
      ..isCurrentFocus = habit.isCurrentFocus
      ..createdAt = habit.createdAt
      ..timeOfDay = habit.timeOfDay
      ..goalType = habit.goalType
      ..goalValue = habit.goalValue;

    await _write((isar) {
      isar.habits.put(newHabit);
    });
    return newHabit;
  }

  Future<void> updateHabit(Habit habit) async {
    await _write((isar) {
      isar.habits.put(habit);
    });
  }

  Future<void> deleteHabit(int id) async {
    await _write((isar) {
      isar.habits.delete(id);
    });
  }

  Future<void> deleteAllHabits() async {
    await _write((isar) {
      isar.habits.where().deleteAll();
      isar.habitLogs.where().deleteAll();
    });
  }

  // ─────────────────────────── HABIT LOGS ───────────────────────────

  Future<List<HabitLog>> getAllCompletedLogs() async {
    final allLogs = _isar.habitLogs.where().findAll();
    return allLogs.where((log) => log.isCompleted).toList();
  }

  Future<List<HabitLog>> getLogsForDate(String date) async {
    final allLogs = _isar.habitLogs.where().findAll();
    return allLogs.where((log) => log.date == date).toList();
  }

  Future<void> logHabitCompletion(int habitId, String date, bool isCompleted) async {
    final allLogs = _isar.habitLogs.where().findAll();
    final existing = allLogs.where(
      (log) => log.habitId == habitId && log.date == date,
    ).toList();

    if (existing.isNotEmpty) {
      final updated = HabitLog(id: existing.first.id)
        ..habitId = habitId
        ..date = date
        ..isCompleted = isCompleted;
      await _write((isar) {
        isar.habitLogs.put(updated);
      });
    } else {
      await _write((isar) {
        isar.habitLogs.put(HabitLog(id: isar.habitLogs.autoIncrement())
          ..habitId = habitId
          ..date = date
          ..isCompleted = isCompleted);
      });
    }
  }

  Future<void> logHabitProgress(int habitId, String date, int progress, bool isCompleted) async {
    final allLogs = _isar.habitLogs.where().findAll();
    final existing = allLogs.where(
      (log) => log.habitId == habitId && log.date == date,
    ).toList();

    if (existing.isNotEmpty) {
      final updated = HabitLog(id: existing.first.id)
        ..habitId = habitId
        ..date = date
        ..isCompleted = isCompleted
        ..progress = progress;
      await _write((isar) {
        isar.habitLogs.put(updated);
      });
    } else {
      await _write((isar) {
        isar.habitLogs.put(HabitLog(id: isar.habitLogs.autoIncrement())
          ..habitId = habitId
          ..date = date
          ..isCompleted = isCompleted
          ..progress = progress);
      });
    }
  }

  // ─────────────────────────── DIARY ENTRIES ───────────────────────────

  Future<List<DiaryEntry>> readAllDiaryEntries() async {
    final entries = _isar.diaryEntrys.where().findAll();
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  Future<DiaryEntry> createDiaryEntry(DiaryEntry entry) async {
    final newEntry = DiaryEntry(id: _isar.diaryEntrys.autoIncrement())
      ..date = entry.date
      ..dateLabel = entry.dateLabel
      ..emoji = entry.emoji
      ..emojiColorHex = entry.emojiColorHex
      ..moodLevel = entry.moodLevel
      ..title = entry.title
      ..body = entry.body;

    await _write((isar) {
      isar.diaryEntrys.put(newEntry);
    });
    return newEntry;
  }
  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    await _write((isar) {
      isar.diaryEntrys.put(entry);
    });
  }

  Future<void> deleteDiaryEntry(int id) async {
    await _write((isar) {
      isar.diaryEntrys.delete(id);
    });
  }

  Future<void> deleteAllDiaryEntries() async {
    await _write((isar) {
      isar.diaryEntrys.where().deleteAll();
    });
  }
}
