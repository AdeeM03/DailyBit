import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/diary_entry.dart';

/// Shared mood data used across diary widgets.
const List<Map<String, Object>> kMoodData = [
  {'level': 1, 'label': 'Horrible', 'asset': 'assets/icons/mood_1.svg', 'color': 0xFFE53935},
  {'level': 2, 'label': 'Sad',      'asset': 'assets/icons/mood_2.svg', 'color': 0xFFE57373},
  {'level': 3, 'label': 'Neutral',  'asset': 'assets/icons/mood_3.svg', 'color': 0xFFFFB300},
  {'level': 4, 'label': 'Happy',    'asset': 'assets/icons/mood_4.svg', 'color': 0xFF58CC02},
  {'level': 5, 'label': 'Amazing',  'asset': 'assets/icons/mood_5.svg', 'color': 0xFF1CB0F6},
];

/// Renders an SVG or emoji string.
Widget buildEmoji(String emojiData, {double size = 24}) {
  if (emojiData.startsWith('assets/')) {
    return SvgPicture.asset(emojiData, width: size, height: size);
  }
  return Text(emojiData, style: TextStyle(fontSize: size));
}

/// Truncates body text to max 7 words.
String truncateBody(String text) {
  final words = text.trim().split(RegExp(r'\s+'));
  if (words.length <= 7) return text;
  return '${words.take(7).join(' ')}...';
}

/// Green CTA card for writing a new diary note.
class WriteNoteCard extends StatelessWidget {
  final VoidCallback onTap;

  const WriteNoteCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ChicletAnimatedButton(
      onPressed: onTap,
      width: double.infinity,
      height: 80,
      buttonHeight: 5,
      borderRadius: 12,
      backgroundColor: const Color(0xFF58CC02),
      buttonColor: const Color(0xFF58A700),
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Write Today's Note",
                    style: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Record your wins & reflections',
                    style: GoogleFonts.nunito(fontSize: 13, color: Colors.white.withValues(alpha: 0.85)),
                  ),
                ],
              ),
            ),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: FaIcon(FontAwesomeIcons.list, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual diary entry card.
class DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onTap;
  final VoidCallback onMenuTap;

  const DiaryEntryCard({
    super.key,
    required this.entry,
    required this.onTap,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(entry.emojiColorHex).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: buildEmoji(entry.emoji, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.title.isNotEmpty ? entry.title : entry.dateLabel,
                        style: GoogleFonts.fredoka(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            kMoodData[entry.moodLevel.clamp(1, 5) - 1]['label'] as String,
                            style: GoogleFonts.nunito(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(entry.emojiColorHex),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            entry.dateLabel,
                            style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: onMenuTap,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: FaIcon(FontAwesomeIcons.ellipsis, color: Colors.grey.shade400, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              truncateBody(entry.body),
              style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

/// "View All History" button at the bottom.
class ViewAllHistoryButton extends StatelessWidget {
  final VoidCallback onTap;

  const ViewAllHistoryButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ChicletAnimatedButton(
        onPressed: onTap,
        width: double.infinity,
        height: 64,
        buttonHeight: 5,
        borderRadius: 12,
        backgroundColor: const Color(0xFF58CC02),
        buttonColor: const Color(0xFF58A700),
        padding: EdgeInsets.zero,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(FontAwesomeIcons.clockRotateLeft, color: Colors.white, size: 15),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'VIEW ALL HISTORY',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Day and mood filter rows.
class DiaryFilterSection extends StatelessWidget {
  final int? dayFilter;
  final int? moodFilter;
  final void Function(int?) onDayChanged;
  final void Function(int?) onMoodChanged;

  static const _dayLabels = ['Today', 'Yesterday', 'Last 7 Days'];

  const DiaryFilterSection({
    super.key,
    required this.dayFilter,
    required this.moodFilter,
    required this.onDayChanged,
    required this.onMoodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Filter by Day', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dayLabels.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final selected = dayFilter == i;
              return GestureDetector(
                onTap: () => onDayChanged(selected ? null : i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected ? const Color(0xFF58CC02) : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? const Color(0xFF58CC02) : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    _dayLabels[i],
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text('Filter by Mood', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.grey.shade500)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: kMoodData.map((m) {
              final level = m['level'] as int;
              final selected = moodFilter == level;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => onMoodChanged(selected ? null : level),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected ? Color(m['color'] as int).withValues(alpha: 0.15) : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected ? Color(m['color'] as int) : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildEmoji(m['asset'] as String, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          m['label'] as String,
                          style: GoogleFonts.nunito(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: selected ? Color(m['color'] as int) : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
