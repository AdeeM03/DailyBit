import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chiclet/chiclet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/sync_service.dart';
import '../providers/habit_provider.dart';
import '../providers/diary_provider.dart';
import '../utils/auth_error_mapper.dart';
import '../utils/app_toast.dart';
import 'home_page.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final bool _obscureText = true;
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  Widget _buildInputField({
    required String hintText,
    required void Function(String) onChanged,
    String? errorText,
    bool obscureText = false,
    Widget? suffixIcon,
    List<String>? autofillHints,
  }) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasError ? const Color(0xFFFF4B4B) : const Color(0xFFE5E5E5),
              width: 2,
            ),
          ),
          child: TextField(
            obscureText: obscureText,
            onChanged: onChanged,
            autofillHints: autofillHints,
            style: GoogleFonts.nunito(fontSize: 16, color: const Color(0xFF1A1A1A), fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.nunito(color: const Color(0xFFAFAFAF), fontWeight: FontWeight.w600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              suffixIcon: suffixIcon,
              suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: Row(
              children: [
                const FaIcon(FontAwesomeIcons.circleExclamation, color: Color(0xFFFF4B4B), size: 14),
                const SizedBox(width: 6),
                Text(
                  errorText,
                  style: GoogleFonts.nunito(color: const Color(0xFFFF4B4B), fontSize: 13, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _handleAuth(Future<void> Function() authAction) async {
    // Capture providers before any async gap
    final habitProv = context.read<HabitProvider>();
    final diaryProv = context.read<DiaryProvider>();
    setState(() => _isLoading = true);
    try {
      await authAction();

      // Auto-restore progress if available
      final restored = await SyncService.instance.autoRestoreIfAvailable();
      if (restored && mounted) {
        await habitProv.refreshAll();
        await diaryProv.refreshAll();
      }

      if (mounted) {
        AppToast.success(context, 'Berhasil login!');
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        AppToast.error(context, mapAuthError(e));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
                    child: Center(
                      child: Image.asset('assets/icons/logo.png', width: 64, height: 64),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ─── Title ───
                  Text(
                    'Masuk',
                    style: GoogleFonts.fredoka(
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ─── Input Fields ───
                  _buildInputField(
                    hintText: 'Email atau nama pengguna',
                    errorText: _emailError,
                    autofillHints: const [AutofillHints.email],
                    onChanged: (val) {
                      _email = val;
                      if (_emailError != null) setState(() => _emailError = null);
                    },
                  ),
                  const SizedBox(height: 16),

                  _buildInputField(
                    hintText: 'Kata sandi',
                    errorText: _passwordError,
                    obscureText: _obscureText,
                    autofillHints: const [AutofillHints.password],
                    onChanged: (val) {
                      _password = val;
                      if (_passwordError != null) setState(() => _passwordError = null);
                    },
                    suffixIcon: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen()),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(
                          'LUPA?',
                          style: GoogleFonts.nunito(
                            color: const Color(0xFF1CB0F6),
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ─── LOG IN Button ───
                  ChicletAnimatedButton(
                    onPressed: _isLoading
                        ? () {}
                        : () {
                            setState(() {
                              _emailError = _email.isEmpty ? 'Alamat email tidak valid' : null;
                              _passwordError = _password.isEmpty ? 'Kata sandi terlalu pendek' : null;
                            });
                            if (_emailError == null && _passwordError == null) {
                              _handleAuth(() => context.read<AuthService>().signInWithEmail(_email, _password));
                            }
                          },
                    backgroundColor: const Color(0xFF5DB329),
                    buttonColor: const Color(0xFF4CA020),
                    buttonHeight: 5,
                    borderRadius: 12,
                    width: double.infinity,
                    height: 56,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
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

                  // ─── Social Logins ───
                  Row(
                    children: [
                      Expanded(
                        child: ChicletOutlinedAnimatedButton(
                          onPressed: () => _handleAuth(() => context.read<AuthService>().signInWithGoogle()),
                          backgroundColor: Colors.white,
                          borderColor: const Color(0xFFE5E5E5),
                          buttonColor: const Color(0xFFEEEEEE),
                          buttonHeight: 4,
                          borderWidth: 2,
                          borderRadius: 16,
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/google.svg', width: 24, height: 24),
                              const SizedBox(width: 8),
                              Text(
                                'GOOGLE',
                                style: GoogleFonts.fredoka(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1CB0F6),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ChicletOutlinedAnimatedButton(
                          onPressed: () => _handleAuth(() => context.read<AuthService>().signInAnonymously()),
                          backgroundColor: Colors.white,
                          borderColor: const Color(0xFFE5E5E5),
                          buttonColor: const Color(0xFFEEEEEE),
                          buttonHeight: 4,
                          borderWidth: 2,
                          borderRadius: 16,
                          height: 56,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/icons/guest.svg', width: 24, height: 24),
                              const SizedBox(width: 8),
                              Text(
                                'GUEST',
                                style: GoogleFonts.fredoka(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1CB0F6),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ─── Forgot Password ───
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen()),
                    ),
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
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<void>(builder: (_) => const SignUpScreen()),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ].animate(interval: 50.ms).fade(duration: 300.ms).slideX(begin: -0.05, curve: Curves.easeOutQuad),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
