import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

import '../Controller/namaz_controller.dart';

class NextPrayerCard extends StatelessWidget {
  final NamazController controller;

  const NextPrayerCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final compact = width < 350;

        final height = (width * 0.46).clamp(145.0, 185.0);

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.16),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative background highlight.
                Positioned(
                  right: -width * 0.12,
                  bottom: -height * 0.65,
                  child: Container(
                    width: width * 0.65,
                    height: width * 0.65,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Right-side banner image.
                Positioned(
                  right: -context.widthPct(0.035),
                  top: -context.widthPct(0.035),
                  bottom: -context.widthPct(0.035),
                  width: context.widthPct(0.48),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.025,
                      // horizontal: width * 0.015,
                    ),
                    child: Image.asset(
                      'assets/Namaz_top_banner_image.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                      alignment: Alignment.centerRight,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.mosque_rounded,
                          color: AppColors.white.withValues(alpha: 0.75),
                          size: width * 0.25,
                        );
                      },
                    ),
                  ),
                ),

                // Left-side content.
                Positioned(
                  left: width * 0.045,
                  top: height * 0.12,
                  bottom: height * 0.11,
                  width: width * 0.53,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Adhan toggle.
                      Row(
                        children: [
                          Obx(
                            () => Material(
                              color: AppColors.white.withValues(alpha: 0.22),
                              borderRadius: BorderRadius.circular(9),
                              child: InkWell(
                                onTap: controller.toggleAdhan,
                                borderRadius: BorderRadius.circular(9),
                                child: SizedBox(
                                  width: compact ? 32 : 36,
                                  height: compact ? 32 : 36,
                                  child: Icon(
                                    controller.adhanEnabled.value
                                        ? Icons.volume_up_rounded
                                        : Icons.volume_off_rounded,
                                    color: AppColors.white,
                                    size: compact ? 18 : 21,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.025),
                          Obx(
                            () => Text(
                              controller.adhanEnabled.value ? 'ON' : 'OFF',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: context.scaledFont(12),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      Text(
                        controller.featuredPrayerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.88),
                          fontSize: context.scaledFont(16),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: height * 0.015),

                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          controller.featuredPrayerTime,
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: context.scaledFont(29),
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
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
