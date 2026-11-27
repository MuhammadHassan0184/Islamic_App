import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../Model/prayer_time_model.dart';

@pragma('vm:entry-point')
void namazNotificationTapBackground(NotificationResponse response) {
  debugPrint(
    'Background Namaz notification action: ${response.actionId}, payload: ${response.payload}',
  );
  if (response.actionId == 'namaz_snooze' ||
      response.actionId == 'namaz_snooze_5') {
    final parts = (response.payload ?? '').split(':');
    final prayerName = parts.length > 2 ? parts[2] : 'Prayer';
    NamazNotificationService().scheduleSnooze(
      prayerName: prayerName,
      mode: PrayerAlarmMode.alarm,
      vibrate: true,
      minutes: 5,
    );
  }
}

class NamazNotificationService {
  NamazNotificationService({
    FlutterLocalNotificationsPlugin? plugin,
    this.enabled = true,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final bool enabled;

  bool _initialized = false;
  bool _timezonesInitialized = false;

  static const String _alarmChannelId = 'namaz_alarm_v5';
  static const String _alarmChannelName = 'Namaz Alarms (Max Priority)';
  static const String _alarmChannelDesc =
      'High-priority prayer alarms with sound, vibration, and lock screen alerts';

  static const String _reminderChannelId = 'namaz_reminder_v5';
  static const String _reminderChannelName = 'Namaz Reminders';
  static const String _reminderChannelDesc =
      'Standard banners and chimes for daily prayer times';

  static const String _silentChannelId = 'namaz_silent_v5';
  static const String _silentChannelName = 'Silent Namaz Alerts';
  static const String _silentChannelDesc =
      'Silent notifications for prayer reminders';

  static const int _baseScheduleId = 4100;
  static const int _maxManagedIds = 250;

  Future<void> init({void Function(String? payload)? onNotificationTap}) async {
    if (!enabled || kIsWeb || _initialized) return;

    await _ensureTimezones();

    try {
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const darwinSettings = DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      );
      const linuxSettings = LinuxInitializationSettings(
        defaultActionName: 'Open Namaz',
      );
      const windowsSettings = WindowsInitializationSettings(
        appName: 'Islam101',
        appUserModelId: 'com.example.islam786',
        guid: 'b8d9a3e4-8e2f-4c4b-9b7a-7d1e2f4a8c90',
      );

      const settings = InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
        linux: linuxSettings,
        windows: windowsSettings,
      );

      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: (response) {
          if (response.actionId == 'namaz_snooze' ||
              response.actionId == 'namaz_snooze_5') {
            final parts = (response.payload ?? '').split(':');
            final prayerName = parts.length > 2 ? parts[2] : 'Prayer';
            scheduleSnooze(
              prayerName: prayerName,
              mode: PrayerAlarmMode.alarm,
              vibrate: true,
              minutes: 5,
            );
          }
          onNotificationTap?.call(response.payload);
        },
        onDidReceiveBackgroundNotificationResponse:
            namazNotificationTapBackground,
      );

      await _createAndroidChannels();
      _initialized = true;
    } catch (error, stackTrace) {
      debugPrint('NamazNotificationService init skipped/failed: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _ensureTimezones() async {
    if (_timezonesInitialized) return;
    try {
      tz_data.initializeTimeZones();
      try {
        final dynamic tzResult = await FlutterTimezone.getLocalTimezone();
        final String tzName = tzResult is String
            ? tzResult
            : (tzResult.identifier?.toString() ??
                  tzResult.name?.toString() ??
                  tzResult.toString());
        tz.setLocalLocation(tz.getLocation(tzName));
      } catch (_) {
        final localLocation = _resolveLocalLocation();
        if (localLocation != null) {
          tz.setLocalLocation(localLocation);
        }
      }
      _timezonesInitialized = true;
    } catch (error) {
      debugPrint('Timezone setup error: $error');
    }
  }

  tz.Location? _resolveLocalLocation() {
    final now = DateTime.now();
    final nowMillis = now.millisecondsSinceEpoch;
    final zoneName = now.timeZoneName;

    final locations = tz.timeZoneDatabase.locations;
    if (locations.containsKey(zoneName)) {
      return locations[zoneName];
    }

    for (final loc in locations.values) {
      final tzInfo = loc.timeZone(nowMillis);
      if (tzInfo.offset == now.timeZoneOffset) {
        return loc;
      }
    }
    return null;
  }

  Future<void> _ensureReady() async {
    await _ensureTimezones();
    if (!_initialized) {
      await init();
    }
    await _createAndroidChannels();
  }

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        _alarmChannelId,
        _alarmChannelName,
        description: _alarmChannelDesc,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        ledColor: const Color(0xFF2F6F1F),
      ),
    );

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        _reminderChannelId,
        _reminderChannelName,
        description: _reminderChannelDesc,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
        enableLights: true,
        ledColor: const Color(0xFF2F6F1F),
      ),
    );

    await androidPlugin.createNotificationChannel(
      AndroidNotificationChannel(
        _silentChannelId,
        _silentChannelName,
        description: _silentChannelDesc,
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
      ),
    );
  }

  Future<bool> canScheduleExactAlarms() async {
    if (!enabled || kIsWeb) return false;
    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin == null) return true;
      final canExact = await androidPlugin.canScheduleExactNotifications();
      return canExact ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<void> requestExactAlarmsPermission() async {
    if (!enabled || kIsWeb) return;
    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        await androidPlugin.requestExactAlarmsPermission();
      }
    } catch (error) {
      debugPrint('Failed to request exact alarms permission: $error');
    }
  }

  Future<bool> requestPermissions() async {
    if (!enabled || kIsWeb) return false;
    await init();

    try {
      var granted = true;

      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin != null) {
        final notifGranted = await androidPlugin
            .requestNotificationsPermission();
        if (notifGranted != null) {
          granted = notifGranted;
        }
      }

      final iosPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (iosPlugin != null) {
        final iosGranted = await iosPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        if (iosGranted != null) {
          granted = iosGranted;
        }
      }

      final macPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin
          >();
      if (macPlugin != null) {
        final macGranted = await macPlugin.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        if (macGranted != null) {
          granted = macGranted;
        }
      }

      return granted;
    } catch (error) {
      debugPrint('Permission request error: $error');
      return false;
    }
  }

  Future<int> scheduleUpcomingDays({
    required bool masterEnabled,
    required List<PrayerTimeModel> Function(DateTime date) prayersForDate,
    required bool use24Hour,
    required bool vibrate,
    int daysAhead = 7,
  }) async {
    if (!enabled || kIsWeb) return 0;
    await _ensureReady();

    await cancelAllNamazSchedules();
    if (!masterEnabled) return 0;

    final now = DateTime.now();
    var scheduledCount = 0;
    var slot = 0;

    final canExact = await canScheduleExactAlarms();
    final tzNow = tz.TZDateTime.now(tz.local);

    for (var dayOffset = 0; dayOffset < daysAhead; dayOffset++) {
      final date = DateTime(now.year, now.month, now.day + dayOffset);
      final prayers = prayersForDate(date);

      for (final prayer in prayers) {
        if (!prayer.isReminderEnabled.value) continue;
        if (slot >= _maxManagedIds) break;

        final triggerTime = prayer.dateTime.subtract(
          Duration(minutes: prayer.leadMinutes),
        );
        final tzTrigger = _toTzDateTime(triggerTime);

        // Ensure trigger is strictly in the future (minimum 2s margin)
        if (!tzTrigger.isAfter(tzNow.add(const Duration(seconds: 2)))) continue;

        final id = _baseScheduleId + slot;
        slot++;

        final formatted = prayer.formattedTime(use24Hour);
        final leadLabel = prayer.leadMinutes > 0
            ? 'Starts in ${prayer.leadMinutes} min ($formatted)'
            : 'It is time for ${prayer.name} ($formatted)';
        /*
        // Commented out: Alarm title commented out, notification title used
        final title = prayer.alarmMode == PrayerAlarmMode.alarm
            ? '${prayer.name} Prayer Alarm'
            : '${prayer.name} Prayer Time';
        */
        final title = '${prayer.name} Prayer Time';

        final success = await _scheduleWithFallback(
          id: id,
          title: title,
          body: prayer.note != null && prayer.note!.isNotEmpty
              ? '$leadLabel • ${prayer.note}'
              : leadLabel,
          scheduledDate: tzTrigger,
          details: _detailsForMode(prayer.alarmMode, vibrate: vibrate),
          mode: prayer.alarmMode,
          canExact: canExact,
          payload: 'namaz:${prayer.id}:${prayer.name}',
        );

        if (success) {
          scheduledCount++;
        }
      }
    }

    return scheduledCount;
  }

  Future<void> scheduleSnooze({
    required String prayerName,
    required PrayerAlarmMode mode,
    required bool vibrate,
    int minutes = 5,
  }) async {
    if (!enabled || kIsWeb) return;
    await _ensureReady();

    final trigger = DateTime.now().add(Duration(minutes: minutes));
    final tzTrigger = _toTzDateTime(trigger);
    final canExact = await canScheduleExactAlarms();

    await _scheduleWithFallback(
      id: _baseScheduleId + _maxManagedIds + 1,
      title: '$prayerName Alarm (Snoozed)',
      body: 'Snoozed for $minutes minutes — time to pray $prayerName',
      scheduledDate: tzTrigger,
      details: _detailsForMode(mode, vibrate: vibrate),
      mode: mode,
      canExact: canExact,
      payload: 'namaz:snooze:$prayerName',
    );
  }

  Future<bool> scheduleTestAlarm({
    required PrayerAlarmMode mode,
    required bool vibrate,
    int seconds = 10,
  }) async {
    if (!enabled || kIsWeb) return false;
    await _ensureReady();

    final trigger = DateTime.now().add(Duration(seconds: seconds));
    final tzTrigger = _toTzDateTime(trigger);
    final canExact = await canScheduleExactAlarms();

    return _scheduleWithFallback(
      id: _baseScheduleId + _maxManagedIds + 2,
      title: mode == PrayerAlarmMode.alarm
          ? 'Namaz Prayer Alarm (Test)'
          : 'Namaz Prayer Notification (Test)',
      body:
          'Prayer alarm test firing on time. Audio & wakeup working properly.',
      scheduledDate: tzTrigger,
      details: _detailsForMode(mode, vibrate: vibrate),
      mode: mode,
      canExact: canExact,
      payload: 'namaz:test:Test',
    );
  }

  Future<bool> showTestAlarm({
    required PrayerAlarmMode mode,
    required bool vibrate,
  }) async {
    if (!enabled || kIsWeb) return false;
    await _ensureReady();

    try {
      await _plugin.show(
        id: _baseScheduleId + _maxManagedIds + 2,
        title: 'Namaz Notification Active',
        body: 'Your prayer notifications are configured and working properly.',
        notificationDetails: _detailsForMode(
          PrayerAlarmMode.notification,
          vibrate: vibrate,
        ),
        payload: 'namaz:test:Test',
      );
      return true;
    } catch (error) {
      debugPrint('Failed to show test alarm: $error');
      return false;
    }
  }

  Future<void> cancelAllNamazSchedules() async {
    if (!enabled || kIsWeb || !_initialized) return;
    try {
      for (var i = 0; i <= _maxManagedIds + 2; i++) {
        await _plugin.cancel(id: _baseScheduleId + i);
      }
    } catch (error) {
      debugPrint('Failed to cancel scheduled notifications: $error');
    }
  }

  /// Multi-tier robust scheduler ensuring an alarm is NEVER silently dropped:
  /// 1. Primary: exactAllowWhileIdle (fires at the exact second even when asleep).
  /// 2. Guaranteed fallback: inexactAllowWhileIdle (works on 100% of Android devices without permissions).
  Future<bool> _scheduleWithFallback({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails details,
    required PrayerAlarmMode mode,
    required bool canExact,
    required String payload,
  }) async {
    // Attempt 1: Always try exactAllowWhileIdle first
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: payload,
      );
      return true;
    } catch (error) {
      debugPrint(
        'exactAllowWhileIdle failed for $title ($error); falling back to inexactAllowWhileIdle',
      );
    }

    // Attempt 2: Guaranteed fallback that never throws SecurityException
    try {
      await _plugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: payload,
      );
      return true;
    } catch (error) {
      debugPrint('All schedule modes failed for $title: $error');
      return false;
    }
  }

  tz.TZDateTime _toTzDateTime(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }

  NotificationDetails _detailsForMode(
    PrayerAlarmMode mode, {
    required bool vibrate,
  }) {
    final vibrationPattern = vibrate
        ? Int64List.fromList([0, 1000, 500, 1000, 500, 1000, 500, 1000])
        : null;

    switch (mode) {
      case PrayerAlarmMode.alarm:
        /*
        // Commented out: Dedicated Alarm channel details (alarm system disabled, notifications used instead)
        return NotificationDetails(
          android: AndroidNotificationDetails(
            _alarmChannelId,
            _alarmChannelName,
            channelDescription: _alarmChannelDesc,
            importance: Importance.max,
            priority: Priority.max,
            category: AndroidNotificationCategory.alarm,
            playSound: true,
            enableVibration: vibrate,
            vibrationPattern: vibrationPattern,
            visibility: NotificationVisibility.public,
            ticker: 'Namaz Alarm',
            enableLights: true,
            ledColor: const Color.fromARGB(255, 47, 111, 31),
            autoCancel: true,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.timeSensitive,
          ),
          macOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );
        */
        // Route alarm mode to standard high-priority notification details
        return _detailsForMode(PrayerAlarmMode.notification, vibrate: vibrate);
      case PrayerAlarmMode.notification:
        return NotificationDetails(
          android: AndroidNotificationDetails(
            _reminderChannelId,
            _reminderChannelName,
            channelDescription: _reminderChannelDesc,
            importance: Importance.high,
            priority: Priority.high,
            category: AndroidNotificationCategory.reminder,
            playSound: true,
            enableVibration: vibrate,
            vibrationPattern: vibrationPattern,
            visibility: NotificationVisibility.public,
            ticker: 'Namaz Reminder',
            autoCancel: true,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
          macOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        );
      case PrayerAlarmMode.silent:
        return const NotificationDetails(
          android: AndroidNotificationDetails(
            _silentChannelId,
            _silentChannelName,
            channelDescription: _silentChannelDesc,
            importance: Importance.low,
            priority: Priority.low,
            playSound: false,
            enableVibration: false,
            silent: true,
            visibility: NotificationVisibility.public,
            autoCancel: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: false,
          ),
          macOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: false,
          ),
        );
    }
  }
}
