import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized toast helper — use instead of SnackBar.
class AppToast {
  AppToast._();

  static void success(BuildContext context, String message) {
    CherryToast.success(
      title: Text(message, style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
      animationType: AnimationType.fromTop,
      toastDuration: const Duration(seconds: 3),
    ).show(context);
  }

  static void error(BuildContext context, String message) {
    CherryToast.error(
      title: Text(message, style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
      animationType: AnimationType.fromTop,
      toastDuration: const Duration(seconds: 4),
    ).show(context);
  }

  static void info(BuildContext context, String message) {
    CherryToast.info(
      title: Text(message, style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
      animationType: AnimationType.fromTop,
      toastDuration: const Duration(seconds: 3),
    ).show(context);
  }

  static void warning(BuildContext context, String message) {
    CherryToast.warning(
      title: Text(message, style: GoogleFonts.nunito(fontWeight: FontWeight.w700)),
      animationType: AnimationType.fromTop,
      toastDuration: const Duration(seconds: 3),
    ).show(context);
  }
}
