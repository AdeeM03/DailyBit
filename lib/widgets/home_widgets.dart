import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../providers/habit_provider.dart';

/// Swipeable week day selector with chiclet-style active button.
class WeekSelector extends StatelessWidget {
  final PageController controller;
  final HabitProvider provider;
  final List<DateTime> Function(int weekOffset) weekDaysBuilder;

  const WeekSelector({
    super.key,
    required this.controller,
    required this.provider,
    required this.weekDaysBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 70,
        child: PageView.builder(
          controller: controller,
          onPageChanged: (page) {
            final offset = page - 1000;
            final days = weekDaysBuilder(offset);
            final today = DateTime.now();
            final todayDate = DateTime(today.year, today.month, today.day);
            final containsToday = days.any((d) =>
                d.year == todayDate.year && d.month == todayDate.month && d.day == todayDate.day);
            if (containsToday) {
              provider.setSelectedDate(todayDate);
            }
          },
          itemBuilder: (context, page) {
            final offset = page - 1000;
            final days = weekDaysBuilder(offset);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: days.map((date) {
                final isSelected = date.year == provider.selectedDate.year &&
                                   date.month == provider.selectedDate.month &&
                                   date.day == provider.selectedDate.day;
                final dayName = DateFormat('E').format(date).toUpperCase();
                return _DayItem(
                  day: dayName,
                  date: date.day,
                  isSelected: isSelected,
                  onTap: () => provider.setSelectedDate(date),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

class _DayItem extends StatelessWidget {
  final String day;
  final int date;
  final bool isSelected;
  final VoidCallback onTap;

  const _DayItem({
    required this.day,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isSelected) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF58CC02),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          ChicletAnimatedButton(
            onPressed: onTap,
            width: 44,
            height: 44,
            buttonHeight: 3,
            borderRadius: 12,
            backgroundColor: const Color(0xFF58CC02),
            buttonColor: const Color(0xFF58A700),
            child: Text(
              '$date',
              style: GoogleFonts.fredoka(
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            day,
            style: GoogleFonts.nunito(
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
              style: GoogleFonts.fredoka(
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
}

/// Time-of-day filter chips (ALL, MORNING, AFTERNOON, EVENING).
class TimeFilterRow extends StatelessWidget {
  final String selectedFilter;
  final void Function(String) onFilterChanged;

  const TimeFilterRow({
    super.key,
    required this.selectedFilter,
    required this.onFilterChanged,
  });

  Gradient _getGradient(String value) {
    switch (value.toLowerCase()) {
      case 'morning':
        return const LinearGradient(
          colors: [Color(0xFFFF9A9E), Color(0xFFA1C4FD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'afternoon':
        return const LinearGradient(
          colors: [Color(0xFF00C6FF), Color(0xFF0072FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'evening':
        return const LinearGradient(
          colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF1CB0F6), Color(0xFF1CB0F6)],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      clipBehavior: Clip.none,
      child: Row(
        children: [
          _chip(context, 'ALL', 'anytime', null),
          const SizedBox(width: 8),
          _chip(context, 'MORNING', 'morning', FontAwesomeIcons.cloudSun),
          const SizedBox(width: 8),
          _chip(context, 'AFTERNOON', 'afternoon', FontAwesomeIcons.sun),
          const SizedBox(width: 8),
          _chip(context, 'EVENING', 'evening', FontAwesomeIcons.moon),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, String value, FaIconData? icon) {
    final isSelected = selectedFilter == value;
    return GestureDetector(
      onTap: () => onFilterChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? null : Theme.of(context).colorScheme.surface,
          gradient: isSelected ? _getGradient(value) : null,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? null : Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              FaIcon(icon, color: isSelected ? Colors.white : Colors.grey.shade600, size: 14),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: GoogleFonts.fredoka(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Section title with icon + divider.
class HabitSectionTitle extends StatelessWidget {
  final String title;
  final FaIconData icon;
  final Color color;

  const HabitSectionTitle({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Row(
        children: [
          FaIcon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: GoogleFonts.fredoka(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.onSurface,
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
      ),
    );
  }
}
