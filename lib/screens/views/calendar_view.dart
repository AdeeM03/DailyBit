import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../widgets/task_card.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  String _selectedDay = '13'; // Default selected day based on mockup

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Text(
            'August, 13',
            style: GoogleFonts.fredoka(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3142),
            ),
          ),
        ).animate().fade().slideX(begin: -0.2),

        // Day Selector Section
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              _buildDayItem('11', 'Mon'),
              const SizedBox(width: 12),
              _buildDayItem('12', 'Tue'),
              const SizedBox(width: 12),
              _buildDayItem('13', 'Wed'),
              const SizedBox(width: 12),
              _buildDayItem('14', 'Thu'),
              const SizedBox(width: 12),
              _buildDayItem('15', 'Fri'),
              const SizedBox(width: 12),
              _buildDayItem('16', 'Sat'),
              const SizedBox(width: 12),
              _buildDayItem('17', 'Sun'),
            ],
          ),
        ).animate().fade().slideX(begin: 0.2),
        const SizedBox(height: 10),

        // Today Tasks Section (Reused from Home)
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today Tasks',
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      Text(
                        'See all',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.teal.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    children: [
                      const TaskCard(title: 'Mop the floor', subtitle: 'Last Cleaning: Fri, Aug 09 2024'),
                      const SizedBox(height: 12),
                      const TaskCard(title: 'Organize toiletries', subtitle: 'Last Cleaning: Fri, Aug 09 2024'),
                      const SizedBox(height: 12),
                      const TaskCard(title: 'Replace old towels', subtitle: 'Last Cleaning: Fri, Aug 09 2024'),
                      const SizedBox(height: 12),
                      const TaskCard(title: 'Restock toilet paper', subtitle: 'Last Cleaning: Fri, Aug 09 2024'),
                      const SizedBox(height: 80), // Fab space
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDayItem(String day, String weekday) {
    final bool isActive = _selectedDay == day;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDay = day;
        });
      },
      child: Container(
        width: 65,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF62B694) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive ? [
            BoxShadow(
              color: const Color(0xFF62B694).withValues(alpha: 0.4),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ] : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: GoogleFonts.fredoka(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : const Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              weekday,
              style: GoogleFonts.nunito(
                fontSize: 14,
                color: isActive ? Colors.white.withValues(alpha: 0.9) : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
