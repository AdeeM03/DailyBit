import 'dart:convert';

class Habit {
  int? id;
  String title;
  String subtitle;
  int iconCodePoint;
  String iconFontFamily;
  int colorHex;
  int bgColorHex;
  bool isCurrentFocus;
  String createdAt;

  Habit({
    this.id,
    this.title = '',
    this.subtitle = '',
    this.iconCodePoint = 0,
    this.iconFontFamily = 'MaterialIcons',
    this.colorHex = 0,
    this.bgColorHex = 0,
    this.isCurrentFocus = false,
    this.createdAt = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'iconCodePoint': iconCodePoint,
      'iconFontFamily': iconFontFamily,
      'colorHex': colorHex,
      'bgColorHex': bgColorHex,
      'isCurrentFocus': isCurrentFocus ? 1 : 0,
      'createdAt': createdAt,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int?,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String,
      iconCodePoint: map['iconCodePoint'] as int,
      iconFontFamily: map['iconFontFamily'] as String,
      colorHex: map['colorHex'] as int,
      bgColorHex: map['bgColorHex'] as int,
      isCurrentFocus: map['isCurrentFocus'] == 1 || map['isCurrentFocus'] == true,
      createdAt: map['createdAt'] as String? ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory Habit.fromJson(String source) => Habit.fromMap(json.decode(source));
}
