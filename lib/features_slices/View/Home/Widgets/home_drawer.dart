import 'package:flutter/material.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

import '../Controller/home_controller.dart';

class HomeDrawer extends StatelessWidget {
  final HomeController controller;

  const HomeDrawer({super.key, required this.controller});

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
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00765F), Color(0xFF8BCFA8)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: context.widthPct(0.15),
                    height: context.widthPct(0.15),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.17),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: context.scaledFont(34),
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.016)),
                  Text(
                    'Hafiz',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: context.scaledFont(23),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.004)),
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

            SizedBox(height: context.heightPct(0.02)),

            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.widthPct(0.055),
              ),
              child: Text(
                'MENU',
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: context.scaledFont(10),
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ),

            SizedBox(height: context.heightPct(0.008)),

            ...items.map(
              (item) => Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(0.025),
                  vertical: 2,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: context.widthPct(0.045),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  leading: Icon(
                    item.icon,
                    color: AppColors.primaryGreen,
                    size: context.scaledFont(22),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: context.scaledFont(14),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey.shade400,
                    size: 13,
                  ),
                  onTap: () {
                    Navigator.pop(context);

                    if (item.title != 'Home') {
                      controller.openFeature(item.title);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
