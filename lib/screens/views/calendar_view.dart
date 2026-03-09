import 'package:flutter/material.dart';

class CalendarView extends StatelessWidget {
  const CalendarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: const Text(
            'August, 13',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
            ),
          ),
        ),

        // Day Selector Section
        SizedBox(
          height: 100,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              _buildDayItem('11', 'Mon', false),
              const SizedBox(width: 12),
              _buildDayItem('12', 'Tue', false),
              const SizedBox(width: 12),
              _buildDayItem('13', 'Wed', true),
              const SizedBox(width: 12),
              _buildDayItem('14', 'Thu', false),
              const SizedBox(width: 12),
              _buildDayItem('15', 'Fri', false),
            ],
          ),
        ),
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
                      const Text(
                        'Today Tasks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      Text(
                        'See all',
                        style: TextStyle(
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
                      _buildTaskCard('Mop the floor', 'Last Cleaning: Fri, Aug 09 2024'),
                      const SizedBox(height: 12),
                      _buildTaskCard('Organize toiletries', 'Last Cleaning: Fri, Aug 09 2024'),
                      const SizedBox(height: 12),
                      _buildTaskCard('Replace old towels', 'Last Cleaning: Fri, Aug 09 2024'),
                      const SizedBox(height: 12),
                      _buildTaskCard('Restock toilet paper', 'Last Cleaning: Fri, Aug 09 2024'),
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

  Widget _buildDayItem(String day, String weekday, bool isActive) {
    return Container(
      width: 65,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF62B694) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: isActive ? [
          BoxShadow(
            color: const Color(0xFF62B694).withOpacity(0.4),
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
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.white : const Color(0xFF2D3142),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            weekday,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? Colors.white.withOpacity(0.9) : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFBFB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3142),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text('Every week', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(width: 16),
                    Icon(Icons.bar_chart, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text('Complexity: 5', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ],
                )
              ],
            ),
          ),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
