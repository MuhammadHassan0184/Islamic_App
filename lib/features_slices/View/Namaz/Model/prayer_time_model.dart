
import 'package:get/get.dart';

class PrayerTimeModel {
  final String name;
  final String time;
  final bool isPrayer;
  final RxBool isReminderEnabled;

  PrayerTimeModel({
    required this.name,
    required this.time,
    this.isPrayer = true,
    bool reminderEnabled = true,
  }) : isReminderEnabled = reminderEnabled.obs;
}
