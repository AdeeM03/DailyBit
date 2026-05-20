import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:chiclet/chiclet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/auth_error_mapper.dart';
import '../utils/app_toast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _email = '';
  bool _isLoading = false;
  String? _emailError;

  Widget _buildInputField({
    required String hintText,
    required void Function(String) onChanged,
    String? errorText,
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
            onChanged: onChanged,
            autofillHints: autofillHints,
            keyboardType: TextInputType.emailAddress,
            style: GoogleFonts.nunito(fontSize: 16, color: const Color(0xFF1A1A1A), fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.nunito(color: const Color(0xFFAFAFAF), fontWeight: FontWeight.w600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
                Expanded(
                  child: Text(
                    errorText,
                    style: GoogleFonts.nunito(color: const Color(0xFFFF4B4B), fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Future<void> _handleReset() async {
    setState(() {
      _emailError = _email.isEmpty ? 'Alamat email tidak valid' : null;
    });
    if (_emailError != null) return;

    setState(() => _isLoading = true);
    try {
      await context.read<AuthService>().sendPasswordReset(_email);
      if (mounted) {
        AppToast.success(context, 'Email reset terkirim! Cek inbox kamu.');
        Navigator.pop(context);
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),

                // ─── Logo ───
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
                  'Reset Password',
                  style: GoogleFonts.fredoka(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 12),

                // ─── Subtitle ───
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Masukkan email kamu dan kami akan mengirim link untuk reset password.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      fontSize: 15,
                      color: const Color(0xFF777777),
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ─── Email Input ───
                _buildInputField(
                  hintText: 'Email',
                  errorText: _emailError,
                  autofillHints: const [AutofillHints.email],
                  onChanged: (val) {
                    _email = val;
                    if (_emailError != null) setState(() => _emailError = null);
                  },
                ),
                const SizedBox(height: 32),

                // ─── RESET Button ───
                ChicletAnimatedButton(
                  onPressed: _isLoading ? () {} : _handleReset,
                  backgroundColor: const Color(0xFF5DB329),
                  buttonColor: const Color(0xFF4CA020),
                  buttonHeight: 5,
                  borderRadius: 12,
                  width: double.infinity,
                  height: 56,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'RESET PASSWORD',
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: Colors.white,
                          ),
                        ),
                ),
                const SizedBox(height: 28),

                // ─── Back to Login ───
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FaIcon(FontAwesomeIcons.arrowLeft, color: Color(0xFF5DB329), size: 14),
                      const SizedBox(width: 8),
                      Text(
                        'Kembali ke Login',
                        style: GoogleFonts.nunito(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF5DB329),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ].animate(interval: 50.ms).fade(duration: 300.ms).slideX(begin: -0.05, curve: Curves.easeOutQuad),
            ),
          ),
        ),
      ),
    );
  }
}
