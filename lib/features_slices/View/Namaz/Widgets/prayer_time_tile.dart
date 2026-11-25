import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart';

import '../Model/prayer_time_model.dart';

class PrayerTimeTile extends StatelessWidget {
  final PrayerTimeModel prayer;
  final bool use24Hour;
  final bool isNext;
  final bool isActive;
  final bool isPassed;
  final VoidCallback onSoundTap;
  final VoidCallback onEditTap;

  const PrayerTimeTile({
    super.key,
    required this.prayer,
    required this.use24Hour,
    required this.isNext,
    required this.isActive,
    required this.isPassed,
    required this.onSoundTap,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isNext
        ? AppColors.primary
        : isActive
        ? AppColors.primaryLight.withValues(alpha: 0.55)
        : AppColors.cardBorder;

    final cardColor = isNext
        ? AppColors.softGreenGradient.colors.first.withValues(alpha: 0.55)
        : AppColors.white;

    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(ZiRadius.card),
      child: InkWell(
        onTap: onEditTap,
        borderRadius: BorderRadius.circular(ZiRadius.card),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: context.heightPct(0.075).clamp(62.0, 82.0),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(0.036),
            vertical: context.heightPct(0.012),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ZiRadius.card),
            border: Border.all(
              color: borderColor,
              width: isNext ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.025),
                blurRadius: 9,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isNext
                      ? AppColors.primary
                      : prayer.isCustomPrayer
                      ? AppColors.warning.withValues(alpha: 0.14)
                      : AppColors.softGreenGradient.colors.first,
                  borderRadius: BorderRadius.circular(ZiRadius.md),
                ),
                child: Icon(
                  _iconForPrayer(prayer),
                  color: isNext
                      ? AppColors.white
                      : prayer.isCustomPrayer
                      ? AppColors.warning
                      : isPassed
                      ? AppColors.textSecondary
                      : AppColors.primary,
                  size: 20,
                ),
              ),
              ziGap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Text(
                          prayer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isPassed && !isActive && !isNext
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            fontSize: context
                                .scaledFont(14.5)
                                .clamp(13.5, 17.0),
                            fontWeight: isNext || isActive
                                ? FontWeight.w700
                                : FontWeight.w600,
                          ),
                        ),
                        if (isNext)
                          const ZiBadge(
                            label: 'Next',
                            color: AppColors.primary,
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                          )
                        else if (isActive)
                          const ZiBadge(
                            label: 'Current',
                            color: AppColors.success,
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                          ),
                        if (prayer.isCustomPrayer)
                          const ZiBadge(
                            label: 'Custom',
                            color: AppColors.warning,
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                          )
                        else if (prayer.hasCustomTimeOverride)
                          const ZiBadge(
                            label: 'Edited',
                            color: AppColors.primaryLight,
                            padding: EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                          ),
                      ],
                    ),
                    if (_subtitleText != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _subtitleText!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: context
                              .scaledFont(11)
                              .clamp(10.0, 13.0),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              ziGap(8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    prayer.formattedTime(use24Hour),
                    style: ZiTypoStyles.noSm.copyWith(
                      color: isNext
                          ? AppColors.primaryDark
                          : isPassed && !isActive
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                      fontSize: context.scaledFont(13.5).clamp(12.5, 16.0),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (prayer.leadMinutes > 0 && prayer.isReminderEnabled.value)
                    Text(
                      '-${prayer.leadMinutes}m alert',
                      style: TextStyle(
                        color: AppColors.primaryLight,
                        fontSize: context.scaledFont(10).clamp(9.5, 12.0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
              ziGap(4),
              Obx(() {
                final enabled = prayer.isReminderEnabled.value;
                return IconButton(
                  tooltip: enabled
                      ? 'Mute ${prayer.name} alarm'
                      : 'Enable ${prayer.name} alarm',
                  onPressed: onSoundTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 36,
                    minHeight: 36,
                  ),
                  splashRadius: 20,
                  icon: Icon(
                    enabled
                        ? _alarmIconForMode(prayer.alarmMode)
                        : Icons.notifications_off_outlined,
                    color: enabled ? AppColors.primary : AppColors.error,
                    size: context.scaledFont(20).clamp(19.0, 24.0),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  String? get _subtitleText {
    if (prayer.note != null && prayer.note!.isNotEmpty) {
      return prayer.note;
    }
    if (!prayer.isPrayer) {
      return 'Sunrise • End of Fajr time';
    }
    return null;
  }

  IconData _alarmIconForMode(PrayerAlarmMode mode) {
    switch (mode) {
      case PrayerAlarmMode.alarm:
        return Icons.alarm_on_rounded;
      case PrayerAlarmMode.notification:
        return Icons.notifications_active_rounded;
      case PrayerAlarmMode.silent:
        return Icons.notifications_paused_rounded;
    }
  }

  IconData _iconForPrayer(PrayerTimeModel item) {
    if (item.isCustomPrayer) return Icons.star_rounded;
    switch (item.id) {
      case 'fajr':
        return Icons.wb_twilight_rounded;
      case 'sunrise':
        return Icons.wb_sunny_outlined;
      case 'dhuhr':
        return Icons.wb_sunny_rounded;
      case 'asr':
        return Icons.light_mode_rounded;
      case 'maghrib':
        return Icons.nights_stay_outlined;
      case 'isha':
        return Icons.bedtime_rounded;
      default:
        return Icons.mosque_rounded;
    }
  }
}
