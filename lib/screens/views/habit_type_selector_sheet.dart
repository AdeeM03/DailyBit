import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:chiclet/chiclet.dart';

enum HabitType { regular, negative, oneTime }

class HabitTypeSelectorSheet extends StatefulWidget {
  final void Function(HabitType) onProceed;

  const HabitTypeSelectorSheet({super.key, required this.onProceed});

  @override
  State<HabitTypeSelectorSheet> createState() => _HabitTypeSelectorSheetState();
}

class _HabitTypeSelectorSheetState extends State<HabitTypeSelectorSheet> {
  HabitType _selectedType = HabitType.regular;

  // Colors based on DESIGN.md
  final Color _regularColor = const Color(0xFF5DB329); // Accent
  final Color _negativeColor = const Color(0xFFFF5252); // Error
  final Color _oneTimeColor = const Color(0xFF1877F2); // Link

  Widget _buildTypeCard({
    required HabitType type,
    required String title,
    required FaIconData icon,
    required Color activeColor,
  }) {
    final isSelected = _selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 100,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? activeColor : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? activeColor : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: activeColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade500,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String descTitle = '';
    String descText = '';
    Color currentColor = _regularColor;
    Color chicletBottomColor = const Color(0xFF4CA020);

    switch (_selectedType) {
      case HabitType.regular:
        descTitle = 'REGULAR';
        descText = 'Related to your daily routine. Check it in a regular and repeated way. E.g. Do yoga three times a week';
        currentColor = _regularColor;
        chicletBottomColor = const Color(0xFF4CA020);
        break;
      case HabitType.negative:
        descTitle = 'NEGATIVE';
        descText = 'Start each day as complete. Only uncheck it when you fail. E.g. quit smoking & alcohol';
        currentColor = _negativeColor;
        chicletBottomColor = const Color(0xFFD32F2F);
        break;
      case HabitType.oneTime:
        descTitle = 'ONE-TIME TODO';
        descText = 'Remind you of important one-time events on a specific date you set. E.g. Take a medical test on Friday';
        currentColor = _oneTimeColor;
        chicletBottomColor = const Color(0xFF1565C0);
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F9F7), // Background Default from DESIGN.md
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create a new habit',
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 24),

            // ─── 3 Option Cards ───
            Row(
              children: [
                _buildTypeCard(
                  type: HabitType.regular,
                  title: 'REGULAR',
                  icon: FontAwesomeIcons.rotate,
                  activeColor: _regularColor,
                ),
                _buildTypeCard(
                  type: HabitType.negative,
                  title: 'NEGATIVE',
                  icon: FontAwesomeIcons.ban,
                  activeColor: _negativeColor,
                ),
                _buildTypeCard(
                  type: HabitType.oneTime,
                  title: 'ONE-TIME',
                  icon: FontAwesomeIcons.calendarCheck,
                  activeColor: _oneTimeColor,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ─── Description Box ───
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    descTitle,
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: currentColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    descText,
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ─── Create Button ───
            ChicletAnimatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onProceed(_selectedType);
              },
              backgroundColor: currentColor,
              buttonColor: chicletBottomColor,
              buttonHeight: 5,
              borderRadius: 12,
              width: double.infinity,
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FaIcon(FontAwesomeIcons.plus, color: Colors.white, size: 16),
                  const SizedBox(width: 12),
                  Text(
                    'CREATE YOUR OWN',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
