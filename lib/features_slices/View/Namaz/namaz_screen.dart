import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Namaz/Controller/namaz_controller.dart';
import 'package:islam786/features_slices/View/Namaz/Widgets/namaz_header.dart';
import 'package:islam786/features_slices/View/Namaz/Widgets/namaz_sheets.dart';
import 'package:islam786/features_slices/View/Namaz/Widgets/namaz_week_strip.dart';
import 'package:islam786/features_slices/View/Namaz/Widgets/next_prayer_card.dart';
import 'package:islam786/features_slices/View/Namaz/Widgets/prayer_time_tile.dart';
import 'package:zi_core/zi_core_io.dart';

class NamazScreen extends StatefulWidget {
  const NamazScreen({super.key});

  @override
  State<NamazScreen> createState() => _NamazScreenState();
}

class _NamazScreenState extends State<NamazScreen> with WidgetsBindingObserver {
  late final NamazController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    controller = Get.find<NamazController>();
    controller.startLiveTicker();

    /*
    // Commented out: Alarm system dialog disabled, using notifications only
    _alarmWorker = ever(controller.activeForegroundAlarm, (prayer) {
      if (!mounted || prayer == null || _isAlarmDialogOpen) return;
      _isAlarmDialogOpen = true;
      showForegroundPrayerAlarmDialog(context, controller, prayer).whenComplete(
        () {
          _isAlarmDialogOpen = false;
          if (controller.activeForegroundAlarm.value?.id == prayer.id) {
            controller.dismissForegroundAlarm();
          }
        },
      );
    });
    */
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.refreshCurrentTime();
      controller.checkExactAlarmPermission();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.stopLiveTicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Home_bg_image.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: AppColors.background);
            },
          ),
          Column(
            children: [
              NamazHeader(
                controller: controller,
                onAlarmSettingsTap: () =>
                    showAlarmSettingsSheet(context, controller),
                onCalculationSettingsTap: () =>
                    showCalculationSettingsSheet(context, controller),
              ),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: context.isDesktop ? 1040 : 820,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: context.responsivePadding(
                          horizontal: context.isMobile ? 0.048 : 0.035,
                          vertical: 0.018,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: context.heightPct(0.016)),

                            NamazWeekStrip(controller: controller),
                            /*
                            // Commented out: Exact Alarm Permission banner hidden (alarm system disabled, notifications used)
                            Obx(() {
                              if (controller.canScheduleExactAlarms.value) {
                                return const SizedBox.shrink();
                              }
                              return Container(
                                margin: EdgeInsets.only(
                                  top: context.heightPct(0.016),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.warning.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(ZiRadius.md),
                                  border: Border.all(
                                    color: AppColors.warning.withValues(alpha: 0.35),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.alarm_off_rounded,
                                      color: AppColors.warning,
                                      size: 26,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Alarms & Reminders Permission Needed',
                                            style: TextStyle(
                                              fontSize: context
                                                  .scaledFont(13)
                                                  .clamp(12.0, 15.0),
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            'Required on Android 12+ for prayer alarms to wake your phone and ring on time when screen is off.',
                                            style: TextStyle(
                                              fontSize: context
                                                  .scaledFont(11)
                                                  .clamp(10.5, 13.0),
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ZiButtonB(
                                      variant: ZiButtonVariantB.primary,
                                      label: 'Allow',
                                      style: ZiButtonStyleB(
                                        height: 34,
                                        backgroundColor: AppColors.warning,
                                        foregroundColor: AppColors.white,
                                        borderRadius: BorderRadius.circular(
                                          ZiRadius.sm,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                      ),
                                      action: controller.requestExactAlarmPermission,
                                    ),
                                  ],
                                ),
                              );
                            }),
                            */
                            SizedBox(height: context.heightPct(0.024)),

                            // Section Header + Add Custom Timing Button
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Prayer Times',
                                        style: TextStyle(
                                          color: AppColors.darkGreen,
                                          fontSize: context
                                              .scaledFont(17)
                                              .clamp(16.0, 21.0),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      Obx(
                                        () => Text(
                                          controller.selectedDateTitle,
                                          style: TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: context
                                                .scaledFont(11.5)
                                                .clamp(11.0, 14.0),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ZiButtonB(
                                  variant: ZiButtonVariantB.primary,
                                  icon: const Icon(
                                    Icons.add_alarm_rounded,
                                    color: AppColors.white,
                                    size: 17,
                                  ),
                                  label: 'Add Custom',
                                  style: ZiButtonStyleB(
                                    height: 38,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: AppColors.white,
                                    borderRadius: BorderRadius.circular(
                                      ZiRadius.md,
                                    ),
                                    textStyle: TextStyle(
                                      color: AppColors.white,
                                      fontSize: context
                                          .scaledFont(12.5)
                                          .clamp(12.0, 14.0),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  action: () => showAddOrEditPrayerSheet(
                                    context,
                                    controller,
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: context.heightPct(0.014)),

                            // Responsive Prayer Times list / grid
                            Obx(() {
                              final items = controller.prayerTimes;
                              final use24h = controller.use24HourFormat.value;
                              final nextId = controller.nextUpcomingPrayerId;
                              final activeId = controller.currentActivePrayerId;
                              // Subscribe to currentTime so passed/active states refresh
                              controller.currentTime.value;

                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  final twoColumn = constraints.maxWidth >= 640;

                                  if (!twoColumn) {
                                    return Column(
                                      children: items.map((prayer) {
                                        return Padding(
                                          padding: EdgeInsets.only(
                                            bottom: context.heightPct(0.011),
                                          ),
                                          child: PrayerTimeTile(
                                            prayer: prayer,
                                            use24Hour: use24h,
                                            isNext: prayer.id == nextId,
                                            isActive: prayer.id == activeId,
                                            isPassed: controller.isPrayerPassed(
                                              prayer,
                                            ),
                                            onSoundTap: () => controller
                                                .togglePrayerReminder(prayer),
                                            onEditTap: () =>
                                                showAddOrEditPrayerSheet(
                                                  context,
                                                  controller,
                                                  existingPrayer: prayer,
                                                ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }

                                  final tileWidth =
                                      (constraints.maxWidth - 12) / 2;
                                  return Wrap(
                                    spacing: 12,
                                    runSpacing: 12,
                                    children: items.map((prayer) {
                                      return SizedBox(
                                        width: tileWidth,
                                        child: PrayerTimeTile(
                                          prayer: prayer,
                                          use24Hour: use24h,
                                          isNext: prayer.id == nextId,
                                          isActive: prayer.id == activeId,
                                          isPassed: controller.isPrayerPassed(
                                            prayer,
                                          ),
                                          onSoundTap: () => controller
                                              .togglePrayerReminder(prayer),
                                          onEditTap: () =>
                                              showAddOrEditPrayerSheet(
                                                context,
                                                controller,
                                                existingPrayer: prayer,
                                              ),
                                        ),
                                      );
                                    }).toList(),
                                  );
                                },
                              );
                            }),

                            SizedBox(height: context.heightPct(0.012)),

                            // Subtle tip banner for customizing timings
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(
                                  ZiRadius.md,
                                ),
                                border: Border.all(color: AppColors.cardBorder),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.touch_app_outlined,
                                    size: 18,
                                    color: AppColors.primary,
                                  ),
                                  ziGap(10),
                                  Expanded(
                                    child: Text(
                                      'Tap any prayer to customize its timing or lead alarm, or add your own custom Namaz.',
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: context
                                            .scaledFont(11.5)
                                            .clamp(11.0, 13.5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: context.heightPct(0.018)),

                            NextPrayerCard(
                              controller: controller,
                              onAlarmModeTap: () =>
                                  showAlarmSettingsSheet(context, controller),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
