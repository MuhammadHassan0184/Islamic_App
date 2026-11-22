import 'package:flutter/material.dart';

class AppColors {
  // Main Green
  static const Color primary = Color(0xFF2F6F1F);
  static const Color primaryDark = Color(0xFF245A19);
  static const Color primaryLight = Color(0xFF438632);

  // Main Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF397D27), Color(0xFF245A19)],
  );

  static const LinearGradient softGreenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE8F3E3), Color(0xFFD3E8CB)],
  );

  // General
  static const Color background = Color(0xFFF4F4F4);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF171717);

  // Text
  static const Color textPrimary = Color(0xFF202020);
  static const Color textSecondary = Color(0xFF888888);
  static const Color textLight = Color(0xFFB7B7B7);

  // Header
  static const Color headerGreen = Color(0xFF2F6F1F);
  static const Color tabIndicator = Color(0xFFF2DD27);
  static const Color inactiveTab = Color(0xFF9EBA96);

  // Dua Cards
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color cardBorder = Color(0xFFEEEEEE);

  // Category Backgrounds
  static const Color morningEvening = Color(0xFF858666);
  static const Color homeFamily = Color(0xFF515C61);
  static const Color foodDrink = Color(0xFF426D86);
  static const Color joyDistress = Color(0xFF71868B);
  static const Color worship = Color(0xFF668B76);
  static const Color protection = Color(0xFF81749C);
  static const Color travel = Color(0xFF987B63);
  static const Color dailyLife = Color(0xFF527C72);
  static const Color forgiveness = Color(0xFF777C9C);

  // Icons
  static const Color iconPrimary = Color(0xFF202020);
  static const Color iconSecondary = Color(0xFFBDBDBD);

  // Status
  static const Color success = Color(0xFF31965B);
  static const Color error = Color(0xFFD9534F);

  // warning
  static const Color warning = Color(0xFFE89B35);

  static const Color darkGreen = Color(0xFF00584C);
  static const Color primaryGreen = Color(0xFF087C65);
}
