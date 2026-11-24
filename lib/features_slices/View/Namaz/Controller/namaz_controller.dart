
import 'package:get/get.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import '../Model/prayer_time_model.dart';

class NamazController extends GetxController {
  final RxInt selectedDayIndex = 0.obs;
  final RxBool adhanEnabled = false.obs;

  final RxString cityName = 'Set your location'.obs;
  final RxString areaName = 'Prayer times for your area'.obs;

  late final List<DateTime> weekDays;

  // DEMO DATA ONLY:
  // Replace these times with calculated local prayer times
  // before publishing the app.
  final RxList<PrayerTimeModel> prayerTimes = <PrayerTimeModel>[
    PrayerTimeModel(
      name: 'Fajr',
      time: '05:12',
      reminderEnabled: true,
    ),
    PrayerTimeModel(
      name: 'Sunrise',
      time: '06:32',
      isPrayer: false,
      reminderEnabled: true,
    ),
    PrayerTimeModel(
      name: 'Dhuhr',
      time: '12:14',
      reminderEnabled: true,
    ),
    PrayerTimeModel(
      name: 'Asr',
      time: '15:05',
      reminderEnabled: false,
    ),
    PrayerTimeModel(
      name: 'Maghrib',
      time: '17:42',
      reminderEnabled: true,
    ),
    PrayerTimeModel(
      name: 'Isha',
      time: '19:03',
      reminderEnabled: true,
    ),
  ].obs;

  final String featuredPrayerName = 'Asr';
  final String featuredPrayerTime = '15:05 pm';

  @override
  void onInit() {
    super.onInit();
    _prepareWeekDays();
  }

  void _prepareWeekDays() {
    final today = DateTime.now();

    // Start the week on Monday.
    final monday = today.subtract(
      Duration(days: today.weekday - 1),
    );

    weekDays = List.generate(
      7,
      (index) => monday.add(Duration(days: index)),
    );

    selectedDayIndex.value = today.weekday - 1;
  }

  void selectDay(int index) {
    if (index < 0 || index >= weekDays.length) return;
    selectedDayIndex.value = index;
  }

  void toggleAdhan() {
    adhanEnabled.toggle();

    AppSnackbar.info(
      adhanEnabled.value
          ? 'Adhan notifications enabled'
          : 'Adhan notifications disabled',
    );
  }

  void togglePrayerReminder(PrayerTimeModel prayer) {
    prayer.isReminderEnabled.toggle();

    AppSnackbar.info(
      prayer.isReminderEnabled.value
          ? '${prayer.name} reminder enabled'
          : '${prayer.name} reminder disabled',
    );
  }

  void openLocationSettings() {
    AppSnackbar.info('Location settings will be available soon');
  }

  void openPrayerSettings() {
    AppSnackbar.info('Prayer settings will be available soon');
  }

  String weekdayShort(DateTime date) {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];

    return days[date.weekday - 1];
  }

  String weekdayLong(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return days[date.weekday - 1];
  }

  bool isToday(DateTime date) {
    final today = DateTime.now();

    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  String get selectedDateTitle {
    final date = weekDays[selectedDayIndex.value];
    return '${weekdayLong(date)}, ${date.day}';
  }
}
