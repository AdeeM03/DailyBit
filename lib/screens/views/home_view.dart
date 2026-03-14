import 'package:flutter/material.dart';
import '../../widgets/task_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // Profile Picture
                  Stack(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFE0B2), // Pastel orange
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.orange, size: 30),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade700,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Greeting Text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello, Masykur!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3142),
                        ),
                      ),
                      Text(
                        "Let's crush it today.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Streak Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.local_fire_department, color: Colors.orange, size: 20),
                    SizedBox(width: 4),
                    Text(
                      '14 Days',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Category Section
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Text(
            'Category',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B3B36),
            ),
          ),
        ),
        
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              _buildCategoryItem('Gym', Icons.bed, const Color(0xFFFFF7DB), const Color(0xFFFFD54F)),
              const SizedBox(width: 16),
              _buildCategoryItem('School', Icons.chair_alt, const Color(0xFFFFF0E6), const Color(0xFFFFAB91)),
              const SizedBox(width: 16),
              _buildCategoryItem('Work', Icons.work_outline, const Color(0xFFE3F2FD), const Color(0xFF90CAF9)),
              const SizedBox(width: 16),
              _buildAddCategoryItem(),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Today Tasks Section
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

  Widget _buildCategoryItem(String title, IconData icon, Color bgColor, Color borderColor) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
            border: Border.all(color: borderColor, width: 2),
          ),
          child: Icon(icon, color: borderColor.withValues(alpha: 0.8), size: 30),
        ),
        const SizedBox(height: 8),
        if (title.isNotEmpty)
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1B3B36)),
          ),
      ],
    );
  }

  Widget _buildAddCategoryItem() {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400, width: 2, style: BorderStyle.none),
          ),
          child: CustomPaint(
            painter: DashedCirclePainter(color: Colors.grey.shade400),
            child: Icon(Icons.add, color: Colors.grey.shade500, size: 30),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Add Category',
          style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF1B3B36)),
        ),
      ],
    );
  }

}

class DashedCirclePainter extends CustomPainter {
  final Color color;

  DashedCirclePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const dashWidth = 8.0;
    const dashSpace = 6.0;
    double perimeter = size.width * 3.14159;
    int count = (perimeter / (dashWidth + dashSpace)).floor();

    for (int i = 0; i < count; i++) {
      double startAngle = (i * (dashWidth + dashSpace) / perimeter) * 2 * 3.14159;
      double sweepAngle = (dashWidth / perimeter) * 2 * 3.14159;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
