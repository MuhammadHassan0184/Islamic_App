import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart';

import '../Controller/namaz_controller.dart';

class NamazWeekStrip extends StatelessWidget {
  final NamazController controller;

  const NamazWeekStrip({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isViewingToday = controller.isViewingToday;
      final weekDays = controller.weekDays;
      final selectedIndex = controller.selectedDayIndex.value;

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(0.025),
          vertical: context.heightPct(0.012),
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(ZiRadius.card),
          border: Border.all(color: AppColors.cardBorder),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.025),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Previous week',
                  onPressed: controller.previousWeek,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          controller.selectedDateTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: context
                                .scaledFont(13)
                                .clamp(12.0, 16.0),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (!isViewingToday) ...[
                        ziGap(8),
                        InkWell(
                          onTap: controller.goToToday,
                          borderRadius: BorderRadius.circular(ZiRadius.full),
                          child: const ZiBadge(
                            label: 'Today',
                            color: AppColors.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Next week',
                  onPressed: controller.nextWeek,
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            SizedBox(height: context.heightPct(0.004)),
            Row(
              children: List.generate(weekDays.length, (index) {
                final date = weekDays[index];
                final isSelected = selectedIndex == index;
                final isToday = controller.isToday(date);

                return Expanded(
                  child: GestureDetector(
                    onTap: () => controller.selectDay(index),
                    behavior: HitTestBehavior.opaque,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                      padding: EdgeInsets.symmetric(
                        vertical: context.heightPct(0.006),
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(ZiRadius.md),
                      ),
                      child: Column(
                        children: [
                          Text(
                            controller.weekdayShort(date),
                            maxLines: 1,
                            style: TextStyle(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              fontSize: context
                                  .scaledFont(11)
                                  .clamp(10.0, 13.0),
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: context.heightPct(0.005)),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            width: context.widthPct(0.085),
                            height: context.widthPct(0.085),
                            constraints: const BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                              maxWidth: 40,
                              maxHeight: 40,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : isToday
                                  ? AppColors.softGreenGradient.colors.first
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                              border: isToday && !isSelected
                                  ? Border.all(
                                      color: AppColors.primaryLight,
                                      width: 1.2,
                                    )
                                  : null,
                            ),
                            child: Text(
                              '${date.day}',
                              style: TextStyle(
                                color: isSelected
                                    ? AppColors.white
                                    : isToday
                                    ? AppColors.primaryDark
                                    : AppColors.textPrimary,
                                fontSize: context
                                    .scaledFont(12)
                                    .clamp(11.0, 15.0),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: context.heightPct(0.004)),
                          SizedBox(
                            height: 5,
                            child: isToday
                                ? ZiStatusDot(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.tabIndicator,
                                    size: 5,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
