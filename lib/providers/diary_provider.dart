import 'dart:collection';
import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../services/database_helper.dart';
import '../services/sync_service.dart';

class DiaryProvider with ChangeNotifier {
  List<DiaryEntry> _diaryEntries = [];

  List<DiaryEntry> get diaryEntries => UnmodifiableListView(_diaryEntries);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DiaryProvider() {
    _initData();
  }

  Future<void> _initData() async {
    try {
      await _loadDiaryEntries();
    } catch (e) {
      debugPrint('DiaryProvider init error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadDiaryEntries() async {
    _diaryEntries = await DatabaseHelper.instance.readAllDiaryEntries();
  }

  Future<void> addDiaryEntry(DiaryEntry entry) async {
    await DatabaseHelper.instance.createDiaryEntry(entry);
    await _loadDiaryEntries();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  Future<void> updateDiaryEntry(DiaryEntry entry) async {
    await DatabaseHelper.instance.updateDiaryEntry(entry);
    await _loadDiaryEntries();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  Future<void> deleteDiaryEntry(int id) async {
    await DatabaseHelper.instance.deleteDiaryEntry(id);
    await _loadDiaryEntries();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  Future<void> deleteAllDiaryEntries() async {
    await DatabaseHelper.instance.deleteAllDiaryEntries();
    await _loadDiaryEntries();
    notifyListeners();
    SyncService.instance.scheduleSync();
  }

  /// Refresh all data from database (used after cloud restore)
  Future<void> refreshAll() async {
    await _loadDiaryEntries();
    notifyListeners();
  }
}
