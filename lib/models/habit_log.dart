import 'package:isar_plus/isar_plus.dart';

part 'habit_log.g.dart';

@collection
class HabitLog {
  HabitLog({
    required this.id,
    this.habitId = 0,
    this.date = '',
    this.isCompleted = false,
  });

  final int id;

  @Index(composite: ['date'])
  late int habitId;

  @Index()
  late String date; // Format: YYYY-MM-DD

  late bool isCompleted;
}
