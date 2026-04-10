import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Profile page is mostly white based on mockup
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const FaIcon(FontAwesomeIcons.chevronLeft, color: Color(0xFF2D3142), size: 20),
                  Text(
                    'Profile',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4EBE1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: FaIcon(FontAwesomeIcons.check, color: Color(0xFF1B3B36), size: 16)),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Avatar
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFDF0D5),
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: const Center(child: FaIcon(FontAwesomeIcons.solidUser, size: 50, color: Colors.orange)),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.tealAccent.shade400,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Center(child: FaIcon(FontAwesomeIcons.pen, color: Colors.white, size: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name & Badge
              Text(
                'Abdullah Masykur',
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFD4EBE1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const FaIcon(FontAwesomeIcons.medal, color: Color(0xFF6B9B85), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '142 Tasks Completed',
                      style: GoogleFonts.nunito(
                        color: const Color(0xFF6B9B85),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Personal Details
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Details',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3142),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailField('FULL NAME', 'Abdullah Masykur'),
              const SizedBox(height: 16),
              _buildDetailField('EMAIL ADDRESS', 'masykur@gmail.com'),
              const SizedBox(height: 16),
              _buildDetailField('PHONE NUMBER', '+62 812-3456-7890'),
              const SizedBox(height: 32),

              // Weekly Performance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Performance',
                    style: GoogleFonts.fredoka(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                    ),
                  ),
                  Text(
                    'LAST 7 DAYS',
                    style: GoogleFonts.fredoka(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.tealAccent.shade400,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade200),
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
                    // A simple grid placeholder for the calendar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) => 
                        Text(day, style: TextStyle(color: Colors.grey.shade500, fontSize: 12))
                      ).toList(),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 1,
                      ),
                      itemCount: 28,
                      itemBuilder: (context, index) {
                        bool isActive = (index % 3 != 0); // Randomize active days for visual
                        return Container(
                          decoration: BoxDecoration(
                            color: isActive ? const Color(0xFFD4EBE1) : const Color(0xFFF5F9F7),
                            borderRadius: BorderRadius.circular(8),
                            border: index == 27 ? Border.all(color: Colors.tealAccent.shade400, width: 1.5) : null,
                          ),
                          child: index == 27 ? Center(child: FaIcon(FontAwesomeIcons.solidCircle, size: 8, color: Colors.tealAccent.shade400)) : null,
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                        children: const [
                          TextSpan(text: "You've been active for "),
                          TextSpan(text: "24 days", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D3142))),
                          TextSpan(text: " this month."),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B9B85),
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.teal.shade50),
          ),
          child: Text(
            value,
            style: GoogleFonts.nunito(
              fontSize: 16,
              color: const Color(0xFF2D3142),
            ),
          ),
        ),
      ],
    );
  }
}
