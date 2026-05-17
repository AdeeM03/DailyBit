import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HabitCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final FaIconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final bool isChecked;
  final VoidCallback onToggle;

  const HabitCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconBgColor = const Color(0xFFE8F5E9),
    this.iconColor = const Color(0xFF58CC02),
    this.isChecked = false,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
            // Icon circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: FaIcon(icon, color: iconColor, size: 20)),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isChecked
                          ? Colors.grey.shade400
                          : const Color(0xFF2D3142),
                      decoration:
                          isChecked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox circle
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked ? const Color(0xFF58CC02) : Colors.transparent,
                border: Border.all(
                  color: isChecked
                      ? const Color(0xFF58CC02)
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: isChecked
                  ? const Center(child: FaIcon(FontAwesomeIcons.check, size: 14, color: Colors.white))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
