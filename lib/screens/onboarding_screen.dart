import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_in_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);
    if (!context.mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
      titleTextStyle: GoogleFonts.plusJakartaSans(fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black87),
      bodyTextStyle: GoogleFonts.plusJakartaSans(fontSize: 15.0, color: Colors.grey.shade600, fontWeight: FontWeight.w400, height: 1.5),
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: const EdgeInsets.only(top: 80),
      bodyAlignment: Alignment.topCenter,
      imageAlignment: Alignment.bottomCenter,
    );

    Widget buildImage(String assetName) {
      return Container(
        height: 280,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F0), // very subtle warm tint behind image like screenshot
          borderRadius: BorderRadius.circular(24),
        ),
        child: Center(
          child: SvgPicture.asset(assetName, width: 220),
        ),
      );
    }

    final nextButton = Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFD3F26A), // light green from screenshot
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.arrow_forward, color: Colors.black87),
      ),
    );

    final doneButton = Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: Color(0xFFD3F26A), // light green from screenshot
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(Icons.check, color: Colors.black87),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: IntroductionScreen(
        key: introKey,
        globalBackgroundColor: Colors.white,
        pages: [
          PageViewModel(
            title: 'Welcome to DailyBit',
            body: 'We’re here to help you grow and become the best version of yourself.',
            image: buildImage('assets/onboarding-ilust/page1.svg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Track your habits',
            body: 'Build a better routine and motivate yourself to achieve even more.',
            image: buildImage('assets/onboarding-ilust/page2.svg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Explore insights',
            body: 'Journal your thoughts and get an overview of how you are performing.',
            image: buildImage('assets/onboarding-ilust/page3.svg'),
            decoration: pageDecoration,
          ),
          PageViewModel(
            title: 'Start your journey',
            body: 'Join us today and make every single day a little bit better.',
            image: buildImage('assets/onboarding-ilust/page4.svg'),
            decoration: pageDecoration,
          ),
        ],
        onDone: () => _onIntroEnd(context),
        onSkip: () => _onIntroEnd(context),
        showSkipButton: true,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: false,
        skip: Text('Skip', style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
        next: nextButton,
        done: doneButton,
        curve: Curves.fastLinearToSlowEaseIn,
        controlsMargin: const EdgeInsets.all(24),
        controlsPadding: const EdgeInsets.all(0),
        dotsDecorator: DotsDecorator(
          size: const Size(16.0, 4.0),
          activeSize: const Size(24.0, 4.0),
          color: Colors.grey.shade300,
          activeColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          spacing: const EdgeInsets.symmetric(horizontal: 4.0),
        ),
      ),
    );
  }
}
