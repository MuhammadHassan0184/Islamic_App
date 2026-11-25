import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart';

import '../Controller/namaz_controller.dart';

class NextPrayerCard extends StatelessWidget {
  final NamazController controller;
  final VoidCallback onAlarmModeTap;

  const NextPrayerCard({
    super.key,
    required this.controller,
    required this.onAlarmModeTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final compact = width < 350;
        final height = (width * 0.48).clamp(172.0, 215.0);

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(ZiRadius.xl - 4),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(ZiRadius.xl - 4),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.20),
                  blurRadius: 18,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative background highlight.
                Positioned(
                  right: -width * 0.12,
                  bottom: -height * 0.55,
                  child: Container(
                    width: width * 0.62,
                    height: width * 0.62,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Right-side banner artwork.
                Positioned(
                  right: -width * 0.02,
                  top: height * 0.04,
                  bottom: height * 0.06,
                  width: width * 0.44,
                  child: Image.asset(
                    'assets/Namaz_top_banner_image.png',
                    fit: BoxFit.contain,
                    alignment: Alignment.centerRight,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.mosque_rounded,
                        color: AppColors.white.withValues(alpha: 0.72),
                        size: width * 0.24,
                      );
                    },
                  ),
                ),

                // Foreground content.
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.05,
                    vertical: height * 0.09,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top controls row: Adhan toggle & alarm mode pill
                      Row(
                        children: [
                          Obx(() {
                            final enabled = controller.adhanEnabled.value;
                            return Material(
                              color: AppColors.white.withValues(alpha: 0.20),
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: controller.toggleAdhan,
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: compact ? 8 : 10,
                                    vertical: compact ? 5 : 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        enabled
                                            ? Icons.volume_up_rounded
                                            : Icons.volume_off_rounded,
                                        color: AppColors.white,
                                        size: compact ? 16 : 18,
                                      ),
                                      ziGap(6),
                                      Text(
                                        enabled ? 'ALARM ON' : 'MUTED',
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: context
                                              .scaledFont(11)
                                              .clamp(10.0, 13.0),
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                          ziGap(8),
                          Obx(() {
                            final mode = controller.globalAlarmMode.value;
                            return Material(
                              color: AppColors.white.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: onAlarmModeTap,
                                borderRadius: BorderRadius.circular(10),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: compact ? 7 : 9,
                                    vertical: compact ? 5 : 6,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        mode.icon,
                                        color: AppColors.tabIndicator,
                                        size: compact ? 14 : 16,
                                      ),
                                      ziGap(4),
                                      Text(
                                        mode.label,
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: context
                                              .scaledFont(11)
                                              .clamp(10.0, 13.0),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),

                      const Spacer(),

                      // Upcoming label + prayer name + countdown
                      Obx(() {
                        final isTomorrow = controller.isNextPrayerTomorrow;
                        final countdown = controller.nextPrayerCountdown;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isTomorrow
                                  ? 'NEXT PRAYER • TOMORROW'
                                  : 'NEXT PRAYER',
                              style: TextStyle(
                                color: AppColors.tabIndicator,
                                fontSize: context
                                    .scaledFont(10.5)
                                    .clamp(9.5, 12.5),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.9,
                              ),
                            ),
                            SizedBox(height: height * 0.012),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Flexible(
                                  child: Text(
                                    controller.featuredPrayerName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: context
                                          .scaledFont(18)
                                          .clamp(16.0, 22.0),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                ziGap(8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.white.withValues(
                                      alpha: 0.18,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      ZiRadius.full,
                                    ),
                                  ),
                                  child: Text(
                                    'in $countdown',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: context
                                          .scaledFont(11)
                                          .clamp(10.0, 13.0),
                                      fontWeight: FontWeight.w600,
                                      fontFeatures: const [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.01),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(
                                controller.featuredPrayerTime,
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: context
                                      .scaledFont(28)
                                      .clamp(24.0, 34.0),
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.6,
                                  fontFeatures: const [
                                    FontFeature.tabularFigures(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }),

                      SizedBox(height: height * 0.03),

                      // Progress indicator toward next prayer
                      Obx(
                        () => ClipRRect(
                          borderRadius: BorderRadius.circular(ZiRadius.full),
                          child: LinearProgressIndicator(
                            value: controller.nextPrayerProgress,
                            minHeight: 5,
                            color: AppColors.tabIndicator,
                            backgroundColor: AppColors.white.withValues(
                              alpha: 0.22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
