import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chiclet/chiclet.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/habit_provider.dart';
import '../../models/habit.dart';
import '../../utils/app_toast.dart';
import 'habit_type_selector_sheet.dart'; // for HabitType

class HabitCreateScreen extends StatefulWidget {
  final Habit? habit;
  final HabitType? presetType;

  const HabitCreateScreen({super.key, this.habit, this.presetType});

  @override
  State<HabitCreateScreen> createState() => _HabitCreateScreenState();
}

class _HabitCreateScreenState extends State<HabitCreateScreen> {
  late TextEditingController _titleController;
  
  int _selectedBgColorHex = 0xFF58A700;
  int _selectedFgColorHex = 0xFF58CC02;
  String _timeOfDay = 'Anytime';
  String _goalType = 'off';
  int _goalValue = 0;
  String _repeatFrequency = 'everyday'; // everyday / everyweek / everymonth / everyyear / custom

  final List<Map<String, int>> palettes = [
    {'bg': 0xFF58A700, 'fg': 0xFF58CC02}, // Green
    {'bg': 0xFF1976D2, 'fg': 0xFF42A5F5}, // Blue
    {'bg': 0xFFF57F17, 'fg': 0xFFFFCA28}, // Yellow
    {'bg': 0xFFD32F2F, 'fg': 0xFFEF5350}, // Red
    {'bg': 0xFF7B1FA2, 'fg': 0xFFAB47BC}, // Purple
    {'bg': 0xFFE65100, 'fg': 0xFFFFA726}, // Orange
    {'bg': 0xFF455A64, 'fg': 0xFF78909C}, // Blue Grey
  ];

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    final initialTitle = widget.habit?.title ?? '';
    _selectedBgColorHex = widget.habit?.bgColorHex ?? _selectedBgColorHex;
    _selectedFgColorHex = widget.habit?.colorHex ?? _selectedFgColorHex;
    _timeOfDay = widget.habit?.timeOfDay ?? _timeOfDay;
    _goalType = widget.habit?.goalType ?? _goalType;
    _goalValue = widget.habit?.goalValue ?? _goalValue;

    if (widget.habit != null) {
      if (_goalType == 'one_time') {
        try {
          _selectedDate = DateFormat('MMM d, yyyy').parse(_timeOfDay);
        } catch (_) {
          _selectedDate = DateTime.now();
        }
      }
    }

    if (widget.habit == null && widget.presetType != null) {
      if (widget.presetType == HabitType.negative) {
        _selectedBgColorHex = 0xFFD32F2F;
        _selectedFgColorHex = 0xFFEF5350;
        _goalType = 'negative';
      } else if (widget.presetType == HabitType.oneTime) {
        _selectedBgColorHex = 0xFF1976D2;
        _selectedFgColorHex = 0xFF42A5F5;
        _goalType = 'one_time';
        _timeOfDay = DateFormat('MMM d, yyyy').format(_selectedDate);
      }
    }

    _titleController = TextEditingController(text: initialTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveHabit() {
    if (_titleController.text.trim().isEmpty) return;

    final provider = context.read<HabitProvider>();
    if (widget.habit == null) {
      final newHabit = Habit(
        id: DateTime.now().millisecondsSinceEpoch,
        title: _titleController.text.trim(),
        subtitle: widget.presetType == HabitType.negative ? 'You Can Do It! Fight For It!' : (widget.presetType == HabitType.oneTime ? 'One-time event' : 'Daily'),
        colorHex: _selectedFgColorHex,
        bgColorHex: _selectedBgColorHex,
        timeOfDay: _timeOfDay,
        goalType: _goalType,
        goalValue: _goalValue,
        createdAt: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );
      provider.addHabit(newHabit);
    } else {
      widget.habit!.title = _titleController.text.trim();
      widget.habit!.colorHex = _selectedFgColorHex;
      widget.habit!.bgColorHex = _selectedBgColorHex;
      widget.habit!.timeOfDay = _timeOfDay;
      widget.habit!.goalType = _goalType;
      widget.habit!.goalValue = _goalValue;
      provider.updateHabit(widget.habit!);
    }
    if (mounted) AppToast.success(context, 'Habit berhasil disimpan!');
    Navigator.pop(context);
  }

  void _confirmDeleteHabit() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete Habit', style: GoogleFonts.fredoka(fontWeight: FontWeight.bold)),
        content: Text('Are you sure you want to delete "${widget.habit!.title}"?', style: GoogleFonts.nunito()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: GoogleFonts.nunito())),
          TextButton(
            onPressed: () {
              context.read<HabitProvider>().deleteHabit(widget.habit!.id);
              Navigator.pop(ctx);
              Navigator.pop(context);
              AppToast.success(context, 'Habit deleted!');
            },
            child: Text('Delete', style: GoogleFonts.nunito(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showColorPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: palettes.map((p) {
              final isSelected = p['bg'] == _selectedBgColorHex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedBgColorHex = p['bg']!;
                    _selectedFgColorHex = p['fg']!;
                  });
                  Navigator.pop(context);
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Color(p['fg']!),
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showGoalPicker() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text('Daily goal', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold)),
              ListTile(
                title: const Text('Off', textAlign: TextAlign.center),
                onTap: () {
                  setState(() {
                    _goalType = 'off';
                    _goalValue = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Duration', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context);
                  _showDurationPicker();
                },
              ),
              ListTile(
                title: const Text('Repeat', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context);
                  _showGoalTimesPicker();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDurationPicker() {
    int tempMins = _goalType == 'duration' ? _goalValue : 15;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Duration (Minutes)', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 150,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: tempMins - 1),
                        itemExtent: 40.0,
                        onSelectedItemChanged: (int index) {
                          setModalState(() => tempMins = index + 1);
                        },
                        children: List<Widget>.generate(120, (int index) {
                          return Center(
                            child: Text(
                              '${index + 1} min',
                              style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ChicletAnimatedButton(
                      onPressed: () {
                        setState(() {
                          _goalType = 'duration';
                          _goalValue = tempMins;
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: const Color(0xFF6B9B85),
                      buttonColor: const Color(0xFF4CA020),
                      width: double.infinity,
                      child: Text('SAVE', style: GoogleFonts.fredoka(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  void _showRepeatPicker() {
    final frequencies = [
      {'value': 'everyday', 'label': 'Every Day', 'icon': Icons.today},
      {'value': 'everyweek', 'label': 'Every Week', 'icon': Icons.view_week},
      {'value': 'everymonth', 'label': 'Every Month', 'icon': Icons.calendar_month},
      {'value': 'everyyear', 'label': 'Every Year', 'icon': Icons.event},
    ];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              Text('Habit Days', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...frequencies.map((f) {
                final isSelected = _repeatFrequency == f['value'];
                return ListTile(
                  leading: Icon(f['icon'] as IconData, color: isSelected ? const Color(0xFF58CC02) : Colors.grey),
                  title: Text(f['label'] as String, style: GoogleFonts.nunito(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFF58CC02) : null,
                  )),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: Color(0xFF58CC02)) : null,
                  onTap: () {
                    setState(() {
                      _repeatFrequency = f['value'] as String;
                    });
                    Navigator.pop(context);
                  },
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showGoalTimesPicker() {
    int tempReps = _goalType == 'repeat' ? _goalValue : 2;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Goal (Times)', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 150,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(initialItem: tempReps - 1),
                        itemExtent: 40.0,
                        onSelectedItemChanged: (int index) {
                          setModalState(() => tempReps = index + 1);
                        },
                        children: List<Widget>.generate(50, (int index) {
                          return Center(
                            child: Text(
                              '${index + 1} times',
                              style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ChicletAnimatedButton(
                      onPressed: () {
                        setState(() {
                          _goalType = 'repeat';
                          _goalValue = tempReps;
                        });
                        Navigator.pop(context);
                      },
                      backgroundColor: const Color(0xFF6B9B85),
                      buttonColor: const Color(0xFF4CA020),
                      width: double.infinity,
                      child: Text('SAVE', style: GoogleFonts.fredoka(color: Colors.white, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  Gradient? _getGradientForFilter(String value) {
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

  Widget _buildTimeButton(String title, IconData icon) {
    final isSelected = _timeOfDay == title;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _timeOfDay = title),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? null : Theme.of(context).colorScheme.surface,
            gradient: isSelected ? _getGradientForFilter(title) : null,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? null : Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : Colors.grey.shade600),
              const SizedBox(width: 6),
              Text(
                title,
                style: GoogleFonts.fredoka(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker() {
    DateTime tempDate = _selectedDate;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Choose the date', style: GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF2D3142))),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 150,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: tempDate,
                        onDateTimeChanged: (DateTime newDate) {
                          tempDate = newDate;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ChicletAnimatedButton(
                            onPressed: () => Navigator.pop(context),
                            backgroundColor: Colors.grey.shade600,
                            buttonColor: Colors.grey.shade800,
                            height: 50,
                            borderRadius: 12,
                            child: Text('CANCEL', style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ChicletAnimatedButton(
                            onPressed: () {
                              setState(() {
                                _selectedDate = tempDate;
                                _timeOfDay = DateFormat('MMM d, yyyy').format(_selectedDate);
                              });
                              Navigator.pop(context);
                            },
                            backgroundColor: const Color(0xFF1877F2),
                            buttonColor: const Color(0xFF1565C0),
                            height: 50,
                            borderRadius: 12,
                            child: Text('SAVE', style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String goalText = 'Off';
    if (_goalType == 'duration') goalText = '$_goalValue min';
    if (_goalType == 'repeat') goalText = '$_goalValue times';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Input
            TextField(
              controller: _titleController,
              style: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: 'Habit name',
                hintStyle: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                border: InputBorder.none,
                suffixIcon: const Icon(Icons.edit, color: Colors.grey),
              ),
            ),
            Text(
              _goalType == 'negative' ? 'Negative habit' : (_goalType == 'one_time' ? 'One-time habit' : 'Regular habit'),
              style: GoogleFonts.nunito(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // Color Selector
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: InkWell(
                onTap: _showColorPicker,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Color', style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                    Row(
                      children: [
                        Container(width: 20, height: 20, decoration: BoxDecoration(color: Color(_selectedFgColorHex), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            if (_goalType != 'negative' && _goalType != 'one_time') ...[
              // Repeat Days (Static for now)
              Text('REPEAT', style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: InkWell(
                  onTap: _showRepeatPicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Habit days', style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                      Row(
                        children: [
                          Text(
                            {'everyday': 'Every Day', 'everyweek': 'Every Week', 'everymonth': 'Every Month', 'everyyear': 'Every Year', 'custom': 'Custom'}[_repeatFrequency] ?? 'Every Day',
                            style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade600),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Do it at
              Text('DO IT AT', style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTimeButton('Anytime', Icons.access_time),
                  _buildTimeButton('Morning', Icons.wb_sunny_outlined),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTimeButton('Afternoon', Icons.wb_twilight),
                  _buildTimeButton('Evening', Icons.nights_stay_outlined),
                ],
              ),
              const SizedBox(height: 32),

              // Daily Goal
              Text('DAILY GOAL', style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: InkWell(
                  onTap: _showGoalPicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Goal', style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                      Row(
                        children: [
                          Text(goalText, style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade600)),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],

            if (_goalType == 'one_time') ...[
              // When section
              Text('WHEN', style: GoogleFonts.fredoka(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: InkWell(
                  onTap: _showDatePicker,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Do it at', style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                      Row(
                        children: [
                          Text(_timeOfDay, style: GoogleFonts.nunito(fontSize: 14, color: Colors.grey.shade600)),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],

            // Save Button
            ChicletAnimatedButton(
              onPressed: _saveHabit,
              backgroundColor: const Color(0xFF1877F2), // Using link blue for SAVE per screenshot
              buttonColor: const Color(0xFF1565C0),
              width: double.infinity,
              height: 56,
              borderRadius: 12,
              child: Text('SAVE', style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            if (widget.habit != null) ...[
              const SizedBox(height: 16),
              ChicletAnimatedButton(
                onPressed: () => _confirmDeleteHabit(),
                backgroundColor: const Color(0xFFD32F2F),
                buttonColor: const Color(0xFFB71C1C),
                width: double.infinity,
                height: 56,
                borderRadius: 12,
                child: Text('DELETE HABIT', style: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
