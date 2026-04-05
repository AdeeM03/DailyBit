import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';

class DiaryView extends StatefulWidget {
  const DiaryView({super.key});

  @override
  State<DiaryView> createState() => _DiaryViewState();
}

class _DiaryViewState extends State<DiaryView> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All entries', 'Favorites', 'Mood Tracker'];

  // Hardcoded diary entries
  final List<Map<String, dynamic>> _entries = [
    {
      'emoji': '😊',
      'emojiColor': const Color(0xFF7CB342),
      'date': 'Monday, Oct 24',
      'mood': 'ENERGETIC MORNING',
      'body':
          'Finally managed to finish the 30-minute meditation session. Feeling incredibly grounded and ready to tackle the week\'s goals!',
    },
    {
      'emoji': '🍃',
      'emojiColor': const Color(0xFF558B2F),
      'date': 'Sunday, Oct 23',
      'mood': 'FOCUSED FLOW',
      'body':
          'Hit a 7-day streak today! The new habit of reading before bed is actually sticking. Brain feels much less cluttered.',
    },
    {
      'emoji': '☁️',
      'emojiColor': const Color(0xFF90CAF9),
      'date': 'Oct 22',
      'body': 'A bit tired today but kept the routine alive...',
      'isSmall': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                _buildHeader(),
                const SizedBox(height: 24),

                // ─── Write Today's Note Card ───
                _buildWriteNoteCard(),
                const SizedBox(height: 20),

                // ─── Filter Chips ───
                _buildFilterChips(),
                const SizedBox(height: 24),

                // ─── Recent Thoughts Section ───
                _buildSectionTitle('Recent Thoughts'),
                const SizedBox(height: 20),

                // ─── Diary Entry Cards ───
                _buildDiaryEntryCard(_entries[0]),
                const SizedBox(height: 16),
                _buildDiaryEntryCard(_entries[1]),
                const SizedBox(height: 16),

                // ─── Small card + View All History ───
                _buildBottomRow(),
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
              onPressed: () {},
              backgroundColor: const Color(0xFF7CB342),
              elevation: 0,
              shape: const CircleBorder(),
              child:
                  const Icon(Icons.edit_rounded, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────
  //  HEADER: "Daily Diary" + streak badge
  // ────────────────────────────────────────
  Widget _buildHeader() {
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
              child: const Icon(Icons.eco_rounded,
                  color: Color(0xFF7CB342), size: 18),
            ),
            const SizedBox(width: 10),
            const Text(
              'Daily Diary',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2D3142),
              ),
            ),
          ],
        ),
        // Streak badge
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
              const Text(
                '7 Day Streak',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF558B2F),
                ),
              ),
              const SizedBox(width: 4),
              const Text('✨', style: TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ],
    );
  }

  // ────────────────────────────────────────
  //  WRITE TODAY'S NOTE — Green Card
  // ────────────────────────────────────────
  Widget _buildWriteNoteCard() {
    return ChicletAnimatedButton(
      onPressed: () {},
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
                  const Text(
                    "Write Today's Note",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Record your wins & reflections',
                    style: TextStyle(
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
              child: const Icon(Icons.format_list_bulleted_rounded,
                  color: Colors.white, size: 22),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────
  //  FILTER CHIPS
  // ────────────────────────────────────────
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
                style: TextStyle(
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

  // ────────────────────────────────────────
  //  SECTION TITLE with divider
  // ────────────────────────────────────────
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(color: Colors.grey.shade300, thickness: 1),
        ),
      ],
    );
  }

  // ────────────────────────────────────────
  //  DIARY ENTRY CARD (full size)
  // ────────────────────────────────────────
  Widget _buildDiaryEntryCard(Map<String, dynamic> entry) {
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
          // Header row: emoji + date + mood + menu
          Row(
            children: [
              // Emoji circle
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: (entry['emojiColor'] as Color).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(entry['emoji'], style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry['date'],
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    if (entry['mood'] != null)
                      Text(
                        entry['mood'],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: entry['emojiColor'] as Color,
                          letterSpacing: 1.2,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.more_horiz, color: Colors.grey.shade400, size: 22),
            ],
          ),
          const SizedBox(height: 14),
          // Body text
          Text(
            entry['body'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────
  //  BOTTOM ROW: Small card + View All History
  // ────────────────────────────────────────
  Widget _buildBottomRow() {
    final smallEntry = _entries[2];
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Small diary card
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
                    color: (smallEntry['emojiColor'] as Color)
                        .withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(smallEntry['emoji'],
                      style: const TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 10),
                Text(
                  smallEntry['date'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  smallEntry['body'],
                  style: TextStyle(
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
        const SizedBox(width: 12),
        // View All History button
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
                  child: const Icon(Icons.add, color: Colors.white, size: 20),
                ),
                const SizedBox(height: 8),
                const Text(
                  'VIEW ALL\nHISTORY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
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
