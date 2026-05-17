import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import '../../providers/habit_provider.dart';
import '../../models/habit.dart';
import '../../widgets/chiclet_habit_card.dart';

// ─────────────────────────────────────────────────────────
//  ACHIEVEMENT DATA MODEL
// ─────────────────────────────────────────────────────────

class _Achievement {
  final String title;
  final String description;
  final String emoji;
  final int level;
  final bool claimed;
  final double progress; // 0.0 - 1.0
  final String? progressLabel;

  const _Achievement({
    required this.title,
    required this.description,
    required this.emoji,
    required this.level,
    required this.claimed,
    required this.progress,
    this.progressLabel,
  });
}

// ─────────────────────────────────────────────────────────
//  HISTORY VIEW
// ─────────────────────────────────────────────────────────

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Calendar state
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;
  final int _today = DateTime.now().day;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ─── ACHIEVEMENTS DATA ───
  List<_Achievement> _buildAchievements(HabitProvider provider) {
    final streak = provider.currentStreak;
    final finished = provider.totalHabitsFinished;
    final habitsCount = provider.habits.length;

    return [
      _Achievement(
        title: 'Wildfire',
        description: 'Reach a 30 day streak',
        emoji: '🔥',
        level: 4,
        claimed: streak >= 30,
        progress: (streak / 30).clamp(0.0, 1.0),
        progressLabel: '$streak / 30',
      ),
      _Achievement(
        title: 'Early Bird',
        description: 'Complete 5 morning habits',
        emoji: '🌅',
        level: 1,
        claimed: false,
        progress: (finished / 5).clamp(0.0, 1.0),
        progressLabel: '$finished / 5',
      ),
      _Achievement(
        title: 'Scholar',
        description: 'Log habits for 10 days total',
        emoji: '📚',
        level: 2,
        claimed: finished >= 10,
        progress: (finished / 10).clamp(0.0, 1.0),
        progressLabel: '$finished / 10',
      ),
      _Achievement(
        title: 'Legendary',
        description: 'Unlock 50 habits',
        emoji: '🏆',
        level: 5,
        claimed: false,
        progress: (habitsCount / 50).clamp(0.0, 1.0),
        progressLabel: '$habitsCount / 50',
      ),
    ];
  }

  // ─────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF58CC02)),
      );
    }

    return Column(
      children: [
        // ─── TAB BAR ───
        _buildTabBar(),
        // ─── TAB CONTENT ───
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _CalendarTab(
                provider: provider,
                currentMonth: _currentMonth,
                currentYear: _currentYear,
                today: _today,
                onPrevMonth: () => setState(() {
                  if (_currentMonth > 1) {
                    _currentMonth--;
                  } else {
                    _currentMonth = 12;
                    _currentYear--;
                  }
                }),
                onNextMonth: () => setState(() {
                  if (_currentMonth < 12) {
                    _currentMonth++;
                  } else {
                    _currentMonth = 1;
                    _currentYear++;
                  }
                }),
              ),
              _AllHabitsTab(provider: provider),
              _AchievementsTab(achievements: _buildAchievements(provider)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: TabBar(
        controller: _tabController,
        labelColor: const Color(0xFF58A700),
        unselectedLabelColor: Colors.grey.shade500,
        indicatorColor: const Color(0xFF58CC02),
        indicatorWeight: 3,
        labelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
        unselectedLabelStyle: GoogleFonts.nunito(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        tabs: const [
          Tab(text: 'Calendar'),
          Tab(text: 'All Habits'),
          Tab(text: 'Achievements'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  TAB 1: CALENDAR
// ─────────────────────────────────────────────────────────

class _CalendarTab extends StatefulWidget {
  final HabitProvider provider;
  final int currentMonth;
  final int currentYear;
  final int today;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  const _CalendarTab({
    required this.provider,
    required this.currentMonth,
    required this.currentYear,
    required this.today,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  @override
  State<_CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<_CalendarTab> {
  DateTime? _selectedPickerDate;

  List<Habit> _habitsCompletedOn(DateTime date) {
    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    return widget.provider.habits.where((h) {
      return widget.provider.allCompletedLogs.any(
        (log) => log.habitId == h.id && log.date == dateStr && log.isCompleted,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final streak = widget.provider.currentStreak;
    final finished = widget.provider.totalHabitsFinished;

    final now = DateTime.now();
    final pickedHabits = _selectedPickerDate != null
        ? _habitsCompletedOn(_selectedPickerDate!)
        : <Habit>[];

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // ─── STATS ROW ───
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _StatCard(
                    topLabel: 'CURRENT STREAK',
                    value: '$streak',
                    unit: 'Days',
                    icon: Icons.local_fire_department_rounded,
                    iconColor: const Color.fromARGB(255, 226, 52, 9),
                    faded: false,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    topLabel: 'HABITS FINISHED',
                    value: '$finished',
                    unit: 'Habits',
                    icon: Icons.check_circle_rounded,
                    iconColor: const Color.fromARGB(255, 71, 119, 33),
                    faded: true,
                  ),
                ),
              ],
            ),
          ).animate().fade(duration: 350.ms).slideY(begin: 0.1),
          const SizedBox(height: 16),

          // ─── EMBEDDED CUPERTINO CALENDAR ───
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: CupertinoCalendar(
              minimumDateTime: DateTime(now.year - 2),
              maximumDateTime: now,
              initialDateTime: _selectedPickerDate ?? now,
              currentDateTime: now,
              mode: CupertinoCalendarMode.date,
              onDateTimeChanged: (date) {
                setState(() => _selectedPickerDate = date);
              },
            ),
          ).animate().fade(duration: 350.ms, delay: 50.ms).slideY(begin: 0.1),
          const SizedBox(height: 16),

          // ─── PICKED DATE COMPLETED HABITS ───
          if (_selectedPickerDate != null) ...[
            Text(
              pickedHabits.isEmpty
                  ? 'No habits completed on ${DateFormat('MMM d').format(_selectedPickerDate!)}'
                  : 'Completed on ${DateFormat('MMM d, yyyy').format(_selectedPickerDate!)}',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ).animate().fade(duration: 250.ms),
            const SizedBox(height: 12),
            ...pickedHabits.map(
              (h) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ChicletHabitCard(habit: h, provider: widget.provider, isFuture: true),
              ),
            ),
            const SizedBox(height: 12),
          ],

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  TAB 2: ALL HABITS
// ─────────────────────────────────────────────────────────

class _AllHabitsTab extends StatelessWidget {
  final HabitProvider provider;

  const _AllHabitsTab({required this.provider});

  // Assign a time-of-day category based on index (demo)
  static const _categories = ['ANYTIME', 'MORNING', 'AFTERNOON', 'EVENING'];

  @override
  Widget build(BuildContext context) {
    final habits = provider.habits;

    if (habits.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.checklist_rounded,
              size: 64,
              color: Color(0xFFCCCCCC),
            ),
            const SizedBox(height: 16),
            Text(
              'No habits yet',
              style: GoogleFonts.fredoka(
                fontSize: 18,
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add habits from the Today tab',
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      );
    }

    // Group habits into categories (simple round-robin demo)
    final grouped = <String, List<Habit>>{};
    for (final cat in _categories) {
      grouped[cat] = [];
    }
    for (int i = 0; i < habits.length; i++) {
      final cat = _categories[i % _categories.length];
      grouped[cat]!.add(habits[i]);
    }

    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              ...grouped.entries.expand((e) {
                if (e.value.isEmpty) return <Widget>[];
                return [
                  // Category label
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 4),
                    child: Text(
                      e.key,
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.grey.shade500,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ...e.value.map(
                    (habit) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ChicletHabitCard(habit: habit, provider: provider, isFuture: true),
                    ),
                  ),
                ];
              }),
              const SizedBox(height: 100),
            ],
          ).animate().fade(duration: 350.ms).slideY(begin: 0.05),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────
//  TAB 3: ACHIEVEMENTS
// ─────────────────────────────────────────────────────────

class _AchievementsTab extends StatelessWidget {
  final List<_Achievement> achievements;

  const _AchievementsTab({required this.achievements});

  @override
  Widget build(BuildContext context) {
    final total = achievements.length;
    final done = achievements.where((a) => a.claimed).length;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Hero progress card
          _AchievementHeroCard(
            done: done,
            total: total,
          ).animate().fade(duration: 350.ms).slideY(begin: 0.1),
          const SizedBox(height: 20),
          // Achievement grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, i) => _AchievementCard(a: achievements[i])
                .animate(delay: (50 * i).ms)
                .fade(duration: 350.ms)
                .slideY(begin: 0.1),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────
//  SHARED WIDGETS
// ─────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String topLabel;
  final String value;
  final String? unit;
  final IconData icon;
  final Color iconColor;
  final bool faded;

  const _StatCard({
    required this.topLabel,
    required this.value,
    this.unit,
    required this.icon,
    required this.iconColor,
    required this.faded,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Faded background icon
          if (faded)
            Positioned(
              bottom: -8,
              right: -8,
              child: Icon(icon, size: 72, color: Colors.grey.shade100),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                topLabel,
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(icon, color: iconColor, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    value,
                    style: GoogleFonts.fredoka(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
              if (unit != null) ...[
                Text(
                  unit!,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── CALENDAR CARD ───






// ─── ACHIEVEMENT HERO CARD ───

class _AchievementHeroCard extends StatelessWidget {
  final int done;
  final int total;
  const _AchievementHeroCard({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? done / total : 0.0;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F5E9), Color(0xFFDCEDC8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Achievements',
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'TOTAL PROGRESS',
                  style: GoogleFonts.nunito(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.grey.shade600,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '$done / $total',
                  style: GoogleFonts.fredoka(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF58A700),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: pct,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFF58CC02)),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  pct >= 0.5
                      ? "You're halfway to becoming a Master Habit Binder!"
                      : 'Keep going — every habit counts!',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              color: Color(0xFF58CC02),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.star_rounded, color: Colors.white, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── ACHIEVEMENT CARD ───

class _AchievementCard extends StatelessWidget {
  final _Achievement a;
  const _AchievementCard({required this.a});

  @override
  Widget build(BuildContext context) {
    final locked = !a.claimed && (a.progress == 0.0);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Badge area
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(
                    color: locked
                        ? Colors.grey.shade200
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: locked
                        ? Icon(
                            Icons.lock_outline,
                            size: 40,
                            color: Colors.grey.shade400,
                          )
                        : Text(a.emoji, style: const TextStyle(fontSize: 44)),
                  ),
                ),
                // Level badge
                if (!locked)
                  Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'LVL ${a.level}',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              a.title,
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: locked ? Colors.grey.shade400 : Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),

            Text(
              a.description,
              style: GoogleFonts.nunito(
                fontSize: 10,
                color: Colors.grey.shade500,
                height: 1.3,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            // Progress bar (locked) or button (claimed/in-progress)
            if (locked && a.progressLabel != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: a.progress,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF42A5F5)),
                  minHeight: 5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                a.progressLabel!,
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
            ] else if (a.claimed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF58CC02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 0,
                  ),
                  child: Text(
                    'CLAIMED',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            else
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 0,
                      ),
                      child: Text(
                        'IN PROGRESS',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    if (a.progressLabel != null) ...[
                      const SizedBox(height: 3),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: a.progress,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF42A5F5),
                          ),
                          minHeight: 4,
                        ),
                      ),
                      Text(
                        a.progressLabel!,
                        style: GoogleFonts.nunito(
                          fontSize: 9,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
