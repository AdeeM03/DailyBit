import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'screens/onboarding_screen.dart';

import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'providers/habit_provider.dart';
import 'providers/diary_provider.dart';
import 'services/database_helper.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';

// Shared Fredoka headline overrides — applied to both light and dark textTheme
TextTheme _fredokaOverrides(TextTheme base, Color headingColor) {
  return base.copyWith(
    displayLarge: GoogleFonts.fredoka(fontSize: 57, fontWeight: FontWeight.w800, color: headingColor),
    displayMedium: GoogleFonts.fredoka(fontSize: 45, fontWeight: FontWeight.w800, color: headingColor),
    displaySmall: GoogleFonts.fredoka(fontSize: 36, fontWeight: FontWeight.w800, color: headingColor),
    headlineLarge: GoogleFonts.fredoka(fontSize: 32, fontWeight: FontWeight.w800, color: headingColor),
    headlineMedium: GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.w700, color: headingColor),
    headlineSmall: GoogleFonts.fredoka(fontSize: 24, fontWeight: FontWeight.w700, color: headingColor),
    titleLarge: GoogleFonts.fredoka(fontSize: 22, fontWeight: FontWeight.w700, color: headingColor),
    titleMedium: GoogleFonts.fredoka(fontSize: 16, fontWeight: FontWeight.w600, color: headingColor),
    titleSmall: GoogleFonts.fredoka(fontSize: 14, fontWeight: FontWeight.w600, color: headingColor),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar database
  String dbDir = '';
  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    dbDir = dir.path;
  }
  await DatabaseHelper.instance.init(dbDir);

  // Initialize notification service (no-op on web)
  await NotificationService.instance.init();

  // Initialize Firebase safely
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }

  // ─── Global Error Handlers ───
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('┌── FlutterError ──');
    debugPrint('│ ${details.exceptionAsString()}');
    debugPrint('└── ${details.stack?.toString().split('\n').take(5).join('\n│ ')}');
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    debugPrint('┌── PlatformError ──');
    debugPrint('│ $error');
    debugPrint('└── ${stack.toString().split('\n').take(5).join('\n│ ')}');
    return true; // Handled — prevent crash
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<HabitProvider>(create: (_) => HabitProvider()),
        ChangeNotifierProvider<DiaryProvider>(create: (_) => DiaryProvider()),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
      ],
      child: const DailybitApp(),
    ),
  );
}

class DailybitApp extends StatelessWidget {
  const DailybitApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Duolingo Brand colors
    const primary = Color(0xFF58CC02);
    const primaryLight = Color(0xFFDDF4FF); // Light blue for active states
    const secondary = Color(0xFF1CB0F6); // Primary Blue

    // Light theme via FlexColorScheme
    final lightTheme = FlexThemeData.light(
      colors: FlexSchemeColor.from(
        primary: primary,
        primaryContainer: primaryLight,
        secondary: secondary,
      ),
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 0,
      subThemesData: const FlexSubThemesData(
        cardRadius: 16.0,
        defaultRadius: 12.0,
        bottomNavigationBarOpacity: 1.0,
      ),
      useMaterial3: true,
      fontFamily: GoogleFonts.nunito().fontFamily,
    ).copyWith(
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      textTheme: _fredokaOverrides(
        GoogleFonts.nunitoTextTheme(ThemeData.light().textTheme),
        const Color(0xFF4B4B4B), // Dark Text
      ),
    );



    return MaterialApp(
      title: 'Dailybit',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
      ],
      home: const OnboardingScreen(),
    );
  }
}
