import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../models/habit.dart';
import '../models/habit_log.dart';
import '../models/diary_entry.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  DatabaseHelper._init();

  // Storage keys
  static const String keyHabits = 'habits_list';
  static const String keyHabitLogs = 'habit_logs_list';
  static const String keyDiaryEntries = 'diary_entries_list';
  static const String keySeeded = 'db_seeded';

  Future<SharedPreferences> get prefs async {
    return await SharedPreferences.getInstance();
  }

  Future<void> autoSeed() async {
    final p = await prefs;
    final isSeeded = p.getBool(keySeeded) ?? false;
    
    if (isSeeded) return;

    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // 1. Seed Habits
    final habit1 = Habit(id: 1, title: 'My first habit', subtitle: 'Every morning • 15 mins', iconCodePoint: 0, iconFontFamily: 'MaterialIcons', colorHex: 0xFF7CB342, bgColorHex: 0xFF558B2F, isCurrentFocus: true, createdAt: todayStr);
    final habit2 = Habit(id: 2, title: 'Hydrate', subtitle: '500ml of water', iconCodePoint: 0xe6b5, iconFontFamily: 'MaterialIcons', colorHex: 0xFF42A5F5, bgColorHex: 0xFFE3F2FD, isCurrentFocus: false, createdAt: todayStr);
    final habit3 = Habit(id: 3, title: 'Mindfulness', subtitle: 'Deep breathing exercise', iconCodePoint: 0xe58b, iconFontFamily: 'MaterialIcons', colorHex: 0xFF66BB6A, bgColorHex: 0xFFE8F5E9, isCurrentFocus: false, createdAt: todayStr);
    
    await p.setStringList(keyHabits, [habit1.toJson(), habit2.toJson(), habit3.toJson()]);

    // 2. Seed HabitLog
    final log1 = HabitLog(id: 1, habitId: 1, date: todayStr, isCompleted: true);
    await p.setStringList(keyHabitLogs, [log1.toJson()]);

    // 3. Seed Diary Entries
    final diary1 = DiaryEntry(id: 1, date: '2026-10-24', dateLabel: 'Monday, Oct 24', emoji: '😊', emojiColorHex: 0xFF7CB342, mood: 'ENERGETIC MORNING', body: 'Finally managed to finish the 30-minute meditation session.');
    final diary2 = DiaryEntry(id: 2, date: '2026-10-23', dateLabel: 'Sunday, Oct 23', emoji: '🍃', emojiColorHex: 0xFF558B2F, mood: 'FOCUSED FLOW', body: 'Hit a 7-day streak today!');
    await p.setStringList(keyDiaryEntries, [diary1.toJson(), diary2.toJson()]);

    await p.setBool(keySeeded, true);
  }

  // --- Habits CRUD ---
  Future<List<Habit>> readAllHabits() async {
    final p = await prefs;
    final list = p.getStringList(keyHabits) ?? [];
    return list.map((e) => Habit.fromJson(e)).toList();
  }

  Future<Habit> createHabit(Habit habit) async {
    final p = await prefs;
    final habits = await readAllHabits();
    
    // Auto increment ID (JSON specific logic)
    int nextId = 1;
    if (habits.isNotEmpty) {
      nextId = habits.map((h) => h.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    habit.id = nextId;
    habits.add(habit);
    
    await p.setStringList(keyHabits, habits.map((e) => e.toJson()).toList());
    return habit; 
  }

  Future<void> updateHabit(Habit habit) async {
    final p = await prefs;
    final habits = await readAllHabits();
    final index = habits.indexWhere((h) => h.id == habit.id);
    if (index != -1) {
      habits[index] = habit;
      await p.setStringList(keyHabits, habits.map((e) => e.toJson()).toList());
    }
  }

  Future<void> deleteHabit(int id) async {
    final p = await prefs;
    final habits = await readAllHabits();
    habits.removeWhere((h) => h.id == id);
    await p.setStringList(keyHabits, habits.map((e) => e.toJson()).toList());
  }

  // --- Habit Logs CRUD ---
  Future<List<HabitLog>> getAllCompletedLogs() async {
    final p = await prefs;
    final list = p.getStringList(keyHabitLogs) ?? [];
    final allLogs = list.map((e) => HabitLog.fromJson(e)).toList();
    return allLogs.where((log) => log.isCompleted).toList();
  }

  Future<List<HabitLog>> getLogsForDate(String date) async {
    final p = await prefs;
    final list = p.getStringList(keyHabitLogs) ?? [];
    final allLogs = list.map((e) => HabitLog.fromJson(e)).toList();
    return allLogs.where((log) => log.date == date).toList();
  }

  Future<void> logHabitCompletion(int habitId, String date, bool isCompleted) async {
    final p = await prefs;
    final list = p.getStringList(keyHabitLogs) ?? [];
    List<HabitLog> allLogs = list.map((e) => HabitLog.fromJson(e)).toList();

    int existingIndex = allLogs.indexWhere((log) => log.habitId == habitId && log.date == date);
    
    if (existingIndex >= 0) {
      allLogs[existingIndex].isCompleted = isCompleted;
    } else {
      int nextId = 1;
      if (allLogs.isNotEmpty) {
        nextId = allLogs.map((l) => l.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
      }
      allLogs.add(HabitLog(id: nextId, habitId: habitId, date: date, isCompleted: isCompleted));
    }

    await p.setStringList(keyHabitLogs, allLogs.map((e) => e.toJson()).toList());
  }

  // --- Diary Entries CRUD ---
  Future<List<DiaryEntry>> readAllDiaryEntries() async {
    final p = await prefs;
    final list = p.getStringList(keyDiaryEntries) ?? [];
    List<DiaryEntry> entries = list.map((e) => DiaryEntry.fromJson(e)).toList();
    entries.sort((a, b) => b.date.compareTo(a.date)); // Descending by date
    return entries;
  }

  Future<DiaryEntry> createDiaryEntry(DiaryEntry entry) async {
    final p = await prefs;
    final entries = await readAllDiaryEntries();

    int nextId = 1;
    if (entries.isNotEmpty) {
      nextId = entries.map((d) => d.id ?? 0).reduce((a, b) => a > b ? a : b) + 1;
    }
    entry.id = nextId;
    entries.add(entry);

    await p.setStringList(keyDiaryEntries, entries.map((e) => e.toJson()).toList());
    return entry;
  }
}
