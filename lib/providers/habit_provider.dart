import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../services/database_helper.dart';
import '../services/sync_service.dart';

class HabitProvider with ChangeNotifier {
  List<Habit> _habits = [];
  List<HabitLog> _logsForSelectedDate = [];
  List<HabitLog> _allCompletedLogs = [];

  DateTime _selectedDate = DateTime.now();

  List<Habit> get habits => UnmodifiableListView(_habits);
  DateTime get selectedDate => _selectedDate;
  List<HabitLog> get allCompletedLogs => UnmodifiableListView(_allCompletedLogs);

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  bool _isChangingDate = false;

  HabitProvider() {
    _initData();
  }

  Future<void> _initData() async {
    try {
      await _loadHabits();
      await _loadLogsForSelectedDate();
      await _loadAllCompletedLogs();
    } catch (e) {
      debugPrint('HabitProvider init error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─────────────────────────── DATES ───────────────────────────

  Future<void> setSelectedDate(DateTime date) async {
    if (_isChangingDate) return;
    _isChangingDate = true;
    _selectedDate = date;
    await _loadLogsForSelectedDate();
    _isChangingDate = false;
  }

  String get selectedDateStr => DateFormat('yyyy-MM-dd').format(_selectedDate);

  // ─────────────────────────── HABITS CRUD ───────────────────────────

  Future<void> _loadHabits() async {
    final dbHabits = await DatabaseHelper.instance.readAllHabits();
    
    // Auto-cleanup starter habits if they exist to provide a clean slate
    if (dbHabits.any((h) => h.title == 'My first habit' || h.title == 'Hydrate')) {
      await DatabaseHelper.instance.deleteAllHabits();
      _habits = [];
    } else {
      _habits = dbHabits;
    }
  }

  Future<void> addHabit(Habit habit) async {
    await DatabaseHelper.instance.createHabit(habit);
    await _loadHabits();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  Future<void> updateHabit(Habit habit) async {
    await DatabaseHelper.instance.updateHabit(habit);
    await _loadHabits();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  Future<void> deleteHabit(int id) async {
    await DatabaseHelper.instance.deleteHabit(id);
    await _loadHabits();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  Future<void> deleteAllHabits() async {
    await DatabaseHelper.instance.deleteAllHabits();
    await _loadHabits();
    await _loadAllCompletedLogs();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  // ─────────────────────────── HABIT LOGS ───────────────────────────

  Future<void> _loadLogsForSelectedDate() async {
    _logsForSelectedDate = await DatabaseHelper.instance.getLogsForDate(selectedDateStr);
    notifyListeners();
  }

  Future<void> _loadAllCompletedLogs() async {
    _allCompletedLogs = await DatabaseHelper.instance.getAllCompletedLogs();
  }

  bool isHabitCompletedOnSelectedDate(int habitId) {
    final log = _logsForSelectedDate
        .where((l) => l.habitId == habitId)
        .firstOrNull;
    if (log != null) return log.isCompleted;
    final habit = _habits.where((h) => h.id == habitId).firstOrNull;
    return habit?.goalType == 'negative';
  }

  int getHabitProgressOnSelectedDate(int habitId) {
    final log = _logsForSelectedDate
        .where((l) => l.habitId == habitId)
        .firstOrNull;
    return log?.progress ?? 0;
  }

  Future<void> updateHabitProgress(int habitId, int progress, bool isCompleted) async {
    // This requires adding an updateProgress method to DatabaseHelper.
    // For now, if we don't have it, we might need to modify DatabaseHelper too.
    await DatabaseHelper.instance.logHabitProgress(habitId, selectedDateStr, progress, isCompleted);
    await _loadLogsForSelectedDate();
    await _loadAllCompletedLogs();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  Future<void> toggleHabitCompletion(int habitId) async {
    final currentlyCompleted = isHabitCompletedOnSelectedDate(habitId);
    final newState = !currentlyCompleted;

    await DatabaseHelper.instance.logHabitCompletion(habitId, selectedDateStr, newState);
    await _loadLogsForSelectedDate();
    await _loadAllCompletedLogs();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  // ─────────────────────────── DYNAMIC STATS ───────────────────────────

  /// Calculate current streak: consecutive days with at least 1 habit completed.
  /// Counts backwards from today (or yesterday if today has no completions).
  int get currentStreak {
    if (_allCompletedLogs.isEmpty) return 0;

    // Get unique completed dates
    final Set<String> completedDates = {};
    for (final log in _allCompletedLogs) {
      completedDates.add(log.date);
    }

    // Sort dates descending
    final sortedDates = completedDates.toList()..sort((a, b) => b.compareTo(a));
    if (sortedDates.isEmpty) return 0;

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final yesterday = DateFormat('yyyy-MM-dd').format(
      DateTime.now().subtract(const Duration(days: 1)),
    );

    // Determine starting point
    DateTime checkDate;
    if (completedDates.contains(today)) {
      checkDate = DateTime.now();
    } else if (completedDates.contains(yesterday)) {
      checkDate = DateTime.now().subtract(const Duration(days: 1));
    } else {
      return 0; // No recent activity
    }

    // Count consecutive days backwards
    int streak = 0;
    while (true) {
      final dateStr = DateFormat('yyyy-MM-dd').format(checkDate);
      if (completedDates.contains(dateStr)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  bool get isStreakActiveToday {
    if (_allCompletedLogs.isEmpty) return false;
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return _allCompletedLogs.any((log) => log.date == today);
  }

  /// Completion rate = total completed logs / (total habits × total tracked days)
  double get completionRate {
    if (_allCompletedLogs.isEmpty || _habits.isEmpty) return 0.0;

    // Find earliest habit creation date
    String? earliestDate;
    for (final habit in _habits) {
      if (habit.createdAt.isNotEmpty) {
        if (earliestDate == null || habit.createdAt.compareTo(earliestDate) < 0) {
          earliestDate = habit.createdAt;
        }
      }
    }

    if (earliestDate == null) return 0.0;

    final startDate = DateTime.parse(earliestDate);
    final today = DateTime.now();
    final totalDays = today.difference(startDate).inDays + 1; // Include today

    if (totalDays <= 0) return 0.0;

    final totalPossible = _habits.length * totalDays;
    final totalCompleted = _allCompletedLogs.length;

    final rate = totalCompleted / totalPossible;
    return rate.clamp(0.0, 1.0);
  }

  int get totalHabitsFinished => _allCompletedLogs.length;

  Set<int> getCompletedDaysInMonth(int year, int month) {
    final Set<int> completedDays = {};
    for (var log in _allCompletedLogs) {
      final dateObj = DateTime.parse(log.date);
      if (dateObj.year == year && dateObj.month == month) {
        completedDays.add(dateObj.day);
      }
    }
    return completedDays;
  }

  /// Refresh all data from database (used after cloud restore)
  Future<void> refreshAll() async {
    await _loadHabits();
    await _loadLogsForSelectedDate();
    await _loadAllCompletedLogs();
    notifyListeners();
  }
}
