import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';
import '../../widgets/habit_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedDayIndex = 3; // THU is selected by default (index 3)

  // Hardcoded habit states
  final Map<int, bool> _habitStates = {
    0: true, // "My first habit" — checked
    1: false, // "Hydrate"
    2: false, // "Mindfulness"
  };

  // Days data
  final List<Map<String, dynamic>> _days = [
    {'day': 'MON', 'date': 12},
    {'day': 'TUE', 'date': 13},
    {'day': 'WED', 'date': 14},
    {'day': 'THU', 'date': 15},
    {'day': 'FRI', 'date': 16},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // ─── Header ───
            _buildHeader(),
            const SizedBox(height: 24),

            // ─── Date Selector ───
            _buildDateSelector(),
            const SizedBox(height: 32),

            // ─── Morning Routine Section ───
            _buildSectionTitle(),
            const SizedBox(height: 20),

            // ─── Current Focus (Hero Card) ───
            _buildHeroCard(),
            const SizedBox(height: 16),

            // ─── Habit Cards ───
            HabitCard(
              title: 'Hydrate',
              subtitle: '500ml of water',
              icon: Icons.water_drop_rounded,
              iconBgColor: const Color(0xFFE3F2FD),
              iconColor: const Color(0xFF42A5F5),
              isChecked: _habitStates[1]!,
              onToggle: () => setState(() => _habitStates[1] = !_habitStates[1]!),
            ),
            const SizedBox(height: 12),
            HabitCard(
              title: 'Mindfulness',
              subtitle: 'Deep breathing exercise',
              icon: Icons.self_improvement_rounded,
              iconBgColor: const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF66BB6A),
              isChecked: _habitStates[2]!,
              onToggle: () => setState(() => _habitStates[2] = !_habitStates[2]!),
            ),
            const SizedBox(height: 20),

            // ─── Create a New Habit Button ───
            _buildCreateHabitButton(),
            const SizedBox(height: 24),

            // ─── Quote of the Day ───
            _buildQuoteCard(),
            const SizedBox(height: 100), // bottom nav space
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────
  //  HEADER: "Today" + streak badge + gear
  // ────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // "Today" text
        const Text(
          'Today',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3142),
          ),
        ),
        Row(
          children: [
            // Streak badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFFC8E6C9),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🔥', style: TextStyle(fontSize: 16)),
                  SizedBox(width: 4),
                  Text(
                    '7',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF558B2F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Settings gear
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.settings_outlined,
                color: Color(0xFF2D3142),
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ────────────────────────────────────────
  //  DATE SELECTOR with Chiclet buttons
  // ────────────────────────────────────────
  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_days.length, (index) {
          final isSelected = index == _selectedDayIndex;
          return _buildDayItem(
            _days[index]['day'],
            _days[index]['date'],
            isSelected,
            () => setState(() => _selectedDayIndex = index),
          );
        }),
      ),
    );
  }

  Widget _buildDayItem(String day, int date, bool isSelected, VoidCallback onTap) {
    if (isSelected) {
      return Column(
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF7CB342),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          ChicletAnimatedButton(
            onPressed: onTap,
            width: 44,
            height: 44,
            buttonHeight: 3,
            borderRadius: 22,
            backgroundColor: const Color(0xFF7CB342),
            buttonColor: const Color(0xFF558B2F),
            child: Text(
              '$date',
              style: const TextStyle(
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
        children: [
          Text(
            day,
            style: TextStyle(
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
              style: TextStyle(
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

  // ────────────────────────────────────────
  //  SECTION TITLE: ☀️ MORNING ROUTINE
  // ────────────────────────────────────────
  Widget _buildSectionTitle() {
    return Row(
      children: [
        const Text('☀️', style: TextStyle(fontSize: 18)),
        const SizedBox(width: 8),
        const Text(
          'MORNING ROUTINE',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2D3142),
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
    );
  }

  // ────────────────────────────────────────
  //  HERO CARD: Current Focus habit (green)
  // ────────────────────────────────────────
  Widget _buildHeroCard() {
    final isChecked = _habitStates[0]!;
    return ChicletAnimatedButton(
      onPressed: () {
        setState(() => _habitStates[0] = !_habitStates[0]!);
      },
      width: double.infinity,
      height: 110,
      buttonHeight: 5,
      borderRadius: 24,
      backgroundColor: const Color(0xFF7CB342),
      buttonColor: const Color(0xFF558B2F),
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CURRENT FOCUS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'My first habit',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Every morning • 15 mins',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
            // Checkbox
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isChecked
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.25),
                border: Border.all(
                  color: Colors.white,
                  width: 2.5,
                ),
              ),
              child: isChecked
                  ? const Icon(Icons.check_rounded,
                      size: 26, color: Color(0xFF7CB342))
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────
  //  CREATE A NEW HABIT BUTTON (Chiclet)
  // ────────────────────────────────────────
  Widget _buildCreateHabitButton() {
    return ChicletOutlinedAnimatedButton(
      onPressed: () {},
      width: double.infinity,
      height: 56,
      buttonHeight: 4,
      borderRadius: 18,
      borderColor: Colors.grey.shade300,
      buttonColor: Colors.grey.shade300,
      backgroundColor: Colors.white,
      foregroundColor: const Color(0xFF2D3142),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFF7CB342),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          const Text(
            'CREATE A NEW HABIT',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: Color(0xFF2D3142),
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  // ────────────────────────────────────────
  //  QUOTE OF THE DAY
  // ────────────────────────────────────────
  Widget _buildQuoteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F0),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'QUOTE OF THE DAY',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '"We are what we repeatedly do. Excellence, then, is not an act, but a habit."',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              fontStyle: FontStyle.italic,
              color: Color(0xFF2D3142),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
