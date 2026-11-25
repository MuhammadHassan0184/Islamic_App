import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Config/Routes/app_routes.dart';

class ZiSplashScreen extends StatefulWidget {
  const ZiSplashScreen({super.key});

  @override
  State<ZiSplashScreen> createState() => _ZiSplashScreenState();
}

class _ZiSplashScreenState extends State<ZiSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _opacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scale = Tween<double>(
      begin: 0.88,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          Get.offAllNamed(AppRoutes.home);
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(color: Colors.white),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) => Opacity(
            opacity: _opacity.value,
            child: Transform.scale(scale: _scale.value, child: child),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.18),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Image.asset(
                      'assets/Islamic_app_Icon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Islam 786',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your Daily Islamic Companion',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    'بِسْمِ اللَّهِ الرَّحْمٰنِ الرَّحِيمِ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
