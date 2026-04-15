import 'package:isar_plus/isar_plus.dart';

part 'diary_entry.g.dart';

@collection
class DiaryEntry {
  DiaryEntry({
    required this.id,
    this.date = '',
    this.dateLabel = '',
    this.emoji = '',
    this.emojiColorHex = 0,
    this.mood = '',
    this.body = '',
  });

  final int id;

  @Index()
  late String date; // ISO 'YYYY-MM-DD'

  late String dateLabel; // E.g., 'Monday, Oct 24'
  late String emoji;
  late int emojiColorHex;
  late String mood;
  late String body;
}
