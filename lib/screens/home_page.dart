import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'views/home_view.dart';
import 'views/diary_view.dart';
import 'views/history_view.dart';
import 'views/me_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeView(),
    const DiaryView(),
    const HistoryView(),
    const MeView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F5),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  index: 0,
                  icon: FontAwesomeIcons.circleCheck,
                  activeIcon: FontAwesomeIcons.solidCircleCheck,
                  label: 'TODAY',
                  useBadge: true,
                ),
                _buildNavItem(
                  index: 1,
                  icon: FontAwesomeIcons.book,
                  activeIcon: FontAwesomeIcons.bookOpen,
                  label: 'DIARY',
                  useBadge: true,
                ),
                _buildNavItem(
                  index: 2,
                  icon: FontAwesomeIcons.clockRotateLeft,
                  activeIcon: FontAwesomeIcons.clockRotateLeft,
                  label: 'HISTORY',
                  useBadge: true,
                ),
                _buildNavItem(
                  index: 3,
                  icon: FontAwesomeIcons.user,
                  activeIcon: FontAwesomeIcons.solidUser,
                  label: 'ME',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required dynamic icon,
    required dynamic activeIcon,
    required String label,
    bool useBadge = false,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? const Color(0xFF7CB342) : Colors.grey.shade400;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (useBadge && isSelected)
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF7CB342),
                  shape: BoxShape.circle,
                ),
                child: FaIcon(activeIcon, color: Colors.white, size: 24),
              )
            else
              FaIcon(
                isSelected ? activeIcon : icon,
                color: color,
                size: 24,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.fredoka(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
