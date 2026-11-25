import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/prayer_time_model.dart';
import '../Services/namaz_notification_service.dart';
import '../Services/namaz_time_calculator.dart';

class NamazController extends GetxController {
  NamazController({
    NamazNotificationService? notificationService,
    this.enableTicker = true,
  }) : _notificationService =
           notificationService ?? NamazNotificationService();

  final NamazNotificationService _notificationService;
  final bool enableTicker;

  // SharedPreferences keys
  static const _keyCityId = 'namaz_city_id';
  static const _keyCustomCityName = 'namaz_custom_city_name';
  static const _keyUseCustomCoords = 'namaz_use_custom_coords';
  static const _keyCustomLat = 'namaz_custom_lat';
  static const _keyCustomLng = 'namaz_custom_lng';
  static const _keyMethod = 'namaz_calc_method';
  static const _keyMadhab = 'namaz_madhab';
  static const _keyUse24Hour = 'namaz_use_24h';
  static const _keyAdhanEnabled = 'namaz_adhan_enabled';
  static const _keyAlarmMode = 'namaz_global_alarm_mode';
  static const _keyLeadMinutes = 'namaz_default_lead_minutes';
  static const _keyVibrate = 'namaz_vibrate_enabled';
  static const _keyReminderOverrides = 'namaz_reminder_overrides';
  static const _keyCustomTimeOverrides = 'namaz_custom_time_overrides';
  static const _keyLeadOverrides = 'namaz_lead_overrides';
  static const _keyAlarmModeOverrides = 'namaz_alarm_mode_overrides';
  static const _keyCustomPrayers = 'namaz_custom_prayers';

  // Reactive state
  final RxInt selectedDayIndex = 0.obs;
  final RxInt weekOffset = 0.obs;
  final RxList<DateTime> weekDays = <DateTime>[].obs;
  final Rx<DateTime> currentTime = DateTime.now().obs;

  final RxBool adhanEnabled = true.obs;
  final Rx<PrayerAlarmMode> globalAlarmMode = PrayerAlarmMode.alarm.obs;
  final RxInt defaultLeadMinutes = 0.obs;
  final RxBool vibrateEnabled = true.obs;
  final RxBool use24HourFormat = false.obs;
  final RxInt scheduledNotificationsCount = 0.obs;

  final RxString cityName = ''.obs;
  final RxString areaName = ''.obs;
  final RxString selectedCityId = ''.obs;
  final RxBool useCustomCoordinates = false.obs;
  final RxDouble latitude = 31.5204.obs;
  final RxDouble longitude = 74.3587.obs;
  final Rx<NamazCalculationPreset> calculationMethod =
      NamazCalculationPreset.karachi.obs;
  final Rx<NamazMadhab> madhab = NamazMadhab.hanafi.obs;

  final RxList<PrayerTimeModel> prayerTimes = <PrayerTimeModel>[].obs;
  final RxList<PrayerTimeModel> todayPrayerTimes = <PrayerTimeModel>[].obs;
  final RxList<PrayerTimeModel> tomorrowPrayerTimes = <PrayerTimeModel>[].obs;
  final RxList<CustomPrayerConfig> customPrayers = <CustomPrayerConfig>[].obs;

  final RxMap<String, bool> _reminderOverrides = <String, bool>{}.obs;
  final RxMap<String, TimeOfDay> _customTimeOverrides =
      <String, TimeOfDay>{}.obs;
  final RxMap<String, int> _leadMinuteOverrides = <String, int>{}.obs;
  final RxMap<String, PrayerAlarmMode> _alarmModeOverrides =
      <String, PrayerAlarmMode>{}.obs;

  final Rxn<PrayerTimeModel> activeForegroundAlarm = Rxn<PrayerTimeModel>();

  Timer? _ticker;
  final Set<String> _triggeredForegroundKeys = {};

  @override
  void onInit() {
    super.onInit();
    _applyDefaultCity();
    _prepareWeekDays(selectToday: true);
    recalculatePrayerTimes();
    _restorePreferencesAndSync();
  }

  void startLiveTicker() {
    if (!enableTicker) return;
    currentTime.value = DateTime.now();
    _startTicker();
  }

  void stopLiveTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  void refreshCurrentTime() {
    final now = DateTime.now();
    final previousDay = currentTime.value.day;
    currentTime.value = now;
    if (now.day != previousDay) {
      _triggeredForegroundKeys.clear();
      if (weekOffset.value == 0) {
        _prepareWeekDays(selectToday: true);
      }
      recalculatePrayerTimes();
      _rescheduleNotifications();
    }
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }

  void _applyDefaultCity() {
    final preset = NamazTimeCalculator.defaultCityForTimezone();
    selectedCityId.value = preset.id;
    cityName.value = preset.displayName;
    latitude.value = preset.latitude;
    longitude.value = preset.longitude;
    calculationMethod.value = preset.defaultMethod;
    madhab.value = preset.defaultMadhab;
    _updateAreaSummary();
  }

  void _updateAreaSummary() {
    areaName.value =
        '${calculationMethod.value.shortLabel} • ${madhab.value.label}';
  }

  void _prepareWeekDays({bool selectToday = false}) {
    final baseDay = DateTime.now().add(Duration(days: weekOffset.value * 7));
    final monday = DateTime(
      baseDay.year,
      baseDay.month,
      baseDay.day,
    ).subtract(Duration(days: baseDay.weekday - 1));

    weekDays.assignAll(
      List.generate(7, (index) => monday.add(Duration(days: index))),
    );

    if (selectToday) {
      selectedDayIndex.value = DateTime.now().weekday - 1;
    } else if (selectedDayIndex.value >= weekDays.length) {
      selectedDayIndex.value = 0;
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final previousDay = currentTime.value.day;
      currentTime.value = now;

      if (now.day != previousDay) {
        _triggeredForegroundKeys.clear();
        if (weekOffset.value == 0) {
          _prepareWeekDays(selectToday: true);
        }
        recalculatePrayerTimes();
        _rescheduleNotifications();
      }

      _checkForegroundAlarmTrigger(now);
    });
  }

  void _checkForegroundAlarmTrigger(DateTime now) {
    if (!adhanEnabled.value) return;

    for (final prayer in todayPrayerTimes) {
      if (!prayer.isReminderEnabled.value) continue;
      final trigger = prayer.dateTime.subtract(
        Duration(minutes: prayer.leadMinutes),
      );
      final diffSeconds = now.difference(trigger).inSeconds;
      if (diffSeconds >= 0 && diffSeconds < 45) {
        final key =
            '${now.year}-${now.month}-${now.day}:${prayer.id}:${trigger.hour}:${trigger.minute}';
        if (_triggeredForegroundKeys.add(key)) {
          activeForegroundAlarm.value = prayer;
        }
        break;
      }
    }
  }

  Future<void> _restorePreferencesAndSync() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final savedCustomCoords = prefs.getBool(_keyUseCustomCoords) ?? false;
      final savedCityId = prefs.getString(_keyCityId);
      final savedPreset = NamazTimeCalculator.findCityById(savedCityId);

      if (savedCustomCoords) {
        useCustomCoordinates.value = true;
        cityName.value =
            prefs.getString(_keyCustomCityName) ?? 'Custom Location';
        latitude.value = prefs.getDouble(_keyCustomLat) ?? latitude.value;
        longitude.value = prefs.getDouble(_keyCustomLng) ?? longitude.value;
      } else if (savedPreset != null) {
        useCustomCoordinates.value = false;
        selectedCityId.value = savedPreset.id;
        cityName.value = savedPreset.displayName;
        latitude.value = savedPreset.latitude;
        longitude.value = savedPreset.longitude;
      }

      final savedMethod = prefs.getString(_keyMethod);
      if (savedMethod != null) {
        calculationMethod.value = NamazCalculationPreset.fromName(savedMethod);
      } else if (savedPreset != null) {
        calculationMethod.value = savedPreset.defaultMethod;
      }

      final savedMadhab = prefs.getString(_keyMadhab);
      if (savedMadhab != null) {
        madhab.value = NamazMadhab.fromName(savedMadhab);
      } else if (savedPreset != null) {
        madhab.value = savedPreset.defaultMadhab;
      }

      use24HourFormat.value = prefs.getBool(_keyUse24Hour) ?? false;
      adhanEnabled.value = prefs.getBool(_keyAdhanEnabled) ?? true;
      globalAlarmMode.value = PrayerAlarmMode.fromName(
        prefs.getString(_keyAlarmMode),
      );
      defaultLeadMinutes.value = prefs.getInt(_keyLeadMinutes) ?? 0;
      vibrateEnabled.value = prefs.getBool(_keyVibrate) ?? true;

      _decodeReminderOverrides(prefs.getString(_keyReminderOverrides));
      _decodeCustomTimeOverrides(prefs.getString(_keyCustomTimeOverrides));
      _decodeLeadOverrides(prefs.getString(_keyLeadOverrides));
      _decodeAlarmModeOverrides(prefs.getString(_keyAlarmModeOverrides));
      _decodeCustomPrayers(prefs.getString(_keyCustomPrayers));

      _updateAreaSummary();
      recalculatePrayerTimes();

      await _notificationService.init(
        onNotificationTap: (_) {
          // Notification tapped; refresh UI state
          recalculatePrayerTimes();
        },
      );
      await _rescheduleNotifications();
    } catch (error, stackTrace) {
      debugPrint('Failed to restore Namaz preferences: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  void _decodeReminderOverrides(String? raw) {
    if (raw == null || raw.isEmpty) return;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      _reminderOverrides.assignAll(
        decoded.map((k, v) => MapEntry(k, v == true)),
      );
    }
  }

  void _decodeCustomTimeOverrides(String? raw) {
    if (raw == null || raw.isEmpty) return;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      final result = <String, TimeOfDay>{};
      decoded.forEach((key, value) {
        if (value is String && value.contains(':')) {
          final parts = value.split(':');
          final hour = int.tryParse(parts[0]);
          final minute = int.tryParse(parts[1]);
          if (hour != null &&
              minute != null &&
              hour >= 0 &&
              hour <= 23 &&
              minute >= 0 &&
              minute <= 59) {
            result[key] = TimeOfDay(hour: hour, minute: minute);
          }
        }
      });
      _customTimeOverrides.assignAll(result);
    }
  }

  void _decodeLeadOverrides(String? raw) {
    if (raw == null || raw.isEmpty) return;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      _leadMinuteOverrides.assignAll(
        decoded.map((k, v) => MapEntry(k, (v as num?)?.toInt() ?? 0)),
      );
    }
  }

  void _decodeAlarmModeOverrides(String? raw) {
    if (raw == null || raw.isEmpty) return;
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      _alarmModeOverrides.assignAll(
        decoded.map(
          (k, v) => MapEntry(k, PrayerAlarmMode.fromName(v?.toString())),
        ),
      );
    }
  }

  void _decodeCustomPrayers(String? raw) {
    if (raw == null || raw.isEmpty) return;
    final decoded = jsonDecode(raw);
    if (decoded is List) {
      customPrayers.assignAll(
        decoded
            .whereType<Map<String, dynamic>>()
            .map(CustomPrayerConfig.fromJson)
            .where((item) => item.id.isNotEmpty)
            .toList(),
      );
    }
  }

  Future<void> _persistPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyCityId, selectedCityId.value);
      await prefs.setBool(_keyUseCustomCoords, useCustomCoordinates.value);
      await prefs.setString(_keyCustomCityName, cityName.value);
      await prefs.setDouble(_keyCustomLat, latitude.value);
      await prefs.setDouble(_keyCustomLng, longitude.value);
      await prefs.setString(_keyMethod, calculationMethod.value.name);
      await prefs.setString(_keyMadhab, madhab.value.name);
      await prefs.setBool(_keyUse24Hour, use24HourFormat.value);
      await prefs.setBool(_keyAdhanEnabled, adhanEnabled.value);
      await prefs.setString(_keyAlarmMode, globalAlarmMode.value.name);
      await prefs.setInt(_keyLeadMinutes, defaultLeadMinutes.value);
      await prefs.setBool(_keyVibrate, vibrateEnabled.value);

      await prefs.setString(
        _keyReminderOverrides,
        jsonEncode(_reminderOverrides),
      );
      await prefs.setString(
        _keyCustomTimeOverrides,
        jsonEncode(
          _customTimeOverrides.map(
            (k, v) => MapEntry(k, '${v.hour}:${v.minute}'),
          ),
        ),
      );
      await prefs.setString(_keyLeadOverrides, jsonEncode(_leadMinuteOverrides));
      await prefs.setString(
        _keyAlarmModeOverrides,
        jsonEncode(
          _alarmModeOverrides.map((k, v) => MapEntry(k, v.name)),
        ),
      );
      await prefs.setString(
        _keyCustomPrayers,
        jsonEncode(customPrayers.map((p) => p.toJson()).toList()),
      );
    } catch (error) {
      debugPrint('Failed to save Namaz preferences: $error');
    }
  }

  List<PrayerTimeModel> buildPrayersForDate(DateTime date) {
    return NamazTimeCalculator.calculateDailyPrayers(
      date: date,
      latitude: latitude.value,
      longitude: longitude.value,
      method: calculationMethod.value,
      madhab: madhab.value,
      customTimeOverrides: _customTimeOverrides,
      reminderOverrides: _reminderOverrides,
      leadMinuteOverrides: _leadMinuteOverrides,
      alarmModeOverrides: _alarmModeOverrides,
      defaultAlarmMode: globalAlarmMode.value,
      defaultLeadMinutes: defaultLeadMinutes.value,
      customPrayers: customPrayers,
    );
  }

  void recalculatePrayerTimes() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    todayPrayerTimes.assignAll(buildPrayersForDate(today));
    tomorrowPrayerTimes.assignAll(buildPrayersForDate(tomorrow));
    prayerTimes.assignAll(buildPrayersForDate(selectedDate));
  }

  Future<void> _rescheduleNotifications() async {
    final count = await _notificationService.scheduleUpcomingDays(
      masterEnabled: adhanEnabled.value,
      prayersForDate: buildPrayersForDate,
      use24Hour: use24HourFormat.value,
      vibrate: vibrateEnabled.value,
    );
    scheduledNotificationsCount.value = count;
  }

  // Week navigation
  void selectDay(int index) {
    if (index < 0 || index >= weekDays.length) return;
    selectedDayIndex.value = index;
    recalculatePrayerTimes();
  }

  void previousWeek() {
    weekOffset.value--;
    _prepareWeekDays();
    recalculatePrayerTimes();
  }

  void nextWeek() {
    weekOffset.value++;
    _prepareWeekDays();
    recalculatePrayerTimes();
  }

  void goToToday() {
    weekOffset.value = 0;
    _prepareWeekDays(selectToday: true);
    recalculatePrayerTimes();
  }

  // Next / Active prayer computations
  DateTime get selectedDate {
    if (weekDays.isEmpty) return DateTime.now();
    return weekDays[selectedDayIndex.value.clamp(0, weekDays.length - 1)];
  }

  bool get isViewingToday => isToday(selectedDate);

  PrayerTimeModel? get nextPrayer {
    final now = currentTime.value;
    for (final prayer in todayPrayerTimes) {
      if (prayer.isPrayer && prayer.dateTime.isAfter(now)) {
        return prayer;
      }
    }
    for (final prayer in tomorrowPrayerTimes) {
      if (prayer.isPrayer) {
        return prayer;
      }
    }
    return null;
  }

  PrayerTimeModel? get previousPrayer {
    final now = currentTime.value;
    PrayerTimeModel? latest;
    for (final prayer in todayPrayerTimes) {
      if (prayer.isPrayer && !prayer.dateTime.isAfter(now)) {
        latest = prayer;
      }
    }
    if (latest != null) return latest;

    // Before Fajr today -> use yesterday's last prayer
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final yesterdayList = buildPrayersForDate(yesterday).where((p) => p.isPrayer);
    return yesterdayList.isEmpty ? null : yesterdayList.last;
  }

  bool get isNextPrayerTomorrow {
    final next = nextPrayer;
    if (next == null) return false;
    return !isToday(next.dateTime);
  }

  String get featuredPrayerName => nextPrayer?.name ?? 'Fajr';

  String get featuredPrayerTime {
    final next = nextPrayer;
    if (next == null) return '--:--';
    return next.formattedTime(use24HourFormat.value);
  }

  Duration get timeUntilNextPrayer {
    final next = nextPrayer;
    if (next == null) return Duration.zero;
    final diff = next.dateTime.difference(currentTime.value);
    return diff.isNegative ? Duration.zero : diff;
  }

  String get nextPrayerCountdown {
    final d = timeUntilNextPrayer;
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}h '
          '${minutes.toString().padLeft(2, '0')}m '
          '${seconds.toString().padLeft(2, '0')}s';
    }
    return '${minutes.toString().padLeft(2, '0')}m '
        '${seconds.toString().padLeft(2, '0')}s';
  }

  double get nextPrayerProgress {
    final prev = previousPrayer;
    final next = nextPrayer;
    if (prev == null || next == null) return 0.0;
    final total = next.dateTime.difference(prev.dateTime).inSeconds;
    if (total <= 0) return 0.0;
    final elapsed = currentTime.value.difference(prev.dateTime).inSeconds;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  String? get currentActivePrayerId {
    if (!isViewingToday) return null;
    final now = currentTime.value;
    PrayerTimeModel? latest;
    for (final prayer in prayerTimes) {
      if (prayer.isPrayer && !prayer.dateTime.isAfter(now)) {
        latest = prayer;
      }
    }
    return latest?.id;
  }

  String? get nextUpcomingPrayerId {
    if (!isViewingToday) return null;
    final next = nextPrayer;
    if (next == null || !isToday(next.dateTime)) return null;
    return next.id;
  }

  bool isPrayerPassed(PrayerTimeModel prayer) {
    if (!isViewingToday) return false;
    return prayer.dateTime.isBefore(currentTime.value);
  }

  int get enabledAlarmsCount =>
      prayerTimes.where((prayer) => prayer.isReminderEnabled.value).length;

  void _showSuccess(String message) {
    if (Get.context == null) return;
    AppSnackbar.success(message);
  }

  void _showInfo(String message) {
    if (Get.context == null) return;
    AppSnackbar.info(message);
  }

  void _showWarning(String message) {
    if (Get.context == null) return;
    AppSnackbar.warning(message);
  }

  // Custom prayers & timing overrides
  Future<void> addCustomPrayer({
    required String name,
    required TimeOfDay time,
    String? note,
    bool reminderEnabled = true,
    int leadMinutes = 0,
    PrayerAlarmMode? alarmMode,
  }) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      _showWarning('Please enter a prayer name');
      return;
    }

    final trimmedNote = note?.trim();
    final id = 'custom_${DateTime.now().microsecondsSinceEpoch}';
    final entry = CustomPrayerConfig(
      id: id,
      name: trimmedName,
      hour: time.hour,
      minute: time.minute,
      note: (trimmedNote == null || trimmedNote.isEmpty) ? null : trimmedNote,
      reminderEnabled: reminderEnabled,
      leadMinutes: leadMinutes,
      alarmMode: alarmMode ?? globalAlarmMode.value,
    );

    customPrayers.add(entry);
    _reminderOverrides[id] = reminderEnabled;
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
    _showSuccess('$trimmedName added to prayer schedule');
  }

  Future<void> updatePrayerTiming(
    PrayerTimeModel prayer, {
    String? name,
    required TimeOfDay time,
    String? note,
    bool? reminderEnabled,
    int? leadMinutes,
    PrayerAlarmMode? alarmMode,
  }) async {
    final enabled = reminderEnabled ?? prayer.isReminderEnabled.value;
    final lead = leadMinutes ?? prayer.leadMinutes;
    final mode = alarmMode ?? prayer.alarmMode;
    final trimmedNote = note?.trim();

    if (prayer.isCustomPrayer) {
      final index = customPrayers.indexWhere((c) => c.id == prayer.id);
      if (index != -1) {
        final nextName = (name?.trim().isNotEmpty ?? false)
            ? name!.trim()
            : customPrayers[index].name;
        customPrayers[index] = customPrayers[index].copyWith(
          name: nextName,
          hour: time.hour,
          minute: time.minute,
          note: (trimmedNote == null || trimmedNote.isEmpty) ? null : trimmedNote,
          clearNote: trimmedNote == null || trimmedNote.isEmpty,
          reminderEnabled: enabled,
          leadMinutes: lead,
          alarmMode: mode,
        );
      }
    } else {
      _customTimeOverrides[prayer.id] = time;
      _leadMinuteOverrides[prayer.id] = lead;
      _alarmModeOverrides[prayer.id] = mode;
    }

    _reminderOverrides[prayer.id] = enabled;
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
    _showSuccess(
      '${name?.trim().isNotEmpty == true ? name!.trim() : prayer.name} timing updated',
    );
  }

  Future<void> resetPrayerToAuto(PrayerTimeModel prayer) async {
    if (prayer.isCustomPrayer) return;
    _customTimeOverrides.remove(prayer.id);
    _leadMinuteOverrides.remove(prayer.id);
    _alarmModeOverrides.remove(prayer.id);
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
    _showInfo('${prayer.name} reset to daily calculated timing');
  }

  Future<void> deleteCustomPrayer(PrayerTimeModel prayer) async {
    if (!prayer.isCustomPrayer) return;
    customPrayers.removeWhere((item) => item.id == prayer.id);
    _reminderOverrides.remove(prayer.id);
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
    _showInfo('${prayer.name} removed');
  }

  // Alarm & notification controls
  Future<void> toggleAdhan() async {
    final nextValue = !adhanEnabled.value;
    if (nextValue) {
      await _notificationService.requestPermissions();
    }
    adhanEnabled.value = nextValue;
    await _persistPreferences();
    await _rescheduleNotifications();

    _showInfo(
      adhanEnabled.value
          ? 'Namaz alarms & notifications enabled'
          : 'Namaz alarms & notifications paused',
    );
  }

  Future<void> togglePrayerReminder(PrayerTimeModel prayer) async {
    final next = !prayer.isReminderEnabled.value;
    prayer.isReminderEnabled.value = next;
    _reminderOverrides[prayer.id] = next;

    if (prayer.isCustomPrayer) {
      final index = customPrayers.indexWhere((c) => c.id == prayer.id);
      if (index != -1) {
        customPrayers[index] = customPrayers[index].copyWith(
          reminderEnabled: next,
        );
      }
    }

    if (next && adhanEnabled.value) {
      await _notificationService.requestPermissions();
    }

    await _persistPreferences();
    await _rescheduleNotifications();

    _showInfo(
      next
          ? '${prayer.name} alarm enabled'
          : '${prayer.name} alarm muted',
    );
  }

  Future<void> setGlobalAlarmMode(PrayerAlarmMode mode) async {
    globalAlarmMode.value = mode;
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
  }

  Future<void> setDefaultLeadMinutes(int minutes) async {
    defaultLeadMinutes.value = minutes;
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
  }

  Future<void> setVibrateEnabled(bool enabled) async {
    vibrateEnabled.value = enabled;
    await _persistPreferences();
    await _rescheduleNotifications();
  }

  Future<void> testAlarmNotification() async {
    await _notificationService.requestPermissions();
    final sent = await _notificationService.showTestAlarm(
      mode: globalAlarmMode.value,
      vibrate: vibrateEnabled.value,
    );
    if (sent) {
      _showSuccess('Test prayer notification sent');
    } else {
      // Fallback preview inside app when platform notifications aren't active (e.g. web/test)
      activeForegroundAlarm.value = nextPrayer ??
          (prayerTimes.isNotEmpty ? prayerTimes.first : null);
    }
  }

  Future<void> snoozeForegroundAlarm({int minutes = 5}) async {
    final prayer = activeForegroundAlarm.value;
    activeForegroundAlarm.value = null;
    if (prayer == null) return;
    await _notificationService.scheduleSnooze(
      prayerName: prayer.name,
      mode: prayer.alarmMode,
      vibrate: vibrateEnabled.value,
      minutes: minutes,
    );
    _showInfo('${prayer.name} snoozed for $minutes minutes');
  }

  void dismissForegroundAlarm() {
    activeForegroundAlarm.value = null;
  }

  // Location & Calculation settings
  Future<void> selectCityPreset(NamazCityPreset preset) async {
    useCustomCoordinates.value = false;
    selectedCityId.value = preset.id;
    cityName.value = preset.displayName;
    latitude.value = preset.latitude;
    longitude.value = preset.longitude;
    calculationMethod.value = preset.defaultMethod;
    madhab.value = preset.defaultMadhab;
    _updateAreaSummary();
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
    _showSuccess('Prayer times updated for ${preset.city}');
  }

  Future<void> setCustomCoordinates({
    required String cityLabel,
    required double lat,
    required double lng,
  }) async {
    useCustomCoordinates.value = true;
    selectedCityId.value = 'custom';
    cityName.value = cityLabel.trim().isEmpty
        ? 'Custom (${lat.toStringAsFixed(2)}, ${lng.toStringAsFixed(2)})'
        : cityLabel.trim();
    latitude.value = lat.clamp(-90.0, 90.0);
    longitude.value = lng.clamp(-180.0, 180.0);
    _updateAreaSummary();
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
    _showSuccess('Custom coordinates applied');
  }

  Future<void> setCalculationMethod(NamazCalculationPreset method) async {
    calculationMethod.value = method;
    _updateAreaSummary();
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
  }

  Future<void> setMadhab(NamazMadhab value) async {
    madhab.value = value;
    _updateAreaSummary();
    recalculatePrayerTimes();
    await _persistPreferences();
    await _rescheduleNotifications();
  }

  Future<void> toggleTimeFormat(bool use24Hour) async {
    use24HourFormat.value = use24Hour;
    await _persistPreferences();
    await _rescheduleNotifications();
  }

  // Formatting helpers
  String weekdayShort(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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

  String monthShort(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(month - 1).clamp(0, 11)];
  }

  bool isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  }

  String get selectedDateTitle {
    final date = selectedDate;
    return '${weekdayLong(date)}, ${date.day} ${monthShort(date.month)}';
  }

  String get selectedFullDateSubtitle {
    final date = selectedDate;
    return '${weekdayLong(date)}, ${date.day} ${monthShort(date.month)} ${date.year}';
  }
}
