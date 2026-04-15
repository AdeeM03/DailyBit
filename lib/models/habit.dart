import 'package:isar_plus/isar_plus.dart';

part 'habit.g.dart';

@collection
class Habit {
  Habit({
    required this.id,
    this.title = '',
    this.subtitle = '',
    this.iconCodePoint = 0,
    this.iconFontFamily = 'MaterialIcons',
    this.colorHex = 0,
    this.bgColorHex = 0,
    this.isCurrentFocus = false,
    this.createdAt = '',
  });

  final int id;

  late String title;
  late String subtitle;
  late int iconCodePoint;
  late String iconFontFamily;
  late int colorHex;
  late int bgColorHex;
  late bool isCurrentFocus;

  @Index()
  late String createdAt;
}
