import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'onboarding_screen.dart';
import 'sign_in_screen.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Wait 2s for splash animation
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('has_seen_onboarding') ?? false;

    if (!mounted) return;

    final authService = context.read<AuthService>();
    final isLoggedIn = authService.isAuthenticated;

    Widget destination;
    if (!hasSeenOnboarding) {
      destination = const OnboardingScreen();
    } else if (isLoggedIn) {
      destination = const HomePage();
    } else {
      destination = const SignInScreen();
    }

    await Navigator.pushReplacement(
      context,
      PageRouteBuilder<void>(
        pageBuilder: (_, a, b) => destination,
        transitionsBuilder: (_, animation, c, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6ECF2E),
              Color(0xFF58CC02),
              Color(0xFF4CA020),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ─── Logo ───
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset('assets/icons/logo.png', width: 80, height: 80),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                )
                .fade(duration: 400.ms),
            const SizedBox(height: 24),

            // ─── App Name ───
            Text(
              'Dailybit',
              style: GoogleFonts.fredoka(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            )
                .animate(delay: 200.ms)
                .fade(duration: 500.ms)
                .slideY(begin: 0.3, curve: Curves.easeOutQuad),
            const SizedBox(height: 8),

            // ─── Tagline ───
            Text(
              'Sedikit setiap hari, besar hasilnya',
              style: GoogleFonts.nunito(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white.withValues(alpha: 0.85),
              ),
            )
                .animate(delay: 400.ms)
                .fade(duration: 500.ms)
                .slideY(begin: 0.3, curve: Curves.easeOutQuad),
            const SizedBox(height: 48),

            // ─── Loading indicator ───
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            )
                .animate(delay: 600.ms)
                .fade(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
