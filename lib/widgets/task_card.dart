import 'package:flutter/material.dart';

class TaskCard extends StatefulWidget {
  final String title;
  final String subtitle;

  const TaskCard({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
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
                    widget.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isChecked ? Colors.grey.shade400 : const Color(0xFF2D3142),
                      decoration: _isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
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
                color: _isChecked ? const Color(0xFF62B694) : Colors.transparent,
                border: Border.all(
                  color: _isChecked ? const Color(0xFF62B694) : Colors.grey.shade300, 
                  width: 1.5
                ),
              ),
              child: _isChecked 
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
