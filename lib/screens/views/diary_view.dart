import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_provider.dart';
import '../../models/diary_entry.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({super.key});

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All entries', 'Favorites', 'Mood Tracker'];

  void _showWriteNoteDialog(BuildContext context) {
    final bodyController = TextEditingController();
    final moodController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("Write Today's Note", style: GoogleFonts.fredoka(fontWeight: FontWeight.bold, fontSize: 20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: moodController,
                decoration: const InputDecoration(
                  labelText: 'Mood (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: bodyController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'How was your day?',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CANCEL', style: GoogleFonts.nunito(color: Colors.grey, fontWeight: FontWeight.w700)),
            ),
            ElevatedButton(
              onPressed: () {
                if (bodyController.text.isNotEmpty) {
                  final now = DateTime.now();
                  final newEntry = DiaryEntry(
                    date: DateFormat('yyyy-MM-dd').format(now),
                    dateLabel: DateFormat('EEEE, MMM d').format(now),
                    emoji: '📝',
                    emojiColorHex: 0xFFFBC02D,
                    mood: moodController.text.toUpperCase(),
                    body: bodyController.text,
                  );
                  context.read<AppProvider>().addDiaryEntry(newEntry);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7CB342),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('SAVE', style: GoogleFonts.fredoka(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7CB342)));
    }

    final entries = provider.diaryEntries;

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
                // ─── Header ───
                _buildHeader(provider.currentStreak),
                const SizedBox(height: 24),

                // ─── Write Today's Note Card ───
                _buildWriteNoteCard(context),
                const SizedBox(height: 20),

                // ─── Filter Chips ───
                _buildFilterChips(),
                const SizedBox(height: 24),

                // ─── Recent Thoughts Section ───
                _buildSectionTitle('Recent Thoughts'),
                const SizedBox(height: 20),

                // ─── Diary Entry Cards ───
                if (entries.isEmpty)
                   const Center(child: Text("No entries yet. Start writing!", style: TextStyle(color: Colors.grey)))
                else
                  ...entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildDiaryEntryCard(entry),
                  )),

                // ─── Small card + View All History ───
                _buildBottomRow(entries),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),

        // ─── FAB ───
        Positioned(
          bottom: 24,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7CB342).withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: FloatingActionButton(
              onPressed: () => _showWriteNoteDialog(context),
              backgroundColor: const Color(0xFF7CB342),
              elevation: 0,
              shape: const CircleBorder(),
              child: const Center(child: FaIcon(FontAwesomeIcons.penToSquare, color: Colors.white, size: 24)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(int streak) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: FaIcon(FontAwesomeIcons.leaf,
                    color: Color(0xFF7CB342), size: 18),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Daily Diary',
              style: TextStyle(
                fontFamily: 'Fredoka',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3142),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$streak Day Streak',
                style: GoogleFonts.fredoka(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF558B2F),
                ),
              ),
              const SizedBox(width: 4),
              const FaIcon(FontAwesomeIcons.wandMagicSparkles, color: Colors.amber, size: 14),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWriteNoteCard(BuildContext context) {
    return ChicletAnimatedButton(
      onPressed: () => _showWriteNoteDialog(context),
      width: double.infinity,
      height: 80,
      buttonHeight: 5,
      borderRadius: 22,
      backgroundColor: const Color(0xFF7CB342),
      buttonColor: const Color(0xFF558B2F),
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
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Record your wins & reflections',
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
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
                child: FaIcon(FontAwesomeIcons.list,
                    color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = index == _selectedFilter;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF7CB342) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF7CB342)
                      : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Text(
                _filters[index],
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF2D3142),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(color: Colors.grey.shade300, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildDiaryEntryCard(DiaryEntry entry) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
                child: Text(entry.emoji, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.dateLabel,
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2D3142),
                      ),
                    ),
                    if (entry.mood.isNotEmpty)
                      Text(
                        entry.mood,
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(entry.emojiColorHex),
                          letterSpacing: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
              FaIcon(FontAwesomeIcons.ellipsis, color: Colors.grey.shade400, size: 18),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            entry.body,
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow(List<DiaryEntry> entries) {
    // If we have enough entries, we'll try to pick a small one, or just the last for demonstration.
    DiaryEntry? smallEntry = entries.isNotEmpty ? entries.last : null;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (smallEntry != null)
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(smallEntry.emojiColorHex)
                        .withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(smallEntry.emoji,
                      style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                Text(
                  smallEntry.dateLabel,
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  smallEntry.body,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        if (smallEntry != null) const SizedBox(width: 12),
        
        Expanded(
          flex: 2,
          child: ChicletAnimatedButton(
            onPressed: () {},
            height: 120,
            buttonHeight: 5,
            borderRadius: 20,
            backgroundColor: const Color(0xFF7CB342),
            buttonColor: const Color(0xFF558B2F),
            padding: EdgeInsets.zero,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 18)),
                ),
                const SizedBox(height: 8),
                const Text(
                  'VIEW ALL\nHISTORY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Fredoka',
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.8,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
