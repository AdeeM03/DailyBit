import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chiclet/chiclet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'home_page.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF0F4F0),
              Color(0xFFEAF0F8),
              Color(0xFFF5F5F5),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 48),

                  // ─── Mascot / Logo ───
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Center(child: FaIcon(FontAwesomeIcons.robot, size: 48, color: Color(0xFF1A1A1A))),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ─── Title ───
                  Text(
                    'Welcome Back!',
                    style: GoogleFonts.fredoka(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Continue your habit journey',
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: const Color(0xFF888888),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ─── Email Field ───
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EMAIL ADDRESS',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF888888),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: GoogleFonts.nunito(color: const Color(0xFFBBBBBB)),
                          filled: true,
                          fillColor: const Color(0xFFEEEEEE),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style: GoogleFonts.nunito(fontSize: 15, color: const Color(0xFF1A1A1A)),
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter email' : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ─── Password Field ───
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PASSWORD',
                        style: GoogleFonts.nunito(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF888888),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        obscureText: _obscureText,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: GoogleFonts.nunito(color: const Color(0xFFBBBBBB)),
                          filled: true,
                          fillColor: const Color(0xFFEEEEEE),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() => _obscureText = !_obscureText),
                            child: FaIcon(
                              _obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                              color: const Color(0xFF888888),
                              size: 20,
                            ),
                          ),
                        ),
                        style: GoogleFonts.nunito(fontSize: 15, color: const Color(0xFF1A1A1A)),
                        validator: (value) => (value == null || value.isEmpty) ? 'Please enter password' : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ─── LOG IN Button ───
                  ChicletAnimatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomePage()),
                        );
                      }
                    },
                    backgroundColor: const Color(0xFF5DB329),
                    buttonColor: const Color(0xFF4CA020),
                    buttonHeight: 5,
                    borderRadius: 32,
                    width: double.infinity,
                    height: 56,
                    child: Text(
                      'LOG IN',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ─── OR divider ───
                  Row(
                    children: [
                      const Expanded(child: Divider(color: Color(0xFFDDDDDD))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: GoogleFonts.nunito(
                            color: const Color(0xFF888888),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(color: Color(0xFFDDDDDD))),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ─── Google Button ───
                  ChicletOutlinedAnimatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    },
                    backgroundColor: Colors.white,
                    borderColor: const Color(0xFFDDDDDD),
                    buttonColor: const Color(0xFFEEEEEE),
                    buttonHeight: 4,
                    borderWidth: 1.5,
                    borderRadius: 32,
                    width: double.infinity,
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google "G" icon using colored squares
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Center(child: FaIcon(FontAwesomeIcons.google, size: 18, color: Color(0xFF4285F4))),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'SIGN IN WITH GOOGLE',
                          style: GoogleFonts.fredoka(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF444444),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // ─── Guest Button ───
                  ChicletAnimatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomePage()),
                      );
                    },
                    backgroundColor: const Color(0xFF757575),
                    buttonColor: const Color(0xFF424242),
                    buttonHeight: 4,
                    borderRadius: 32,
                    width: double.infinity,
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.user, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'CONTINUE AS GUEST',
                          style: GoogleFonts.fredoka(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ─── Forgot Password ───
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF5DB329),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ─── Create Account ───
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.nunito(fontSize: 14, color: const Color(0xFF444444)),
                      text: "Don't have an account? ",
                      children: [
                        TextSpan(
                          text: 'Create one',
                          style: GoogleFonts.nunito(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1877F2),
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ─── Terms ───
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.nunito(fontSize: 12, color: const Color(0xFFAAAAAA)),
                      text: 'By logging in to DailyBit, you agree to our ',
                      children: [
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(decoration: TextDecoration.underline),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
