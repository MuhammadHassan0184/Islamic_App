import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../Model/prayer_time_model.dart';

@pragma('vm:entry-point')
void namazNotificationTapBackground(NotificationResponse response) {
  debugPrint('Background Namaz notification tapped: ${response.payload}');
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

  static const String _alarmChannelId = 'namaz_alarm_channel';
  static const String _alarmChannelName = 'Namaz Alarms';
  static const String _alarmChannelDesc =
      'High-priority prayer time alarms with sound and vibration';

  static const String _reminderChannelId = 'namaz_reminder_channel';
  static const String _reminderChannelName = 'Namaz Reminders';
  static const String _reminderChannelDesc =
      'Standard notifications for daily prayer times';

  static const String _silentChannelId = 'namaz_silent_channel';
  static const String _silentChannelName = 'Silent Namaz Alerts';
  static const String _silentChannelDesc =
      'Silent notifications for prayer reminders';

  static const int _baseScheduleId = 4100;
  static const int _maxManagedIds = 250;

  Future<void> init({
    void Function(String? payload)? onNotificationTap,
  }) async {
    if (!enabled || kIsWeb || _initialized) return;

    _ensureTimezones();

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
        appName: 'Islam786',
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

  void _ensureTimezones() {
    if (_timezonesInitialized) return;
    try {
      tz_data.initializeTimeZones();
      final localLocation = _resolveLocalLocation();
      if (localLocation != null) {
        tz.setLocalLocation(localLocation);
      }
      _timezonesInitialized = true;
    } catch (error) {
      debugPrint('Timezone setup error: $error');
    }
  }

  tz.Location? _resolveLocalLocation() {
    final now = DateTime.now();
    final nowMillis = now.millisecondsSinceEpoch;
    final offset = now.timeZoneOffset;
    final zoneName = now.timeZoneName;

    final locations = tz.timeZoneDatabase.locations;
    if (locations.containsKey(zoneName)) {
      return locations[zoneName];
    }

    for (final loc in locations.values) {
      final tzInfo = loc.timeZone(nowMillis);
      if (tzInfo.offset == offset) {
        return loc;
      }
    }
    return null;
  }

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _alarmChannelId,
        _alarmChannelName,
        description: _alarmChannelDesc,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _reminderChannelId,
        _reminderChannelName,
        description: _reminderChannelDesc,
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        _silentChannelId,
        _silentChannelName,
        description: _silentChannelDesc,
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
      ),
    );
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
        final notifGranted =
            await androidPlugin.requestNotificationsPermission();
        if (notifGranted != null) {
          granted = notifGranted;
        }
        try {
          await androidPlugin.requestExactAlarmsPermission();
        } catch (error) {
          debugPrint('Exact alarm permission check skipped: $error');
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
    await init();
    if (!_initialized) return 0;

    await cancelAllNamazSchedules();
    if (!masterEnabled) return 0;

    final now = DateTime.now();
    var scheduledCount = 0;
    var slot = 0;

    final scheduleMode = await _resolveAndroidScheduleMode();

    for (var dayOffset = 0; dayOffset < daysAhead; dayOffset++) {
      final date = DateTime(now.year, now.month, now.day + dayOffset);
      final prayers = prayersForDate(date);

      for (final prayer in prayers) {
        if (!prayer.isReminderEnabled.value) continue;
        if (slot >= _maxManagedIds) break;

        final triggerTime = prayer.dateTime.subtract(
          Duration(minutes: prayer.leadMinutes),
        );
        if (!triggerTime.isAfter(now)) continue;

        final id = _baseScheduleId + slot;
        slot++;

        final formatted = prayer.formattedTime(use24Hour);
        final leadLabel = prayer.leadMinutes > 0
            ? 'Starts in ${prayer.leadMinutes} min ($formatted)'
            : 'It is time for ${prayer.name} ($formatted)';
        final title = prayer.alarmMode == PrayerAlarmMode.alarm
            ? '${prayer.name} Prayer Alarm'
            : '${prayer.name} Prayer Time';

        try {
          await _plugin.zonedSchedule(
            id: id,
            title: title,
            body: prayer.note != null && prayer.note!.isNotEmpty
                ? '$leadLabel • ${prayer.note}'
                : leadLabel,
            scheduledDate: _toTzDateTime(triggerTime),
            notificationDetails: _detailsForMode(
              prayer.alarmMode,
              vibrate: vibrate,
            ),
            androidScheduleMode: scheduleMode,
            payload: 'namaz:${prayer.id}',
          );
          scheduledCount++;
        } catch (error) {
          debugPrint('Failed to schedule ${prayer.name}: $error');
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
    await init();
    if (!_initialized) return;

    final trigger = DateTime.now().add(Duration(minutes: minutes));
    final scheduleMode = await _resolveAndroidScheduleMode();

    try {
      await _plugin.zonedSchedule(
        id: _baseScheduleId + _maxManagedIds + 1,
        title: '$prayerName Reminder (Snoozed)',
        body: 'Snoozed for $minutes minutes — time to pray $prayerName',
        scheduledDate: _toTzDateTime(trigger),
        notificationDetails: _detailsForMode(mode, vibrate: vibrate),
        androidScheduleMode: scheduleMode,
        payload: 'namaz:snooze',
      );
    } catch (error) {
      debugPrint('Failed to schedule snooze: $error');
    }
  }

  Future<bool> showTestAlarm({
    required PrayerAlarmMode mode,
    required bool vibrate,
  }) async {
    if (!enabled || kIsWeb) return false;
    await init();
    if (!_initialized) return false;

    try {
      await _plugin.show(
        id: _baseScheduleId + _maxManagedIds + 2,
        title: mode == PrayerAlarmMode.alarm
            ? 'Namaz Alarm Active'
            : 'Namaz Notification Active',
        body: 'Your prayer alerts are configured and working properly.',
        notificationDetails: _detailsForMode(mode, vibrate: vibrate),
        payload: 'namaz:test',
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

  Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {
    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (androidPlugin == null) {
        return AndroidScheduleMode.inexactAllowWhileIdle;
      }
      final canExact = await androidPlugin.canScheduleExactNotifications();
      return (canExact ?? false)
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle;
    } catch (_) {
      return AndroidScheduleMode.inexactAllowWhileIdle;
    }
  }

  tz.TZDateTime _toTzDateTime(DateTime dateTime) {
    _ensureTimezones();
    return tz.TZDateTime(
      tz.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }

  NotificationDetails _detailsForMode(
    PrayerAlarmMode mode, {
    required bool vibrate,
  }) {
    final vibrationPattern = vibrate
        ? Int64List.fromList([0, 600, 300, 600, 300, 800])
        : null;

    switch (mode) {
      case PrayerAlarmMode.alarm:
        return NotificationDetails(
          android: AndroidNotificationDetails(
            _alarmChannelId,
            _alarmChannelName,
            channelDescription: _alarmChannelDesc,
            importance: Importance.max,
            priority: Priority.max,
            category: AndroidNotificationCategory.alarm,
            audioAttributesUsage: AudioAttributesUsage.alarm,
            fullScreenIntent: true,
            playSound: true,
            enableVibration: vibrate,
            vibrationPattern: vibrationPattern,
            visibility: NotificationVisibility.public,
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
