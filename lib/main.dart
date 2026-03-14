import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(const DailybitApp());
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
        scaffoldBackgroundColor: const Color(0xFFF5F9F7), // Putih kehijauan sangat lembut
        primaryColor: const Color(0xFFD4EBE1), // Mint Green
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD4EBE1),
          primary: const Color(0xFF6B9B85), // Hijau agak gelap untuk teks/icon aktif
          secondary: const Color(0xFFFFD6B3), // Warna aksen pastel untuk Pibo/Highlight
        ),
        // Gunakan font modern dan membulat, cocok untuk desain minimalis
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true, // Wajib diaktifkan untuk desain modern
      ),
      home: const OnboardingScreen(),
    );
  }
}