import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chiclet/chiclet.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/diary_provider.dart';
import '../../providers/habit_provider.dart';
import '../../utils/app_toast.dart';

import '../sign_in_screen.dart';
import '../../services/auth_service.dart';
import '../../services/sync_service.dart';
import '../../services/notification_service.dart';

class MeView extends StatefulWidget {
  const MeView({super.key});

  @override
  State<MeView> createState() => _MeViewState();
}

class _MeViewState extends State<MeView> {
  String? _localPhotoBase64;
  String? _localDisplayName;
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadLocalProfile();
  }

  Future<void> _loadLocalProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _localPhotoBase64 = prefs.getString('photoBase64');
      _localDisplayName = prefs.getString('displayName');
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _showEditProfileDialog(AuthService authService) async {
    final nameController = TextEditingController(
      text: _localDisplayName ?? authService.currentUser?.displayName ?? '',
    );
    String? tempBase64 = _localPhotoBase64;

    await showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text('Edit Profile', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
                    if (pickedFile != null) {
                      final bytes = await pickedFile.readAsBytes();
                      setDialogState(() {
                        tempBase64 = base64Encode(bytes);
                      });
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                      image: tempBase64 != null
                          ? DecorationImage(image: MemoryImage(base64Decode(tempBase64!)), fit: BoxFit.cover)
                          : null,
                    ),
                    child: tempBase64 == null
                        ? const Icon(Icons.camera_alt, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Display Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newName = nameController.text.trim();
                  final prefs = await SharedPreferences.getInstance();
                  
                  if (newName.isNotEmpty) {
                    await prefs.setString('displayName', newName);
                    if (authService.isAuthenticated) {
                      await authService.currentUser?.updateDisplayName(newName);
                    }
                  }
                  
                  if (tempBase64 != null) {
                    await prefs.setString('photoBase64', tempBase64!);
                    // We sync it via Firestore in SyncService.
                  }
                  
                  setState(() {
                    _localDisplayName = newName.isNotEmpty ? newName : _localDisplayName;
                    _localPhotoBase64 = tempBase64;
                  });
                  
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          );
        });
      },
    );
  }

  void _showClearDataDialog() {
    bool deleteTasks = false;
    bool deleteNotes = false;

    showDialog<void>(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Text(
              'Clear Data',
              style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select the data you want to permanently delete from your device.',
                  style: GoogleFonts.nunito(color: Colors.grey.shade600, fontSize: 14),
                ),
                const SizedBox(height: 16),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Delete Tasks', style: GoogleFonts.nunito()),
                  value: deleteTasks,
                  activeColor: const Color(0xFF6B9B85),
                  onChanged: (val) {
                    setDialogState(() {
                      deleteTasks = val ?? false;
                    });
                  },
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Delete Notes', style: GoogleFonts.nunito()),
                  value: deleteNotes,
                  activeColor: const Color(0xFF6B9B85),
                  onChanged: (val) {
                    setDialogState(() {
                      deleteNotes = val ?? false;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel', style: GoogleFonts.nunito(color: Colors.grey.shade600)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  Navigator.pop(context);

                  // Capture providers before async gap
                  final diaryProvider = context.read<DiaryProvider>();
                  final habitProvider = context.read<HabitProvider>();

                  if (deleteNotes) {
                    await diaryProvider.deleteAllDiaryEntries();
                  }
                  if (deleteTasks) {
                    await habitProvider.deleteAllHabits();
                  }


                  if (context.mounted) {
                    if (deleteTasks || deleteNotes) {
                      AppToast.warning(context, deleteTasks && deleteNotes ? 'Tasks dan Notes dihapus.' : deleteTasks ? 'Tasks dihapus.' : 'Notes dihapus.');
                    } else {
                      AppToast.info(context, 'Tidak ada data yang dipilih.');
                    }
                  }
                },
                child: Text('Delete', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          );
        });
      },
    );
  }

  void _showSyncDialog() {
    final authService = context.read<AuthService>();
    if (!authService.isAuthenticated) {
      AppToast.warning(context, 'Login dulu untuk sync data');
      return;
    }

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Cloud Sync', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
          content: Text(
            'Upload your data to the cloud or restore from a previous backup.',
            style: GoogleFonts.nunito(color: Colors.grey.shade600, fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: GoogleFonts.nunito(color: Colors.grey.shade600)),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.cloud_download, color: Colors.white, size: 18),
              label: Text('Restore', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pop(ctx);
                _restoreFromCloud();
              },
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.cloud_upload, color: Colors.white, size: 18),
              label: Text('Upload', style: GoogleFonts.nunito(color: Colors.white, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pop(ctx);
                _uploadToCloud();
              },
            ),
          ],
        );
      },
    );
  }



  Future<void> _uploadToCloud() async {
    AppToast.info(context, 'Mengupload data ke cloud...');
    try {
      await SyncService.instance.uploadToCloud();
      if (mounted) AppToast.success(context, 'Data berhasil diupload!');
    } catch (e) {
      if (mounted) AppToast.error(context, 'Upload gagal: $e');
    }
  }

  Future<void> _restoreFromCloud() async {
    AppToast.info(context, 'Memulihkan data dari cloud...');
    
    // Capture providers before async gap
    final habitProvider = context.read<HabitProvider>();
    final diaryProvider = context.read<DiaryProvider>();

    try {
      await SyncService.instance.restoreFromCloud();

      // Refresh providers and local profile
      await _loadLocalProfile();
      await habitProvider.refreshAll();
      await diaryProvider.refreshAll();
      
      if (!mounted) return;
      AppToast.success(context, 'Data berhasil dipulihkan!');
    } catch (e) {
      if (!mounted) return;
      AppToast.error(context, 'Restore gagal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = context.watch<AuthService>();
    final isLoggedIn = authService.isAuthenticated;
    final user = authService.currentUser;
    final displayName = user?.displayName ?? user?.email?.split('@').first ?? 'Guest';
    final displayEmail = user?.email ?? '';

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header — DESIGN.md: Fredoka h2 (45px w800)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'My Profile',
                  style: GoogleFonts.fredoka(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Avatar Profile
              GestureDetector(
                onTap: () => _showEditProfileDialog(authService),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD4EBE1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                    image: _localPhotoBase64 != null
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(_localPhotoBase64!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _localPhotoBase64 == null
                      ? Icon(
                          isLoggedIn ? Icons.person : Icons.person_outline,
                          size: 50,
                          color: const Color(0xFF6B9B85),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _localDisplayName ?? (isLoggedIn ? displayName : 'Guest'),
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showEditProfileDialog(authService),
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(12),
                      child: Icon(Icons.edit, size: 20, color: Colors.grey),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (isLoggedIn && displayEmail.isNotEmpty)
                Text(
                  displayEmail,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                  ),
                ),
              const SizedBox(height: 24),

              // Stats Card — streak + completed habits
              Consumer<HabitProvider>(builder: (context, hp, _) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('assets/icons/streak_fire.svg', '${hp.currentStreak}', 'Day Streak'),
                      Container(width: 1, height: 40, color: Theme.of(context).dividerColor),
                      _buildStatItem('assets/icons/check_done.svg', '${hp.totalHabitsFinished}', 'Completed'),
                      Container(width: 1, height: 40, color: Theme.of(context).dividerColor),
                      _buildStatItem('assets/icons/total_habits.svg', '${hp.habits.length}', 'Total Habits'),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 24),

              // Menu Options
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuTile(
                      icon: Icons.cloud_sync_outlined,
                      title: 'Sync to Cloud Store',
                      subtitle: 'Backup your tasks & progress',
                      iconColor: Colors.blueAccent,
                      onTap: _showSyncDialog,
                    ),
                    Divider(height: 1, color: Theme.of(context).dividerColor),

                    _buildMenuTile(
                      icon: Icons.delete_outline,
                      title: 'Clear Data',
                      subtitle: 'Delete tasks and notes',
                      iconColor: Colors.redAccent,
                      onTap: _showClearDataDialog,
                    ),
                    Divider(height: 1, color: Theme.of(context).dividerColor),

                    _buildSwitchTile(
                      icon: Icons.notifications_active_outlined,
                      title: 'Daily Reminders',
                      subtitle: 'Get notified to complete habits',
                      iconColor: Colors.orange,
                      value: _notificationsEnabled,
                      onChanged: (val) async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('notificationsEnabled', val);
                        setState(() {
                          _notificationsEnabled = val;
                        });
                        
                        if (val) {
                          final granted = await NotificationService.instance.requestPermission();
                          if (granted) {
                            await NotificationService.instance.scheduleDailyReminder();
                            if (context.mounted) AppToast.success(context, 'Reminders enabled');
                          } else {
                            setState(() => _notificationsEnabled = false);
                            await prefs.setBool('notificationsEnabled', false);
                            if (context.mounted) AppToast.warning(context, 'Permission denied');
                          }
                        } else {
                          await NotificationService.instance.cancelAll();
                          if (context.mounted) AppToast.info(context, 'Reminders disabled');
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Login / Logout Button
              ChicletAnimatedButton(
                onPressed: () async {
                  if (isLoggedIn) {
                    // Clear local data before logout
                    final habitProvider = context.read<HabitProvider>();
                    final diaryProvider = context.read<DiaryProvider>();
                    await habitProvider.deleteAllHabits();
                    await diaryProvider.deleteAllDiaryEntries();
                    await authService.signOut();
                    if (context.mounted) {
                      await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                        MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
                        (route) => false,
                      );
                    }
                  } else {
                    await Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                      MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
                      (route) => false,
                    );
                  }
                },
                width: double.infinity,
                height: 55,
                buttonHeight: 5,
                borderRadius: 12,
                backgroundColor: isLoggedIn ? Colors.white : const Color(0xFF58CC02),
                buttonColor: isLoggedIn ? Colors.grey.shade300 : const Color(0xFF58A700),
                padding: EdgeInsets.zero,
                child: Center(
                  child: Text(
                    isLoggedIn ? 'LOGOUT' : 'LOGIN',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isLoggedIn ? Colors.redAccent : Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Footer
              Text(
                'DailyBit v1.0',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Build better habits, one day at a time.',
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  color: Colors.grey.shade400,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),
            ].animate(interval: 50.ms).fade(duration: 400.ms).slideY(begin: 0.1, curve: Curves.easeOutQuad),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String svgAsset, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(svgAsset, width: 22, height: 22),
            const SizedBox(width: 6),
            Text(
              value,
              style: GoogleFonts.fredoka(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.nunito(
          fontSize: 12,
          color: Colors.grey.shade500,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFF6B9B85),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      secondary: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 24),
      ),
      title: Text(
        title,
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.nunito(
          fontSize: 12,
          color: Colors.grey.shade500,
        ),
      ),
    );
  }
}
