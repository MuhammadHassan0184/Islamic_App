
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Namaz/Controller/namaz_controller.dart';
import 'package:islam786/features_slices/View/Namaz/Widgets/namaz_location_header.dart';
import 'package:islam786/features_slices/View/Namaz/Widgets/namaz_week_strip.dart';
import 'package:islam786/features_slices/View/Namaz/Widgets/next_prayer_card.dart';
import 'package:islam786/features_slices/View/Namaz/Widgets/prayer_time_tile.dart';

class NamazScreen extends GetView<NamazController> {
  const NamazScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFDFC),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Namaz',
          style: TextStyle(
            color: AppColors.white,
            fontSize: context.scaledFont(18),
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: context.responsivePadding(
            horizontal: 0.055,
            vertical: 0.018,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NamazLocationHeader(controller: controller),

              // SizedBox(height: context.heightPct(0.022)),

              NamazWeekStrip(controller: controller),

              SizedBox(height: context.heightPct(0.035)),

              NextPrayerCard(controller: controller),

              SizedBox(height: context.heightPct(0.028)),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Prayer Times',
                    style: TextStyle(
                      color: const Color(0xFF173F35),
                      fontSize: context.scaledFont(17),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Obx(
                    () => Text(
                      controller.selectedDateTitle,
                      style: TextStyle(
                        color: const Color(0xFF89958F),
                        fontSize: context.scaledFont(11),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: context.heightPct(0.014)),

              Obx(
                () => Column(
                  children: controller.prayerTimes.map((prayer) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: context.heightPct(0.012),
                      ),
                      child: PrayerTimeTile(
                        prayer: prayer,
                        onSoundTap: () {
                          controller.togglePrayerReminder(prayer);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: context.heightPct(0.025)),
            ],
          ),
        ),
      ),
    );
  }
}
