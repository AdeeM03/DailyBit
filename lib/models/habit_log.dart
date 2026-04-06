import 'dart:convert';

class HabitLog {
  int? id;
  int habitId;
  String date; // Format: YYYY-MM-DD
  bool isCompleted;

  HabitLog({
    this.id,
    this.habitId = 0,
    this.date = '',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habitId': habitId,
      'date': date,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory HabitLog.fromMap(Map<String, dynamic> map) {
    return HabitLog(
      id: map['id'] as int?,
      habitId: map['habitId'] as int,
      date: map['date'] as String,
      isCompleted: map['isCompleted'] == 1 || map['isCompleted'] == true,
    );
  }

  String toJson() => json.encode(toMap());
  factory HabitLog.fromJson(String source) => HabitLog.fromMap(json.decode(source));
}
