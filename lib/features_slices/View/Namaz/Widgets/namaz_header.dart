import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart';

import '../Controller/namaz_controller.dart';

class NamazHeader extends StatelessWidget {
  const NamazHeader({
    super.key,
    required this.controller,
    required this.onAlarmSettingsTap,
    required this.onLocationSettingsTap,
  });

  final NamazController controller;
  final VoidCallback onAlarmSettingsTap;
  final VoidCallback onLocationSettingsTap;

  @override
  Widget build(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: context.responsivePadding(
            horizontal: 0.04,
            vertical: 0.016,
          ),
          child: Row(
            children: [
              if (canGoBack)
                IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.white,
                  ),
                )
              else
                SizedBox(width: context.widthPct(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: canGoBack
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Namaz',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: context.scaledFont(20).clamp(18.0, 26.0),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: context.heightPct(0.002)),
                    Obx(
                      () => Text(
                        controller.selectedFullDateSubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.white.withValues(alpha: 0.85),
                          fontSize: context.scaledFont(11.5).clamp(11.0, 14.0),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final active = controller.adhanEnabled.value;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      tooltip: 'Notification Settings',
                      onPressed: onAlarmSettingsTap,
                      icon: Icon(
                        active
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_off_outlined,
                        color: AppColors.white,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: ZiStatusDot(
                        color: active
                            ? AppColors.tabIndicator
                            : AppColors.error,
                        size: 8,
                      ),
                    ),
                  ],
                );
              }),
              IconButton(
                tooltip: 'Location & Calculation Settings',
                onPressed: onLocationSettingsTap,
                icon: const Icon(
                  Icons.tune_rounded,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
