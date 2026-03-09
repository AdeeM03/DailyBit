import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

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
              child: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3B36),
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
                    _buildSettingsTile(Icons.person_outline, 'Edit Profile', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(Icons.notifications_none, 'Notifications', false, true),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(Icons.language, 'Language', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(Icons.music_note_outlined, 'Sounds', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(Icons.phone_outlined, 'Contact Us', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(Icons.description_outlined, 'Privacy Policy', true, false),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    _buildSettingsTile(Icons.article_outlined, 'Terms Of Use', true, false),
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
            child: const Icon(Icons.nightlight_round, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, bool hasArrow, bool hasSwitch) {
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
            child: Icon(icon, color: Colors.grey.shade600, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2D3142),
              ),
            ),
          ),
          if (hasArrow)
            Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 16),
          if (hasSwitch)
            Switch(
              value: true,
              onChanged: (val) {},
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF62B694),
            ),
        ],
      ),
    );
  }
}
