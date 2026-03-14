import 'package:flutter/material.dart';
import 'home_page.dart'; // import the main app screen

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            Expanded(
              flex: 14,
              child: PageView.builder(
                itemCount: demoData.length,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                itemBuilder: (context, index) => OnboardContent(
                  illustration: demoData[index]["illustration"],
                  title: demoData[index]["title"],
                  text: demoData[index]["text"],
                ),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                demoData.length,
                (index) => DotIndicator(isActive: index == currentPage),
              ),
            ),
            const Spacer(flex: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () {
                  // Route to the MainScreen (HomePage)
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B9B85), // Updated to match Dailybit primary green color
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50), // slightly taller for better UX
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Get Started".toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class OnboardContent extends StatelessWidget {
  const OnboardContent({
    super.key,
    required this.illustration,
    required this.title,
    required this.text,
  });

  final String? illustration, title, text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1,
            child: Image.network(
              illustration!,
              fit: BoxFit.contain,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          title!,
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF2D3142)),
        ),
        const SizedBox(height: 8),
        Text(
          text!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    super.key,
    this.isActive = false,
    this.activeColor = const Color(0xFF6B9B85), // Updated color
    this.inActiveColor = const Color(0xFFD4EBE1), // Light mint green
  });

  final bool isActive;
  final Color activeColor, inActiveColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(horizontal: 16 / 2),
      height: isActive ? 6 : 4,
      width: isActive ? 20 : 8,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inActiveColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}

// Demo data for our Onboarding screen
List<Map<String, dynamic>> demoData = [
  {
    "illustration": "https://i.postimg.cc/L43CKddq/Illustrations.png",
    "title": "Welcome to Dailybit",
    "text":
        "The best tool to manage your \ndaily habits and routines.",
  },
  {
    "illustration": "https://i.postimg.cc/xTjs9sY6/Illustrations-1.png",
    "title": "Build Consistency",
    "text":
        "Keep track of your hot streaks\nand build a better life.",
  },
  {
    "illustration": "https://i.postimg.cc/6qcYdZVV/Illustrations-2.png",
    "title": "Achieve Your Goals",
    "text":
        "Crush your daily tasks and\nunlock new levels of productivity.",
  },
];
