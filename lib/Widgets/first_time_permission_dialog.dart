import 'package:flutter/material.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart';

class FirstTimePermissionSheet extends StatelessWidget {
  const FirstTimePermissionSheet({
    super.key,
    required this.onGrant,
    required this.onSkip,
  });

  final Future<void> Function() onGrant;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobile;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        context.widthPct(0.06),
        16,
        context.widthPct(0.06),
        context.bottomPadding + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header Icon & Title
            Center(
              child: Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  gradient: AppColors.softGreenGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.notifications_active_rounded,
                    color: AppColors.primary,
                    size: 38,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Stay Connected With Every Prayer',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 20 : 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'Grant notifications and exact alarm permissions so Islam786 can deliver accurate Adhan and prayer alarms on time, even when your phone is locked or the app is closed.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 13 : 14.5,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 22),

            // Feature List Cards
            _buildPermissionFeatureCard(
              context: context,
              icon: Icons.access_time_filled_rounded,
              title: 'Adhan & Prayer Times',
              subtitle:
                  'Accurate alerts for Fajr, Dhuhr, Asr, Maghrib, and Isha based on your city.',
              badgeText: 'Essential',
              badgeColor: AppColors.primary,
            ),
            const SizedBox(height: 12),

            _buildPermissionFeatureCard(
              context: context,
              icon: Icons.alarm_on_rounded,
              title: 'Exact Alarms & Off-Screen Wakeup',
              subtitle:
                  'Rings at the exact second even when Doze mode is active and screen is off.',
              badgeText: 'Reliable',
              badgeColor: const Color(0xFF1E88E5),
            ),
            const SizedBox(height: 12),

            _buildPermissionFeatureCard(
              context: context,
              icon: Icons.auto_stories_rounded,
              title: 'Daily Azkar & Remembrances',
              subtitle:
                  'Gentle morning, evening, and Sunnah Azkar reminders to keep you blessed.',
              badgeText: 'Sunnah',
              badgeColor: const Color(0xFF8E24AA),
            ),
            const SizedBox(height: 24),

            // Primary Grant Button
            ZiButtonB(
              label: 'Allow Alerts & Exact Alarms',
              variant: ZiButtonVariantB.primary,
              expand: true,
              action: () async {
                await onGrant();
              },
            ),
            const SizedBox(height: 10),

            // Secondary Skip Button
            ZiButtonB(
              label: 'Maybe Later',
              variant: ZiButtonVariantB.outline,
              expand: true,
              action: onSkip,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionFeatureCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String badgeText,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBF9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4ECE2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: badgeColor, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: badgeColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
