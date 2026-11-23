import 'package:flutter/material.dart';

class HomeFeatureModel {
  final String title;
  final IconData icon;
  final Color background;
  final Color accent;
  final Color iconColor;

  const HomeFeatureModel({
    required this.title,
    required this.icon,
    required this.background,
    required this.accent,
    required this.iconColor,
  });

  static const List<HomeFeatureModel> popularFeatures = [
    HomeFeatureModel(
      title: 'Azkar',
      icon: Icons.auto_awesome_rounded,
      background: Color(0xFFF1F9F1),
      accent: Color(0xFFDDF6D9),
      iconColor: Color(0xFF087A5F),
    ),
    HomeFeatureModel(
      title: 'Adaab',
      icon: Icons.volunteer_activism_rounded,
      background: Color(0xFFFFF5F4),
      accent: Color(0xFFFBE5E2),
      iconColor: Color(0xFF087A65),
    ),
    HomeFeatureModel(
      title: 'Asma-ul-Husna',
      icon: Icons.verified_rounded,
      background: Color(0xFFFFF9EF),
      accent: Color(0xFFFFF0D9),
      iconColor: Color(0xFF39766A),
    ),
    HomeFeatureModel(
      title: 'Islamic Library',
      icon: Icons.menu_book_rounded,
      background: Color(0xFFF1F6FF),
      accent: Color(0xFFDCE9FF),
      iconColor: Color(0xFF39766A),
    ),
  ];
}
