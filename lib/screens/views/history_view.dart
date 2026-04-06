import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../providers/app_provider.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  // Current month for calendar
  int _currentMonth = DateTime.now().month;
  int _currentYear = DateTime.now().year;
  final int _today = DateTime.now().day;

  // Weekly intensity data (0.0 - 1.0) - kept dummy for now as it's complex to aggregate
  final List<double> _weeklyIntensity = [0.6, 0.75, 0.9, 0.7, 0.5, 0.3, 0.4];
  final List<String> _dayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();

    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF7CB342)));
    }

    final completedDays = provider.getCompletedDaysInMonth(_currentYear, _currentMonth);

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

            // ─── Stats Cards ───
            _buildStatsRow(provider.currentStreak, provider.totalHabitsFinished),
            const SizedBox(height: 12),
            _buildCompletionCard(provider.completionRate),
            const SizedBox(height: 28),

            // ─── Calendar Section ───
            _buildCalendarHeader(),
            const SizedBox(height: 20),
            _buildCalendarGrid(completedDays),
            const SizedBox(height: 32),

            // ─── Weekly Intensity ───
            _buildWeeklyIntensitySection(),
            const SizedBox(height: 28),

            // ─── Motivation Card ───
            _buildMotivationCard(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────
  //  HEADER: Back arrow + title + streak
  // ────────────────────────────────────────
  Widget _buildHeader(int streak) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {},
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Color(0xFF2D3142), size: 20),
            ),
            const SizedBox(width: 8),
            const Text(
              'Habit History',
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFC8E6C9), width: 1),
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
      ],
    );
  }

  // ────────────────────────────────────────
  //  STATS CARDS ROW
  // ────────────────────────────────────────
  Widget _buildStatsRow(int streak, int finished) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.local_fire_department_rounded,
            iconColor: const Color(0xFF7CB342),
            iconBgColor: const Color(0xFFE8F5E9),
            label: 'ACTIVE',
            value: '$streak',
            subtitle: 'Current Streak',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.check_circle_outline_rounded,
            iconColor: const Color(0xFF7CB342),
            iconBgColor: const Color(0xFFE8F5E9),
            value: '$finished',
            subtitle: 'Habits Finished',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    String? label,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
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
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              if (label != null) ...[
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade500,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2D3142),
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────
  //  COMPLETION RATE CARD
  // ────────────────────────────────────────
  Widget _buildCompletionCard(double rate) {
    int percentage = (rate * 100).toInt();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.bar_chart_rounded,
                color: Color(0xFF42A5F5), size: 20),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF2D3142),
                  height: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Completion Rate',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────
  //  CALENDAR HEADER (Month + arrows)
  // ────────────────────────────────────────
  Widget _buildCalendarHeader() {
    final months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${months[_currentMonth]} $_currentYear',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Consistent growth this month',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _buildArrowButton(Icons.chevron_left_rounded, () {
                  setState(() {
                    if (_currentMonth > 1) {
                      _currentMonth--;
                    } else {
                      _currentMonth = 12;
                      _currentYear--;
                    }
                  });
                }),
                const SizedBox(width: 8),
                _buildArrowButton(Icons.chevron_right_rounded, () {
                  setState(() {
                    if (_currentMonth < 12) {
                      _currentMonth++;
                    } else {
                      _currentMonth = 1;
                      _currentYear++;
                    }
                  });
                }),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200, width: 1.5),
        ),
        child: Icon(icon, color: Colors.grey.shade600, size: 20),
      ),
    );
  }

  // ────────────────────────────────────────
  //  CALENDAR GRID
  // ────────────────────────────────────────
  Widget _buildCalendarGrid(Set<int> completedDays) {
    // Day headers
    final dayHeaders = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];

    // Calculate first day of month and days in month
    final firstDay = DateTime(_currentYear, _currentMonth, 1);
    final daysInMonth = DateTime(_currentYear, _currentMonth + 1, 0).day;
    // Monday = 1, so offset = weekday - 1
    final startWeekday = firstDay.weekday - 1;

    // Previous month days for fill
    final prevMonthDays = DateTime(_currentYear, _currentMonth, 0).day;

    List<Widget> dayWidgets = [];

    // Previous month trailing days
    for (int i = startWeekday - 1; i >= 0; i--) {
      dayWidgets.add(_buildCalendarDay(
        prevMonthDays - i,
        isCurrentMonth: false,
        isCompleted: false,
        isToday: false,
      ));
    }

    // Current month days
    final now = DateTime.now();
    for (int day = 1; day <= daysInMonth; day++) {
      final isToday = _currentYear == now.year && _currentMonth == now.month && day == _today;
      dayWidgets.add(_buildCalendarDay(
        day,
        isCurrentMonth: true,
        isCompleted: completedDays.contains(day),
        isToday: isToday,
      ));
    }

    // Next month fill
    final remaining = 7 - (dayWidgets.length % 7);
    if (remaining < 7) {
      for (int i = 1; i <= remaining; i++) {
        dayWidgets.add(_buildCalendarDay(
          i,
          isCurrentMonth: false,
          isCompleted: false,
          isToday: false,
        ));
      }
    }

    return Container(
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
        children: [
          // Day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayHeaders.map((d) => SizedBox(
              width: 36,
              child: Text(
                d,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade500,
                  letterSpacing: 0.5,
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 12),
          // Calendar rows
          ...List.generate(
            (dayWidgets.length / 7).ceil(),
            (rowIndex) {
              final start = rowIndex * 7;
              final end = math.min(start + 7, dayWidgets.length);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: dayWidgets.sublist(start, end),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarDay(
    int day, {
    required bool isCurrentMonth,
    required bool isCompleted,
    required bool isToday,
  }) {
    Color bgColor;
    Color textColor;

    if (!isCurrentMonth) {
      bgColor = Colors.transparent;
      textColor = Colors.grey.shade300;
    } else if (isToday) {
      bgColor = const Color(0xFF558B2F);
      textColor = Colors.white;
    } else if (isCompleted) {
      bgColor = const Color(0xFF7CB342);
      textColor = Colors.white;
    } else {
      bgColor = Colors.transparent;
      textColor = Colors.grey.shade600;
    }

    return SizedBox(
      width: 36,
      height: 36,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: isToday
              ? Border.all(color: const Color(0xFF33691E), width: 2.5)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                (isCompleted || isToday) ? FontWeight.w800 : FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }

  // ────────────────────────────────────────
  //  WEEKLY INTENSITY
  // ────────────────────────────────────────
  Widget _buildWeeklyIntensitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Intensity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
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
            children: [
              // Bar chart
              SizedBox(
                height: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (index) {
                    return _buildIntensityBar(
                      index,
                      _weeklyIntensity[index],
                      isHighlighted: index == 2, // Wednesday
                    );
                  }),
                ),
              ),
              const SizedBox(height: 12),
              // Day labels
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (index) {
                  final isHighlighted = index == 2;
                  return SizedBox(
                    width: 36,
                    child: Text(
                      _dayLabels[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: isHighlighted
                            ? const Color(0xFF7CB342)
                            : Colors.grey.shade500,
                        letterSpacing: 0.3,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntensityBar(int index, double intensity,
      {bool isHighlighted = false}) {
    final maxHeight = 110.0;
    final barHeight = maxHeight * intensity;
    final restHeight = maxHeight - barHeight;

    return SizedBox(
      width: 24,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Inactive top portion
          if (restHeight > 0)
            Container(
              width: 24,
              height: restHeight,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
            ),
          // Active bottom portion
          Container(
            width: 24,
            height: barHeight,
            decoration: BoxDecoration(
              color: isHighlighted
                  ? const Color(0xFF7CB342)
                  : const Color(0xFFA5D6A7),
              borderRadius: BorderRadius.vertical(
                top: restHeight > 0
                    ? Radius.zero
                    : const Radius.circular(12),
                bottom: const Radius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────
  //  MOTIVATION CARD (green gradient)
  // ────────────────────────────────────────
  Widget _buildMotivationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF7CB342),
            Color(0xFF558B2F),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF7CB342).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative elements
          Positioned(
            top: -10,
            right: -10,
            child: Text(
              '✨',
              style: TextStyle(
                fontSize: 40,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 20,
            child: Text(
              '⭐',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your morning\nroutine is paying\noff.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Completing habits before 9 AM has increased your focus by 40% this month.',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              ChicletOutlinedAnimatedButton(
                onPressed: () {},
                height: 44,
                buttonHeight: 3,
                borderRadius: 12,
                borderColor: Colors.white,
                buttonColor: Colors.white.withValues(alpha: 0.3),
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                borderWidth: 1.5,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'READ ANALYSIS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
