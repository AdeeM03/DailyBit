import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../services/database_helper.dart';

class DiaryProvider with ChangeNotifier {
  List<DiaryEntry> _diaryEntries = [];

  List<DiaryEntry> get diaryEntries => _diaryEntries;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  DiaryProvider() {
    _initData();
  }

  Future<void> _initData() async {
    try {
      await _loadDiaryEntries();
    } catch (e) {
      debugPrint("DiaryProvider init error: $e");
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
  }
}
