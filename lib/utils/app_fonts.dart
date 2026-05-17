import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central font helper for DailyBit.
///
/// - **Fredoka**: Headings, streak numbers, button text (chiclet & action buttons).
/// - **Nunito**: Body text, descriptions, notes, settings, long paragraphs.
class AppFonts {
  AppFonts._();

  // ─── Fredoka (Headings, Numbers, Button Text) ───
  static TextStyle heading({
    double fontSize = 28,
    FontWeight fontWeight = FontWeight.w800,
    Color color = const Color(0xFF2D3142),
    double? height,
    double? letterSpacing,
    FontStyle? fontStyle,
  }) =>
      GoogleFonts.fredoka(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontStyle: fontStyle,
      );

  static TextStyle button({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w700,
    Color color = Colors.white,
    double? letterSpacing,
  }) =>
      GoogleFonts.fredoka(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle streak({
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w800,
    Color color = const Color(0xFF58A700),
  }) =>
      GoogleFonts.fredoka(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );

  // ─── Nunito (Body, Descriptions, Notes, Settings) ───
  static TextStyle body({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w500,
    Color color = const Color(0xFF4A4A4A),
    double? height,
    FontStyle? fontStyle,
    double? letterSpacing,
  }) =>
      GoogleFonts.nunito(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
      );

  static TextStyle label({
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w700,
    Color color = const Color(0xFF888888),
    double? letterSpacing,
  }) =>
      GoogleFonts.nunito(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing ?? 1.2,
      );
}
