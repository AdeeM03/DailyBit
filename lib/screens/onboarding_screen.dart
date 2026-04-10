import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chiclet/chiclet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'sign_in_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF9FCFA), // Top light green-white
              Color(0xFFF0F5F6), // Middle slightly blueish
              Color(0xFFF9F9F9), // Bottom grey-white
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background faint elements (circles/stars)
              Positioned(
                top: 40,
                left: MediaQuery.of(context).size.width / 2 - 60,
                child: FaIcon(FontAwesomeIcons.globe, size: 120, color: Colors.green.withValues(alpha: 0.05)),
              ),
              Positioned(
                bottom: 20,
                left: MediaQuery.of(context).size.width / 2 - 50,
                child: FaIcon(FontAwesomeIcons.solidStar, size: 100, color: Colors.black.withValues(alpha: 0.03)),
              ),

              // Foreground content
              Column(
                children: [
                  const SizedBox(height: 24),
                  
                  // App Logo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.solidStar, color: Color(0xFF7CB342), size: 28),
                      const SizedBox(width: 8),
                      Text(
                        'DailyBit',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF3B5B2D),
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(flex: 1),

                  // Mascot Image
                  Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4E6DF),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7CB342).withValues(alpha: 0.15),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Center(child: FaIcon(FontAwesomeIcons.kiwiBird, size: 100, color: Color(0xFF5DB329))), // Placeholder mascot
                    ),
                  ),

                  const Spacer(flex: 1),

                  // Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text.rich(
                      TextSpan(
                        style: GoogleFonts.fredoka(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1A1A1A),
                          height: 1.2,
                        ),
                        children: const [
                          TextSpan(text: 'Welcome to\n'),
                          TextSpan(
                            text: 'DailyBit!',
                            style: TextStyle(color: Color(0xFF8CC63F)), // Lime green
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // Subtitle
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text.rich(
                      TextSpan(
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF4A4A4A),
                          height: 1.5,
                        ),
                        children: const [
                          TextSpan(text: 'The most fun way to build '),
                          TextSpan(
                            text: 'better habits',
                            style: TextStyle(
                              color: Color(0xFF2B7B8E), // Blueish teal
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          TextSpan(text: ' every day.'),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Get Started Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: ChicletAnimatedButton(
                      onPressed: () {
                        // For now just route to SignInScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const SignInScreen()),
                        );
                      },
                      width: double.infinity,
                      height: 64,
                      buttonHeight: 6,
                      borderRadius: 32,
                      backgroundColor: const Color(0xFF7CB342),
                      buttonColor: const Color(0xFF558B2F),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'GET STARTED',
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.5,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const FaIcon(FontAwesomeIcons.arrowRight, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Page Indicator (Mock)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFF7CB342),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8,
                        height: 6,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 1),

                  // Already have an account
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const SignInScreen()),
                      );
                    },
                    child: Text(
                      'I ALREADY HAVE AN ACCOUNT',
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF4A7D2C),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
