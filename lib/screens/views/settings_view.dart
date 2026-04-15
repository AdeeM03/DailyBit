import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/notification_service.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkNotificationStatus();
  }

  Future<void> _checkNotificationStatus() async {
    final hasNotifications = await NotificationService.instance.hasScheduledNotifications();
    if (mounted) {
      setState(() => _notificationsEnabled = hasNotifications);
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    if (value) {
      final granted = await NotificationService.instance.requestPermission();
      if (granted) {
        await NotificationService.instance.scheduleDailyReminder(hour: 8, minute: 0);
        if (mounted) setState(() => _notificationsEnabled = true);
      }
    } else {
      await NotificationService.instance.cancelAll();
      if (mounted) setState(() => _notificationsEnabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 24.0, bottom: 24.0),
              child: Text(
                'Settings',
                style: GoogleFonts.fredoka(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1B3B36),
                ),
              ),
            ),

            // Settings List
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  children: [
                    _buildSettingsTile(FontAwesomeIcons.user, 'Edit Profile', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildNotificationTile(),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(FontAwesomeIcons.globe, 'Language', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(FontAwesomeIcons.music, 'Sounds', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(FontAwesomeIcons.phone, 'Contact Us', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(FontAwesomeIcons.fileLines, 'Privacy Policy', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(FontAwesomeIcons.fileContract, 'Terms Of Use', true, false),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Top Right Moon Icon
        Positioned(
          top: 16,
          right: 24,
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFF62B694),
              shape: BoxShape.circle,
            ),
            child: const Center(child: FaIcon(FontAwesomeIcons.solidMoon, color: Colors.white, size: 20)),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9F7),
              shape: BoxShape.circle,
            ),
            child: Center(child: FaIcon(FontAwesomeIcons.bell, color: Colors.grey.shade600, size: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'Notifications',
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: const Color(0xFF2D3142),
              ),
            ),
          ),
          Switch(
            value: _notificationsEnabled,
            onChanged: _toggleNotifications,
            activeThumbColor: Colors.white,
            activeTrackColor: const Color(0xFF62B694),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(dynamic icon, String title, bool hasArrow, bool hasSwitch) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F9F7),
              shape: BoxShape.circle,
            ),
            child: Center(child: FaIcon(icon, color: Colors.grey.shade600, size: 20)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: 16,
                color: const Color(0xFF2D3142),
              ),
            ),
          ),
          if (hasArrow)
            FaIcon(FontAwesomeIcons.chevronRight, color: Colors.grey.shade400, size: 16),
          if (hasSwitch)
            Switch(
              value: true,
              onChanged: (val) {},
              activeThumbColor: Colors.white,
              activeTrackColor: const Color(0xFF62B694),
            ),
        ],
      ),
    );
  }
}
