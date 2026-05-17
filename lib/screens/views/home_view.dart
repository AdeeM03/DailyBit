import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/habit_provider.dart';
import '../../models/habit.dart';
import '../../widgets/home_widgets.dart';
import '../../widgets/chiclet_habit_card.dart';
import 'habit_type_selector_sheet.dart';
import 'habit_create_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late PageController _weekController;
  String _selectedTimeFilter = 'anytime';

  List<DateTime> _weekDays(int weekOffset) {
    final today = DateTime.now();
    final sunday = today.subtract(Duration(days: today.weekday % 7));
    final weekStart = sunday.add(Duration(days: weekOffset * 7));
    return List.generate(7, (i) => DateTime(weekStart.year, weekStart.month, weekStart.day + i));
  }

  @override
  void initState() {
    super.initState();
    _weekController = PageController(initialPage: 1000);
  }

  @override
  void dispose() {
    _weekController.dispose();
    super.dispose();
  }

  String _headerTitle(DateTime selected) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final selDate = DateTime(selected.year, selected.month, selected.day);
    final diff = selDate.difference(todayDate).inDays;
    if (diff == 0) return 'TODAY';
    if (diff == -1) return 'YESTERDAY';
    if (diff == 1) return 'TOMORROW';
    return DateFormat('MMM d').format(selected).toUpperCase();
  }

  String _headerSubtitle(DateTime selected) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final selDate = DateTime(selected.year, selected.month, selected.day);
    final diff = selDate.difference(todayDate).inDays;
    if (diff == 0) return DateFormat('MMM d').format(selected);
    return DateFormat('EEEE').format(selected);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HabitProvider>();
    
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF58CC02)));
    }

    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final selectedDate = provider.selectedDate;
    final selDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final isFuture = selDate.isAfter(todayDate);

    // Filter habits based on selected date
    final selectedDateFormatted = DateFormat('MMM d, yyyy').format(provider.selectedDate);
    final selectedDateNorm = DateTime(provider.selectedDate.year, provider.selectedDate.month, provider.selectedDate.day);
    final visibleHabits = provider.habits.where((h) {
      if (h.goalType == 'one_time') {
        return h.timeOfDay == selectedDateFormatted;
      }
      if (h.createdAt.isNotEmpty) {
        try {
          final created = DateTime.parse(h.createdAt);
          final createdNorm = DateTime(created.year, created.month, created.day);
          if (selectedDateNorm.isBefore(createdNorm)) return false;
        } catch (_) {}
      }
      return true;
    }).toList();

    final focusHabits = visibleHabits.where((h) => h.isCurrentFocus).toList();
    final normalHabits = visibleHabits.where((h) => !h.isCurrentFocus).toList();

    final habitSections = _buildHabitSections(normalHabits, provider, isFuture);

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            _buildHeader(provider),
            const SizedBox(height: 16),
            WeekSelector(
              controller: _weekController,
              provider: provider,
              weekDaysBuilder: _weekDays,
            ),
            const SizedBox(height: 24),
            TimeFilterRow(
              selectedFilter: _selectedTimeFilter,
              onFilterChanged: (value) => setState(() => _selectedTimeFilter = value),
            ),
            const SizedBox(height: 24),
            if (focusHabits.isNotEmpty) ...[
              ChicletHabitCard(habit: focusHabits.first, provider: provider, isHero: true, isFuture: isFuture),
              const SizedBox(height: 16),
            ],
            ...habitSections,
            const SizedBox(height: 8),
            _buildCreateHabitButton(context),
            const SizedBox(height: 24),
          ].animate(interval: 50.ms).fade(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOutQuad),
        ),
      ),
    );
  }

  List<Widget> _buildHabitSections(List<Habit> normalHabits, HabitProvider provider, bool isFuture) {
    List<Widget> buildSection(String title, FaIconData icon, Color color, List<Habit> habits) {
      if (habits.isEmpty) return [];
      return [
        HabitSectionTitle(title: title, icon: icon, color: color),
        ...habits.map((habit) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: ChicletHabitCard(habit: habit, provider: provider, isFuture: isFuture),
        )),
      ];
    }

    final List<Widget> sections = [];
    if (_selectedTimeFilter == 'anytime') {
      final morning = normalHabits.where((h) => h.timeOfDay.toLowerCase() == 'morning').toList();
      final afternoon = normalHabits.where((h) => h.timeOfDay.toLowerCase() == 'afternoon').toList();
      final evening = normalHabits.where((h) => h.timeOfDay.toLowerCase() == 'evening').toList();
      final anytime = normalHabits.where((h) => !['morning', 'afternoon', 'evening'].contains(h.timeOfDay.toLowerCase())).toList();

      sections.addAll([
        ...buildSection('ANYTIME ROUTINE', FontAwesomeIcons.clock, Colors.blue, anytime),
        ...buildSection('MORNING ROUTINE', FontAwesomeIcons.cloudSun, Colors.orange, morning),
        ...buildSection('AFTERNOON ROUTINE', FontAwesomeIcons.sun, Colors.amber, afternoon),
        ...buildSection('EVENING ROUTINE', FontAwesomeIcons.moon, Colors.indigo, evening),
      ]);
    } else {
      final filtered = normalHabits.where((h) => h.timeOfDay.toLowerCase() == _selectedTimeFilter).toList();
      FaIconData icon = FontAwesomeIcons.clock;
      Color color = Colors.blue;
      if (_selectedTimeFilter == 'morning') { icon = FontAwesomeIcons.cloudSun; color = Colors.orange; }
      else if (_selectedTimeFilter == 'afternoon') { icon = FontAwesomeIcons.sun; color = Colors.amber; }
      else if (_selectedTimeFilter == 'evening') { icon = FontAwesomeIcons.moon; color = Colors.indigo; }
      sections.addAll(buildSection('${_selectedTimeFilter.toUpperCase()} ROUTINE', icon, color, filtered));
    }
    return sections;
  }

  Widget _buildHeader(HabitProvider provider) {
    final selected = provider.selectedDate;
    final title = _headerTitle(selected);
    final subtitle = _headerSubtitle(selected);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w800, color: const Color(0xFF2D3142))),
            Text(subtitle, style: GoogleFonts.nunito(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
          ],
        ),
        Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  provider.isStreakActiveToday
                      ? 'assets/icons/fire-streak.svg'
                      : 'assets/icons/streak_fire_inactive.svg',
                  width: 28, height: 28,
                ),
                const SizedBox(width: 4),
                Text(
                  '${provider.currentStreak}',
                  style: GoogleFonts.fredoka(
                    fontSize: 20, fontWeight: FontWeight.w800,
                    color: provider.isStreakActiveToday ? const Color(0xFFFF9600) : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) => HabitTypeSelectorSheet(
                    onProceed: (type) {
                      Navigator.push(context, MaterialPageRoute<void>(builder: (_) => HabitCreateScreen(presetType: type)));
                    },
                  ),
                );
              },
              child: Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF1877F2),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF1877F2).withValues(alpha: 0.35), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: const Center(child: FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 18)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCreateHabitButton(BuildContext context) {
    return ChicletOutlinedAnimatedButton(
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          backgroundColor: Colors.transparent,
          isScrollControlled: true,
          builder: (context) => HabitTypeSelectorSheet(
            onProceed: (type) {
              Navigator.push(context, MaterialPageRoute<void>(builder: (_) => HabitCreateScreen(presetType: type)));
            },
          ),
        );
      },
      width: double.infinity,
      height: 56,
      buttonHeight: 4,
      borderRadius: 12,
      borderColor: Colors.grey.shade300,
      buttonColor: Colors.grey.shade300,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28, height: 28,
            decoration: const BoxDecoration(color: Color(0xFF58CC02), shape: BoxShape.circle),
            child: const Center(child: FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 14)),
          ),
          const SizedBox(width: 12),
          Text(
            'CREATE A NEW HABIT',
            style: GoogleFonts.fredoka(
              fontSize: 14, fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
