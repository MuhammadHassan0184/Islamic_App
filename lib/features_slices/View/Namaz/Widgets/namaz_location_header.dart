import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart';

import '../Controller/namaz_controller.dart';

class NamazLocationHeader extends StatelessWidget {
  final NamazController controller;
  final VoidCallback onLocationTap;
  final VoidCallback onAlarmTap;

  const NamazLocationHeader({
    super.key,
    required this.controller,
    required this.onLocationTap,
    required this.onAlarmTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(0.038),
        vertical: context.heightPct(0.012),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(ZiRadius.card),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: InkWell(
              onTap: onLocationTap,
              borderRadius: BorderRadius.circular(ZiRadius.md),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: AppColors.softGreenGradient,
                        borderRadius: BorderRadius.circular(ZiRadius.md),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: AppColors.primary,
                        size: context.scaledFont(19).clamp(18.0, 23.0),
                      ),
                    ),
                    ziGap(10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Obx(
                                () => Flexible(
                                  child: Text(
                                    controller.cityName.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: context
                                          .scaledFont(14)
                                          .clamp(13.0, 17.0),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppColors.textSecondary,
                                size: context.scaledFont(18).clamp(16.0, 22.0),
                              ),
                            ],
                          ),
                          SizedBox(height: context.heightPct(0.002)),
                          Obx(
                            () => Text(
                              controller.areaName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: context
                                    .scaledFont(11.5)
                                    .clamp(10.5, 13.5),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ziGap(8),
          Obx(() {
            final enabled = controller.adhanEnabled.value;
            final count = controller.enabledAlarmsCount;
            return InkWell(
              onTap: onAlarmTap,
              borderRadius: BorderRadius.circular(ZiRadius.md),
              child: ZiBadge(
                label: enabled ? '$count Active' : 'Muted',
                color: enabled ? AppColors.primary : AppColors.error,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
