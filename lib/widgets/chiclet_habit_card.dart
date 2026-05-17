import 'package:flutter/material.dart';
import 'package:chiclet/chiclet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import '../../models/habit.dart';
import '../../providers/habit_provider.dart';
import '../screens/views/habit_create_screen.dart';

/// Full-width chiclet-style habit card with trailing goal controls.
class ChicletHabitCard extends StatelessWidget {
  final Habit habit;
  final HabitProvider provider;
  final bool isHero;
  final bool isFuture;

  const ChicletHabitCard({
    super.key,
    required this.habit,
    required this.provider,
    this.isHero = false,
    this.isFuture = false,
  });

  @override
  Widget build(BuildContext context) {
    final isChecked = provider.isHabitCompletedOnSelectedDate(habit.id);
    final fgColor = Color(habit.colorHex);
    final bgColor = Color(habit.bgColorHex);
    final canInteract = !isFuture;

    return ChicletAnimatedButton(
      onPressed: canInteract
          ? (habit.goalType == 'off' || habit.goalType == 'negative' || habit.goalType == 'one_time')
              ? () { provider.toggleHabitCompletion(habit.id); }
              : () {}
          : null,
      width: double.infinity,
      height: 110,
      buttonHeight: 5,
      borderRadius: 12,
      backgroundColor: fgColor,
      buttonColor: bgColor,
      padding: EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 16, top: 16, bottom: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isHero ? 'CURRENT FOCUS' : 'HABIT',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withValues(alpha: 0.8),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habit.title,
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    habit.subtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 2,
            color: Colors.black.withValues(alpha: 0.1),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 24),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => HabitCreateScreen(habit: habit)),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FaIcon(FontAwesomeIcons.penToSquare, color: Colors.white, size: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _TrailingGoalControls(
                  habit: habit,
                  provider: provider,
                  isChecked: isChecked,
                  fgColor: fgColor,
                  isFuture: isFuture,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrailingGoalControls extends StatefulWidget {
  final Habit habit;
  final HabitProvider provider;
  final bool isChecked;
  final Color fgColor;
  final bool isFuture;

  const _TrailingGoalControls({
    required this.habit,
    required this.provider,
    required this.isChecked,
    required this.fgColor,
    required this.isFuture,
  });

  @override
  State<_TrailingGoalControls> createState() => _TrailingGoalControlsState();
}

class _TrailingGoalControlsState extends State<_TrailingGoalControls> {
  void _showTimerPopup(BuildContext context, Habit habit, HabitProvider provider, int progressSeconds) {
    showDialog<void>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: _TimerPopupCard(
          habit: habit,
          provider: provider,
          initialSecondsElapsed: progressSeconds,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;
    final provider = widget.provider;
    final isChecked = widget.isChecked;
    final fgColor = widget.fgColor;
    final isFuture = widget.isFuture;

    if (habit.goalType == 'off' || habit.goalType == 'negative' || habit.goalType == 'one_time') {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? Colors.white : Colors.white.withValues(alpha: isFuture ? 0.10 : 0.25),
          border: Border.all(color: Colors.white.withValues(alpha: isFuture ? 0.3 : 1.0), width: 2.5),
        ),
        child: isChecked ? Center(child: FaIcon(FontAwesomeIcons.check, size: 20, color: fgColor)) : null,
      );
    }

    if (habit.goalType == 'duration') {
      final progressSeconds = provider.getHabitProgressOnSelectedDate(habit.id);
      final totalSeconds = habit.goalValue * 60;
      final remainingSeconds = totalSeconds - progressSeconds;
      final isCompleted = progressSeconds >= totalSeconds;

      String display;
      if (isCompleted) {
        display = 'Done';
      } else if (progressSeconds == 0) {
        display = '${habit.goalValue} min';
      } else {
        final int m = remainingSeconds ~/ 60;
        final int s = remainingSeconds % 60;
        display = '$m:${s.toString().padLeft(2, '0')} left';
      }

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(display, style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          
          if (!isCompleted)
            GestureDetector(
              onTap: isFuture ? null : () => _showTimerPopup(context, habit, provider, progressSeconds),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: isFuture ? 0.08 : 0.15), shape: BoxShape.circle),
                child: Center(child: FaIcon(FontAwesomeIcons.play, color: Colors.white.withValues(alpha: isFuture ? 0.3 : 1.0), size: 14)),
              ),
            ),
            
          if (isCompleted) ...[
            const SizedBox(width: 8),
            _buildCheckCircle(provider, isChecked, fgColor, isFuture),
          ],
        ],
      );
    }

    if (habit.goalType == 'repeat') {
      final progress = provider.getHabitProgressOnSelectedDate(habit.id);
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$progress / ${habit.goalValue}', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: isFuture ? null : () {
              int newProgress = progress + 1;
              if (newProgress > habit.goalValue) newProgress = habit.goalValue;
              provider.updateHabitProgress(habit.id, newProgress, newProgress >= habit.goalValue);
            },
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: isFuture ? 0.08 : 0.15), shape: BoxShape.circle),
              child: Center(child: FaIcon(FontAwesomeIcons.plus, color: Colors.white.withValues(alpha: isFuture ? 0.3 : 1.0), size: 14)),
            ),
          ),
          const SizedBox(width: 8),
          _buildCheckCircle(provider, isChecked, fgColor, isFuture),
        ],
      );
    }

    return const SizedBox();
  }

  Widget _buildCheckCircle(HabitProvider provider, bool isChecked, Color fgColor, bool isFuture) {
    return GestureDetector(
      onTap: isFuture ? null : () {
        final newCompleted = !isChecked;
        final int progressValue = newCompleted 
            ? (widget.habit.goalType == 'duration' ? widget.habit.goalValue * 60 : widget.habit.goalValue)
            : 0;
        provider.updateHabitProgress(widget.habit.id, progressValue, newCompleted);
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked ? Colors.white : Colors.white.withValues(alpha: isFuture ? 0.10 : 0.25),
          border: Border.all(color: Colors.white.withValues(alpha: isFuture ? 0.3 : 1.0), width: 2.5),
        ),
        child: isChecked ? Center(child: FaIcon(FontAwesomeIcons.check, size: 16, color: fgColor)) : null,
      ),
    );
  }
}

class _TimerPopupCard extends StatefulWidget {
  final Habit habit;
  final HabitProvider provider;
  final int initialSecondsElapsed;

  const _TimerPopupCard({
    required this.habit,
    required this.provider,
    required this.initialSecondsElapsed,
  });

  @override
  State<_TimerPopupCard> createState() => _TimerPopupCardState();
}

class _TimerPopupCardState extends State<_TimerPopupCard> {
  final CountDownController _controller = CountDownController();
  bool _isPaused = false;
  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = (widget.habit.goalValue * 60) - widget.initialSecondsElapsed;
    if (_remainingSeconds < 0) _remainingSeconds = 0;
  }

  @override
  void dispose() {
    final int elapsed = (widget.habit.goalValue * 60) - _remainingSeconds;
    final bool isComplete = elapsed >= (widget.habit.goalValue * 60);
    widget.provider.updateHabitProgress(widget.habit.id, elapsed, isComplete);
    super.dispose();
  }

  void _toggleTimer() {
    if (_isPaused) {
      _controller.resume();
    } else {
      _controller.pause();
    }
    setState(() => _isPaused = !_isPaused);
  }

  @override
  Widget build(BuildContext context) {
    final fgColor = Color(widget.habit.colorHex);
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(32),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.habit.title,
            style: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            'Daily Goal: ${widget.habit.goalValue} min',
            style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 32),
          
          CircularCountDownTimer(
            controller: _controller,
            width: 180,
            height: 180,
            duration: widget.habit.goalValue * 60,
            initialDuration: widget.initialSecondsElapsed,
            isReverse: true,
            fillColor: fgColor,
            ringColor: fgColor.withValues(alpha: 0.1),
            strokeWidth: 16,
            strokeCap: StrokeCap.round,
            textStyle: GoogleFonts.nunito(fontSize: 48, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            autoStart: true,
            onChange: (String time) {
              final parts = time.split(':');
              if (parts.length == 2) {
                _remainingSeconds = int.parse(parts[0]) * 60 + int.parse(parts[1]);
              } else if (parts.length == 3) {
                _remainingSeconds = int.parse(parts[0]) * 3600 + int.parse(parts[1]) * 60 + int.parse(parts[2]);
              }
            },
            onComplete: () {
              _remainingSeconds = 0;
              Navigator.pop(context);
            },
          ),
          
          const SizedBox(height: 32),
          
          InkWell(
            onTap: _toggleTimer,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _isPaused ? fgColor : Colors.orange.shade400,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: (_isPaused ? fgColor : Colors.orange.shade400).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: Center(
                child: FaIcon(
                  _isPaused ? FontAwesomeIcons.play : FontAwesomeIcons.pause,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isPaused ? 'RESUME' : 'PAUSE',
            style: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

