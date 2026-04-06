import 'dart:convert';

class DiaryEntry {
  int? id;
  String date; // ISO 'YYYY-MM-DD'
  String dateLabel; // E.g., 'Monday, Oct 24'
  String emoji;
  int emojiColorHex;
  String mood;
  String body;

  DiaryEntry({
    this.id,
    this.date = '',
    this.dateLabel = '',
    this.emoji = '',
    this.emojiColorHex = 0,
    this.mood = '',
    this.body = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'dateLabel': dateLabel,
      'emoji': emoji,
      'emojiColorHex': emojiColorHex,
      'mood': mood,
      'body': body,
    };
  }

  factory DiaryEntry.fromMap(Map<String, dynamic> map) {
    return DiaryEntry(
      id: map['id'] as int?,
      date: map['date'] as String,
      dateLabel: map['dateLabel'] as String,
      emoji: map['emoji'] as String,
      emojiColorHex: map['emojiColorHex'] as int,
      mood: map['mood'] as String,
      body: map['body'] as String,
    );
  }

  String toJson() => json.encode(toMap());
  factory DiaryEntry.fromJson(String source) => DiaryEntry.fromMap(json.decode(source));
}
