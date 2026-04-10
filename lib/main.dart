import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';

import 'package:provider/provider.dart';
import 'providers/app_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: const DailybitApp(),
    ),
  );
}

class DailybitApp extends StatelessWidget {
  const DailybitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dailybit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Palet Warna Utama (Mint Green Pastel)
        scaffoldBackgroundColor: const Color(0xFFF5F9F7),
        primaryColor: const Color(0xFFD4EBE1),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4EBE1),
          primary: const Color(0xFF6B9B85),
          secondary: const Color(0xFFFFD6B3),
        ),
        // Nunito for body text globally
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          // Override display/headline styles with Fredoka
          displayLarge: GoogleFonts.fredoka(fontSize: 57, fontWeight: FontWeight.w800, color: const Color(0xFF2D3142)),
          displayMedium: GoogleFonts.fredoka(fontSize: 45, fontWeight: FontWeight.w800, color: const Color(0xFF2D3142)),
          displaySmall: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w800, color: const Color(0xFF2D3142)),
          headlineLarge: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.w800, color: const Color(0xFF2D3142)),
          headlineMedium: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.w700, color: const Color(0xFF2D3142)),
          headlineSmall: GoogleFonts.fredoka(fontSize: 24, fontWeight: FontWeight.w700, color: const Color(0xFF2D3142)),
          titleLarge: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: const Color(0xFF2D3142)),
          titleMedium: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF2D3142)),
          titleSmall: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF2D3142)),
        ),
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}