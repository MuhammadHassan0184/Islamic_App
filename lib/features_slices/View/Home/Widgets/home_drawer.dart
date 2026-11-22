
import 'package:flutter/material.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

import '../Controller/home_controller.dart';

class HomeDrawer extends StatelessWidget {
  final HomeController controller;

  const HomeDrawer({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      (title: 'Home', icon: Icons.home_rounded),
      (title: 'Quran', icon: Icons.menu_book_rounded),
      (title: 'Listening', icon: Icons.headphones_rounded),
      (title: 'Test', icon: Icons.assignment_rounded),
      (title: 'Recite', icon: Icons.spa_rounded),
    ];

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: context.responsivePadding(
                horizontal: 0.06,
                vertical: 0.035,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF00765F),
                    Color(0xFF8BCFA8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    color: Colors.white,
                    size: context.scaledFont(38),
                  ),

                  SizedBox(height: context.heightPct(0.012)),

                  Text(
                    'Hafiz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.scaledFont(23),
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    'Your Quran companion',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: context.scaledFont(12),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: context.heightPct(0.015)),

            ...items.map(
              (item) => ListTile(
                leading: Icon(
                  item.icon,
                  color: AppColors.primaryGreen,
                ),
                title: Text(
                  item.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: context.scaledFont(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);

                  if (item.title != 'Home') {
                    controller.openFeature(item.title);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
