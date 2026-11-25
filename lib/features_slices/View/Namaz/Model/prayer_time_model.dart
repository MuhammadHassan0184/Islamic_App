import 'package:adhan/adhan.dart' as adhan;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum PrayerAlarmMode {
  alarm('Alarm', 'Full sound & wake alert', Icons.alarm_on_rounded),
  notification(
    'Notification',
    'Standard banner & chime',
    Icons.notifications_active_rounded,
  ),
  silent('Silent', 'Banner without sound', Icons.notifications_paused_rounded);

  const PrayerAlarmMode(this.label, this.description, this.icon);

  final String label;
  final String description;
  final IconData icon;

  static PrayerAlarmMode fromName(String? name) {
    return PrayerAlarmMode.values.firstWhere(
      (mode) => mode.name == name,
      orElse: () => PrayerAlarmMode.alarm,
    );
  }
}

enum NamazCalculationPreset {
  karachi(
    'University of Islamic Sciences, Karachi',
    'Karachi',
    adhan.CalculationMethod.karachi,
  ),
  muslimWorldLeague(
    'Muslim World League',
    'MWL',
    adhan.CalculationMethod.muslim_world_league,
  ),
  ummAlQura(
    'Umm al-Qura University, Makkah',
    'Umm al-Qura',
    adhan.CalculationMethod.umm_al_qura,
  ),
  northAmerica(
    'Islamic Society of North America',
    'ISNA',
    adhan.CalculationMethod.north_america,
  ),
  egyptian(
    'Egyptian General Authority',
    'Egyptian',
    adhan.CalculationMethod.egyptian,
  ),
  dubai('Dubai', 'Dubai', adhan.CalculationMethod.dubai),
  singapore('Singapore', 'MUIS', adhan.CalculationMethod.singapore),
  tehran('Institute of Geophysics, Tehran', 'Tehran', adhan.CalculationMethod.tehran),
  turkey('Diyanet Isleri Baskanligi, Turkey', 'Turkey', adhan.CalculationMethod.turkey);

  const NamazCalculationPreset(this.label, this.shortLabel, this.adhanMethod);

  final String label;
  final String shortLabel;
  final adhan.CalculationMethod adhanMethod;

  static NamazCalculationPreset fromName(String? name) {
    return NamazCalculationPreset.values.firstWhere(
      (preset) => preset.name == name,
      orElse: () => NamazCalculationPreset.karachi,
    );
  }
}

enum NamazMadhab {
  hanafi('Hanafi', 'Later Asr (2x shadow)', adhan.Madhab.hanafi),
  shafi('Shafi / Standard', 'Earlier Asr (1x shadow)', adhan.Madhab.shafi);

  const NamazMadhab(this.label, this.description, this.adhanMadhab);

  final String label;
  final String description;
  final adhan.Madhab adhanMadhab;

  static NamazMadhab fromName(String? name) {
    return NamazMadhab.values.firstWhere(
      (m) => m.name == name,
      orElse: () => NamazMadhab.hanafi,
    );
  }
}

class NamazCityPreset {
  final String id;
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final NamazCalculationPreset defaultMethod;
  final NamazMadhab defaultMadhab;
  final int utcOffsetMinutes;

  const NamazCityPreset({
    required this.id,
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.defaultMethod,
    required this.defaultMadhab,
    required this.utcOffsetMinutes,
  });

  String get displayName => '$city, $country';
}

class CustomPrayerConfig {
  final String id;
  final String name;
  final int hour;
  final int minute;
  final String? note;
  final bool reminderEnabled;
  final int leadMinutes;
  final PrayerAlarmMode alarmMode;

  const CustomPrayerConfig({
    required this.id,
    required this.name,
    required this.hour,
    required this.minute,
    this.note,
    this.reminderEnabled = true,
    this.leadMinutes = 0,
    this.alarmMode = PrayerAlarmMode.alarm,
  });

  CustomPrayerConfig copyWith({
    String? id,
    String? name,
    int? hour,
    int? minute,
    String? note,
    bool clearNote = false,
    bool? reminderEnabled,
    int? leadMinutes,
    PrayerAlarmMode? alarmMode,
  }) {
    return CustomPrayerConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      note: clearNote ? null : (note ?? this.note),
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      leadMinutes: leadMinutes ?? this.leadMinutes,
      alarmMode: alarmMode ?? this.alarmMode,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'hour': hour,
    'minute': minute,
    'note': note,
    'reminderEnabled': reminderEnabled,
    'leadMinutes': leadMinutes,
    'alarmMode': alarmMode.name,
  };

  factory CustomPrayerConfig.fromJson(Map<String, dynamic> json) {
    return CustomPrayerConfig(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Custom Namaz',
      hour: (json['hour'] as num?)?.toInt().clamp(0, 23) ?? 5,
      minute: (json['minute'] as num?)?.toInt().clamp(0, 59) ?? 0,
      note: json['note']?.toString(),
      reminderEnabled: json['reminderEnabled'] as bool? ?? true,
      leadMinutes: (json['leadMinutes'] as num?)?.toInt().clamp(0, 60) ?? 0,
      alarmMode: PrayerAlarmMode.fromName(json['alarmMode']?.toString()),
    );
  }
}

class PrayerTimeModel {
  final String id;
  final String name;
  final DateTime dateTime;
  final String time;
  final bool isPrayer;
  final bool isCustomPrayer;
  final bool hasCustomTimeOverride;
  final String? note;
  final int leadMinutes;
  final PrayerAlarmMode alarmMode;
  final RxBool isReminderEnabled;

  PrayerTimeModel({
    String? id,
    required this.name,
    DateTime? dateTime,
    required this.time,
    this.isPrayer = true,
    this.isCustomPrayer = false,
    this.hasCustomTimeOverride = false,
    this.note,
    this.leadMinutes = 0,
    this.alarmMode = PrayerAlarmMode.alarm,
    bool reminderEnabled = true,
  }) : id = id ?? name.toLowerCase().replaceAll(' ', '_'),
       dateTime = dateTime ?? _parseFallbackDateTime(time),
       isReminderEnabled = reminderEnabled.obs;

  static DateTime _parseFallbackDateTime(String rawTime) {
    final now = DateTime.now();
    final parts = rawTime.split(':');
    final hour = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  TimeOfDay get timeOfDay =>
      TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);

  String formattedTime(bool use24Hour) {
    if (use24Hour) {
      final hh = dateTime.hour.toString().padLeft(2, '0');
      final mm = dateTime.minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    }
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final hour12 = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final mm = dateTime.minute.toString().padLeft(2, '0');
    return '${hour12.toString().padLeft(2, '0')}:$mm $period';
  }
}
