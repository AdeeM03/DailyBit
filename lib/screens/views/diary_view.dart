import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/diary_provider.dart';
import '../../providers/habit_provider.dart';
import '../../models/diary_entry.dart';
import '../../widgets/diary_widgets.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({super.key});

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  int? _dayFilter;
  int? _moodFilter;

  // ─── Write / Edit Note Dialog ───
  void _showWriteNoteDialog(BuildContext context, {DiaryEntry? editEntry}) {
    final titleController = TextEditingController(text: editEntry?.title ?? '');
    final bodyController = TextEditingController(text: editEntry?.body ?? '');
    int selectedMood = editEntry?.moodLevel ?? 3;

    showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          backgroundColor: Theme.of(ctx).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            editEntry != null ? 'Edit Note' : "Write Today's Note",
            style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    labelStyle: GoogleFonts.nunito(),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Mood', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, fontSize: 13, color: Colors.grey.shade600)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: kMoodData.map((m) {
                    final level = m['level'] as int;
                    final isSelected = selectedMood == level;
                    return GestureDetector(
                      onTap: () => setS(() => selectedMood = level),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(m['color'] as int).withValues(alpha: 0.15) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? Color(m['color'] as int) : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            buildEmoji(m['asset'] as String, size: 30),
                            const SizedBox(height: 2),
                            Text(
                              '${m['level']}',
                              style: GoogleFonts.fredoka(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Color(m['color'] as int) : Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    kMoodData[selectedMood - 1]['label'] as String,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(kMoodData[selectedMood - 1]['color'] as int),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: bodyController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Notes (diary)',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    labelStyle: GoogleFonts.nunito(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('CANCEL', style: GoogleFonts.nunito(color: Colors.grey, fontWeight: FontWeight.w700)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty || bodyController.text.isNotEmpty) {
                  final now = DateTime.now();
                  final mood = kMoodData[selectedMood - 1];
                  if (editEntry != null) {
                    final updated = DiaryEntry(
                      id: editEntry.id,
                      date: editEntry.date,
                      dateLabel: editEntry.dateLabel,
                      emoji: mood['asset'] as String,
                      emojiColorHex: mood['color'] as int,
                      moodLevel: selectedMood,
                      title: titleController.text,
                      body: bodyController.text,
                    );
                    context.read<DiaryProvider>().updateDiaryEntry(updated);
                  } else {
                    final newEntry = DiaryEntry(
                      id: 0,
                      date: DateFormat('yyyy-MM-dd').format(now),
                      dateLabel: DateFormat('EEEE, MMM d').format(now),
                      emoji: mood['asset'] as String,
                      emojiColorHex: mood['color'] as int,
                      moodLevel: selectedMood,
                      title: titleController.text,
                      body: bodyController.text,
                    );
                    context.read<DiaryProvider>().addDiaryEntry(newEntry);
                  }
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF58CC02),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                editEntry != null ? 'UPDATE' : 'SAVE',
                style: GoogleFonts.fredoka(color: Colors.white, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Detail Dialog ───
  void _showDetailDialog(BuildContext context, DiaryEntry entry) {
    final moodInfo = kMoodData[entry.moodLevel.clamp(1, 5) - 1];
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            buildEmoji(entry.emoji, size: 32),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                entry.title.isNotEmpty ? entry.title : entry.dateLabel,
                style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Color(moodInfo['color'] as int).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      buildEmoji(moodInfo['asset'] as String, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        moodInfo['label'] as String,
                        style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Color(moodInfo['color'] as int)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(entry.dateLabel, style: GoogleFonts.nunito(fontSize: 12, color: Colors.grey.shade500)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              entry.body.isNotEmpty ? entry.body : '(no notes)',
              style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('CLOSE', style: GoogleFonts.nunito(color: Colors.grey, fontWeight: FontWeight.w700)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              _showWriteNoteDialog(context, editEntry: entry);
            },
            icon: const Icon(Icons.edit, size: 16),
            label: Text('EDIT', style: GoogleFonts.fredoka(fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF58CC02),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  // ─── 3-dot menu ───
  void _showCardMenu(BuildContext context, DiaryEntry entry) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.visibility_outlined, color: Color(0xFF58CC02)),
              title: Text('View Detail', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
              onTap: () { Navigator.pop(context); _showDetailDialog(context, entry); },
            ),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Color(0xFF1CB0F6)),
              title: Text('Edit', style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
              onTap: () { Navigator.pop(context); _showWriteNoteDialog(context, editEntry: entry); },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text('Delete', style: GoogleFonts.nunito(fontWeight: FontWeight.w700, color: Colors.redAccent)),
              onTap: () { Navigator.pop(context); context.read<DiaryProvider>().deleteDiaryEntry(entry.id); },
            ),
          ],
        ),
      ),
    );
  }

  List<DiaryEntry> _applyFilters(List<DiaryEntry> entries) {
    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final yesterday = DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)));
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    return entries.where((e) {
      if (_dayFilter != null) {
        if (_dayFilter == 0 && e.date != today) return false;
        if (_dayFilter == 1 && e.date != yesterday) return false;
        if (_dayFilter == 2) {
          final entryDate = DateTime.tryParse(e.date);
          if (entryDate == null || entryDate.isBefore(sevenDaysAgo)) return false;
        }
      }
      if (_moodFilter != null && e.moodLevel != _moodFilter) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DiaryProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF58CC02)));
    }

    final entries = _applyFilters(provider.diaryEntries);

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                _buildHeader(context.watch<HabitProvider>()),
                const SizedBox(height: 24),
                WriteNoteCard(onTap: () => _showWriteNoteDialog(context)),
                const SizedBox(height: 20),
                DiaryFilterSection(
                  dayFilter: _dayFilter,
                  moodFilter: _moodFilter,
                  onDayChanged: (v) => setState(() => _dayFilter = v),
                  onMoodChanged: (v) => setState(() => _moodFilter = v),
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Recent Thoughts'),
                const SizedBox(height: 20),
                if (entries.isEmpty)
                  const Center(child: Text('No entries yet. Start writing!', style: TextStyle(color: Colors.grey)))
                else
                  ...entries.take(10).map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DiaryEntryCard(
                      entry: entry,
                      onTap: () => _showDetailDialog(context, entry),
                      onMenuTap: () => _showCardMenu(context, entry),
                    ),
                  )),
                if (provider.diaryEntries.length > 10)
                  ViewAllHistoryButton(onTap: () {}),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF58CC02).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => _showWriteNoteDialog(context),
              backgroundColor: const Color(0xFF58CC02),
              elevation: 0,
              shape: const CircleBorder(),
              child: const Center(child: FaIcon(FontAwesomeIcons.penToSquare, color: Colors.white, size: 24)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(HabitProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32, height: 32,
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8)),
              child: const Center(child: FaIcon(FontAwesomeIcons.leaf, color: Color(0xFF58CC02), size: 18)),
            ),
            const SizedBox(width: 10),
            Text(
              'Daily Diary',
              style: TextStyle(fontFamily: 'Fredoka', fontSize: 22, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              provider.isStreakActiveToday ? 'assets/icons/fire-streak.svg' : 'assets/icons/streak_fire_inactive.svg',
              width: 24, height: 24,
            ),
            const SizedBox(width: 4),
            Text(
              '${provider.currentStreak}',
              style: GoogleFonts.fredoka(
                fontSize: 18, fontWeight: FontWeight.w800,
                color: provider.isStreakActiveToday ? const Color(0xFFFF9600) : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(title, style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(width: 12),
        Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
      ],
    );
  }
}
