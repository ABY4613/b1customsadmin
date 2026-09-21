import 'package:flutter/material.dart';

class AppColors {
  // Brand Dark Theme Colors
  static const Color background = Color(0xFF090A0E); // Jet Black
  static const Color surface = Color(0xFF11141F); // Dark Slate Surface
  static const Color surfaceLight = Color(0xFF181C2B); // Card Elevation
  static const Color border = Color(0xFF262C3F); // Muted Border
  static const Color borderHighlight = Color(0xFF3B4460); // Active Border

  // Accents
  static const Color primary = Color(0xFF00F0FF); // Cyber Cyan Accent
  static const Color primaryLight = Color(0xFFE0FBFC);
  static const Color accentWhite = Color(0xFFFFFFFF);
  static const Color accentGrey = Color(0xFF8E9BB0); // Slate Grey
  static const Color textMuted = Color(0xFF6B7280);

  // Status & Notifications
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color warning = Color(0xFFF59E0B); // Cyber Amber
  static const Color danger = Color(0xFFEF4444); // Crimson Red
  static const Color info = Color(0xFF3B82F6); // Electric Blue
  static const Color purple = Color(0xFF8B5CF6); // Neon Purple

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00F0FF), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF141724), Color(0xFF0E1019)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x22262C3F), Color(0x0F11141F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
