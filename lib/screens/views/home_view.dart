import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/app_provider.dart';
import '../../models/habit.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // Generate 5 days: 2 days ago, yesterday, today, tomorrow, day after
  List<DateTime> _generateSurroundingDays() {
    final today = DateTime.now();
    return [
      today.subtract(const Duration(days: 2)),
      today.subtract(const Duration(days: 1)),
      today,
      today.add(const Duration(days: 1)),
      today.add(const Duration(days: 2)),
    ];
  }

  void _showHabitDialog(BuildContext context, {Habit? habit}) {
    final titleController = TextEditingController(text: habit?.title ?? '');
    final subtitleController = TextEditingController(text: habit?.subtitle ?? '');
    
    int selectedBgColorHex = habit?.bgColorHex ?? 0xFF558B2F;
    int selectedFgColorHex = habit?.colorHex ?? 0xFF7CB342;

    final palettes = [
      {'bg': 0xFF558B2F, 'fg': 0xFF7CB342}, // Green
      {'bg': 0xFF1976D2, 'fg': 0xFF42A5F5}, // Blue
      {'bg': 0xFFF57F17, 'fg': 0xFFFFCA28}, // Yellow
      {'bg': 0xFFD32F2F, 'fg': 0xFFEF5350}, // Red
      {'bg': 0xFF7B1FA2, 'fg': 0xFFAB47BC}, // Purple
      {'bg': 0xFFE65100, 'fg': 0xFFFFA726}, // Orange
      {'bg': 0xFF455A64, 'fg': 0xFF78909C}, // Blue Grey
    ];
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(habit == null ? 'Create New Habit' : 'Edit Habit', style: const TextStyle(fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Habit Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: subtitleController,
                      decoration: const InputDecoration(
                        labelText: 'Subtitle / Target',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Card Color', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: palettes.map((p) {
                        final isSelected = p['bg'] == selectedBgColorHex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBgColorHex = p['bg']!;
                              selectedFgColorHex = p['fg']!;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Color(p['fg']!),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF2D3142) : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                if (habit != null)
                  TextButton(
                    onPressed: () {
                      context.read<AppProvider>().deleteHabit(habit.id!);
                      Navigator.pop(context);
                    },
                    child: const Text('DELETE', style: TextStyle(color: Colors.redAccent)),
                  ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('CANCEL', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      if (habit == null) {
                        final newHabit = Habit(
                          title: titleController.text,
                          subtitle: subtitleController.text.isEmpty ? 'Daily' : subtitleController.text,
                          iconCodePoint: Icons.star_rounded.codePoint,
                          colorHex: selectedFgColorHex,
                          bgColorHex: selectedBgColorHex,
                          createdAt: DateFormat('yyyy-MM-dd').format(DateTime.now()),
                        );
                        context.read<AppProvider>().addHabit(newHabit);
                      } else {
                        habit.title = titleController.text;
                        habit.subtitle = subtitleController.text.isEmpty ? 'Daily' : subtitleController.text;
                        habit.colorHex = selectedFgColorHex;
                        habit.bgColorHex = selectedBgColorHex;
                        context.read<AppProvider>().updateHabit(habit);
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CB342),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('SAVE', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
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

    final days = _generateSurroundingDays();

    // Separate habits into focus vs normal
    final focusHabits = provider.habits.where((h) => h.isCurrentFocus).toList();
    final normalHabits = provider.habits.where((h) => !h.isCurrentFocus).toList();

    return SingleChildScrollView(
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

            // ─── Date Selector ───
            _buildDateSelector(provider, days),
            const SizedBox(height: 32),

            // ─── Morning Routine Section ───
            _buildSectionTitle(),
            const SizedBox(height: 20),

            // ─── Current Focus (Hero Card) ───
            if (focusHabits.isNotEmpty) ...[
              _buildChicletHabitCard(context, focusHabits.first, provider, isHero: true),
              const SizedBox(height: 16),
            ] else ...[
               const Center(child: Text("No Focus Habit Set", style: TextStyle(color: Colors.grey))),
               const SizedBox(height: 16),
            ],

            // ─── Habit Cards ───
            ...normalHabits.map((habit) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _buildChicletHabitCard(context, habit, provider, isHero: false),
              );
            }),
            
            const SizedBox(height: 8),

            // ─── Create a New Habit Button ───
            _buildCreateHabitButton(context),
            const SizedBox(height: 24),

            // ─── Quote of the Day ───
            _buildQuoteCard(),
            const SizedBox(height: 100), // bottom nav space
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int streak) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Today',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3142),
          ),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFC8E6C9),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 4),
                  Text(
                    '$streak',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF558B2F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF2D3142),
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector(AppProvider provider, List<DateTime> days) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: days.map((date) {
          final isSelected = date.year == provider.selectedDate.year &&
                             date.month == provider.selectedDate.month &&
                             date.day == provider.selectedDate.day;
          
          final dayName = DateFormat('E').format(date).toUpperCase(); // e.g. MON
          
          return _buildDayItem(
            dayName,
            date.day,
            isSelected,
            () => provider.setSelectedDate(date),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDayItem(String day, int date, bool isSelected, VoidCallback onTap) {
    if (isSelected) {
      return Column(
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7CB342),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          ChicletAnimatedButton(
            onPressed: onTap,
            width: 44,
            height: 44,
            buttonHeight: 3,
            borderRadius: 22,
            backgroundColor: const Color(0xFF7CB342),
            buttonColor: const Color(0xFF558B2F),
            child: Text(
              '$date',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: Text(
              '$date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        const Text('☀️', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        const Text(
          'MORNING ROUTINE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3142),
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Divider(
            color: Colors.grey.shade300,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildChicletHabitCard(BuildContext context, Habit habit, AppProvider provider, {bool isHero = false}) {
    final isChecked = provider.isHabitCompletedOnSelectedDate(habit.id!);
    final fgColor = Color(habit.colorHex);
    final bgColor = Color(habit.bgColorHex);
    
    return ChicletAnimatedButton(
      onPressed: () {
        provider.toggleHabitCompletion(habit.id!);
      },
      width: double.infinity,
      height: 110,
      buttonHeight: 5,
      borderRadius: 24,
      backgroundColor: fgColor,
      buttonColor: bgColor,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        isHero ? 'CURRENT FOCUS' : 'HABIT',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habit.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habit.subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => _showHabitDialog(context, habit: habit),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.25),
                border: Border.all(
                  color: Colors.white,
                  width: 2.5,
                ),
              ),
              child: isChecked
                  ? Icon(Icons.check_rounded, size: 26, color: fgColor)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateHabitButton(BuildContext context) {
    return ChicletOutlinedAnimatedButton(
      onPressed: () => _showHabitDialog(context),
      width: double.infinity,
      height: 56,
      buttonHeight: 4,
      borderRadius: 18,
      borderColor: Colors.grey.shade300,
      buttonColor: Colors.grey.shade300,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF2D3142),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF7CB342),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Text(
            'CREATE A NEW HABIT',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3142),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUOTE OF THE DAY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '"We are what we repeatedly do. Excellence, then, is not an act, but a habit."',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Color(0xFF2D3142),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
