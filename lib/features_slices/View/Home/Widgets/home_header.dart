import 'package:flutter/material.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

import '../Controller/home_controller.dart';

class HomeHeader extends StatelessWidget {
  final HomeController controller;

  const HomeHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.heightPct(0.055),
      child: Row(
        children: [
          _HeaderIconButton(
            icon: Icons.menu_rounded,
            onTap: controller.openDrawer,
          ),

          const Spacer(),

          Text(
            'Hafiz',
            style: TextStyle(
              color: AppColors.darkGreen,
              fontSize: context.scaledFont(19),
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),

          const Spacer(),

          _HeaderIconButton(
            icon: Icons.search_rounded,
            onTap: controller.openSearch,
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(context.widthPct(0.012)),
          child: Icon(
            icon,
            color: const Color(0xFF2E2E2E),
            size: context.scaledFont(25),
          ),
        ),
      ),
    );
  }
}
