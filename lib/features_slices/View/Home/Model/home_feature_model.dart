// import 'package:flutter/material.dart';

// class HomeFeatureModel {
//   final String title;
//   final IconData icon;
//   final Color background;
//   final Color accent;
//   final Color iconColor;

//   const HomeFeatureModel({
//     required this.title,
//     required this.icon,
//     required this.background,
//     required this.accent,
//     required this.iconColor,
//   });

//   static const List<HomeFeatureModel> popularFeatures = [
//     HomeFeatureModel(
//       title: 'Azkar',
//       icon: Icons.auto_awesome_rounded,
//       background: Color(0xFFE9F4E9),
//       accent: Color(0xFFCAF2C4),
//       iconColor: Color(0xFF076851),
//     ),
//     HomeFeatureModel(
//       title: 'Adaab',
//       icon: Icons.volunteer_activism_rounded,
//       background: Color(0xFFF9EDEC),
//       accent: Color(0xFFF7D9D4),
//       iconColor: Color(0xFF076851),
//     ),
//     HomeFeatureModel(
//       title: 'Asma-ul-Husna',
//       icon: Icons.verified_rounded,
//       background: Color(0xFFFCF6EA),
//       accent: Color(0xFFF9E7CB),
//       iconColor: Color(0xFF076851),
//     ),
//     HomeFeatureModel(
//       title: 'Islamic Library',
//       icon: Icons.menu_book_rounded,
//       background: Color(0xFFEBF1FD),
//       accent: Color(0xFFCFDEF8),
//       iconColor: Color(0xFF076851),
//     ),
//   ];
// }

class HomeFeatureModel {
  final String title;
  final String image;

  const HomeFeatureModel({required this.title, required this.image});

  static const List<HomeFeatureModel> popularFeatures = [
    HomeFeatureModel(title: 'Azkar', image: 'assets/Azkar_card.png'),
    HomeFeatureModel(title: 'Adaab', image: 'assets/Adaab_card.png'),
    HomeFeatureModel(
      title: 'Asma-ul-Husna',
      image: 'assets/Asma-ul-Husna_card.png',
    ),
    HomeFeatureModel(
      title: 'Islamic Library',
      image: 'assets/IslamicLibrary_card.png',
    ),
  ];
}
