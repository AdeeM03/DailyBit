import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../models/diary_entry.dart';
import '../services/database_helper.dart';

class AppProvider with ChangeNotifier {
  List<Habit> _habits = [];
  List<HabitLog> _logsForSelectedDate = [];
  List<HabitLog> _allLogs = [];
  List<DiaryEntry> _diaryEntries = [];
  
  DateTime _selectedDate = DateTime.now();

  List<Habit> get habits => _habits;
  List<DiaryEntry> get diaryEntries => _diaryEntries;
  DateTime get selectedDate => _selectedDate;
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  AppProvider() {
    _initData();
  }

  Future<void> _initData() async {
    try {
      await DatabaseHelper.instance.autoSeed();
      await _loadHabits();
      await _loadLogsForSelectedDate();
      await _loadAllLogs();
      await _loadDiaryEntries();
    } catch (e) {
      debugPrint("Error loading from DB: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- Dates ---
  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    _loadLogsForSelectedDate();
  }

  String get selectedDateStr => DateFormat('yyyy-MM-dd').format(_selectedDate);

  // --- Habits ---
  Future<void> _loadHabits() async {
    _habits = await DatabaseHelper.instance.readAllHabits();
  }

  Future<void> addHabit(Habit habit) async {
    await DatabaseHelper.instance.createHabit(habit);
    await _loadHabits();
    notifyListeners();
  }

  Future<void> updateHabit(Habit habit) async {
    await DatabaseHelper.instance.updateHabit(habit);
    await _loadHabits();
    notifyListeners();
  }

  Future<void> deleteHabit(int id) async {
    await DatabaseHelper.instance.deleteHabit(id);
    await _loadHabits();
    notifyListeners();
  }

  // --- Habit Logs (Check/Uncheck) ---
  Future<void> _loadLogsForSelectedDate() async {
    _logsForSelectedDate = await DatabaseHelper.instance.getLogsForDate(selectedDateStr);
    notifyListeners();
  }

  Future<void> _loadAllLogs() async {
    _allLogs = await DatabaseHelper.instance.getAllCompletedLogs();
  }

  bool isHabitCompletedOnSelectedDate(int habitId) {
    try {
      final log = _logsForSelectedDate.firstWhere((log) => log.habitId == habitId);
      return log.isCompleted;
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleHabitCompletion(int habitId) async {
    final currentlyCompleted = isHabitCompletedOnSelectedDate(habitId);
    final newState = !currentlyCompleted;

    // Optimistic UI update could be done here, but we'll fetch from DB to be safe
    await DatabaseHelper.instance.logHabitCompletion(habitId, selectedDateStr, newState);
    await _loadLogsForSelectedDate();
    await _loadAllLogs(); // For history stats
    notifyListeners();
  }

  // --- Diary Entries ---
  Future<void> _loadDiaryEntries() async {
    _diaryEntries = await DatabaseHelper.instance.readAllDiaryEntries();
  }

  Future<void> addDiaryEntry(DiaryEntry entry) async {
    await DatabaseHelper.instance.createDiaryEntry(entry);
    await _loadDiaryEntries();
    notifyListeners();
  }

  // --- History View Stats Aggregation ---
  int get currentStreak => 7; // For now hardcoded or calculated. Let's keep it simple.
  
  int get totalHabitsFinished => _allLogs.length;

  double get completionRate {
    if (_allLogs.isEmpty) return 0.0;
    // Dummy calculation for UI. Ideally: total completed / (total possible days * habits)
    return 0.94; // 94%
  }

  Set<int> getCompletedDaysInMonth(int year, int month) {
    // Return days of the month where all habits were completed, 
    // or at least one habit was completed. We'll use "at least one" for simplicity.
    final Set<int> completedDays = {};
    for (var log in _allLogs) {
      if (log.isCompleted) {
        final dateObj = DateTime.parse(log.date);
        if (dateObj.year == year && dateObj.month == month) {
          completedDays.add(dateObj.day);
        }
      }
    }
    return completedDays;
  }
}
