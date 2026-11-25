import 'package:adhan/adhan.dart' as adhan;
import 'package:flutter/material.dart';
import '../Model/prayer_time_model.dart';

class NamazTimeCalculator {
  NamazTimeCalculator._();

  static const List<NamazCityPreset> cityPresets = [
    NamazCityPreset(
      id: 'lahore',
      city: 'Lahore',
      country: 'Pakistan',
      latitude: 31.5204,
      longitude: 74.3587,
      defaultMethod: NamazCalculationPreset.karachi,
      defaultMadhab: NamazMadhab.hanafi,
      utcOffsetMinutes: 300,
    ),
    NamazCityPreset(
      id: 'karachi',
      city: 'Karachi',
      country: 'Pakistan',
      latitude: 24.8607,
      longitude: 67.0011,
      defaultMethod: NamazCalculationPreset.karachi,
      defaultMadhab: NamazMadhab.hanafi,
      utcOffsetMinutes: 300,
    ),
    NamazCityPreset(
      id: 'islamabad',
      city: 'Islamabad',
      country: 'Pakistan',
      latitude: 33.6844,
      longitude: 73.0479,
      defaultMethod: NamazCalculationPreset.karachi,
      defaultMadhab: NamazMadhab.hanafi,
      utcOffsetMinutes: 300,
    ),
    NamazCityPreset(
      id: 'makkah',
      city: 'Makkah',
      country: 'Saudi Arabia',
      latitude: 21.3891,
      longitude: 39.8579,
      defaultMethod: NamazCalculationPreset.ummAlQura,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: 180,
    ),
    NamazCityPreset(
      id: 'madinah',
      city: 'Madinah',
      country: 'Saudi Arabia',
      latitude: 24.5247,
      longitude: 39.5692,
      defaultMethod: NamazCalculationPreset.ummAlQura,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: 180,
    ),
    NamazCityPreset(
      id: 'riyadh',
      city: 'Riyadh',
      country: 'Saudi Arabia',
      latitude: 24.7136,
      longitude: 46.6753,
      defaultMethod: NamazCalculationPreset.ummAlQura,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: 180,
    ),
    NamazCityPreset(
      id: 'dubai',
      city: 'Dubai',
      country: 'UAE',
      latitude: 25.2048,
      longitude: 55.2708,
      defaultMethod: NamazCalculationPreset.dubai,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: 240,
    ),
    NamazCityPreset(
      id: 'doha',
      city: 'Doha',
      country: 'Qatar',
      latitude: 25.2854,
      longitude: 51.5310,
      defaultMethod: NamazCalculationPreset.ummAlQura,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: 180,
    ),
    NamazCityPreset(
      id: 'istanbul',
      city: 'Istanbul',
      country: 'Turkey',
      latitude: 41.0082,
      longitude: 28.9784,
      defaultMethod: NamazCalculationPreset.turkey,
      defaultMadhab: NamazMadhab.hanafi,
      utcOffsetMinutes: 180,
    ),
    NamazCityPreset(
      id: 'cairo',
      city: 'Cairo',
      country: 'Egypt',
      latitude: 30.0444,
      longitude: 31.2357,
      defaultMethod: NamazCalculationPreset.egyptian,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: 120,
    ),
    NamazCityPreset(
      id: 'london',
      city: 'London',
      country: 'United Kingdom',
      latitude: 51.5072,
      longitude: -0.1276,
      defaultMethod: NamazCalculationPreset.muslimWorldLeague,
      defaultMadhab: NamazMadhab.hanafi,
      utcOffsetMinutes: 0,
    ),
    NamazCityPreset(
      id: 'new_york',
      city: 'New York',
      country: 'USA',
      latitude: 40.7128,
      longitude: -74.0060,
      defaultMethod: NamazCalculationPreset.northAmerica,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: -300,
    ),
    NamazCityPreset(
      id: 'toronto',
      city: 'Toronto',
      country: 'Canada',
      latitude: 43.6532,
      longitude: -79.3832,
      defaultMethod: NamazCalculationPreset.northAmerica,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: -300,
    ),
    NamazCityPreset(
      id: 'delhi',
      city: 'New Delhi',
      country: 'India',
      latitude: 28.6139,
      longitude: 77.2090,
      defaultMethod: NamazCalculationPreset.karachi,
      defaultMadhab: NamazMadhab.hanafi,
      utcOffsetMinutes: 330,
    ),
    NamazCityPreset(
      id: 'dhaka',
      city: 'Dhaka',
      country: 'Bangladesh',
      latitude: 23.8103,
      longitude: 90.4125,
      defaultMethod: NamazCalculationPreset.karachi,
      defaultMadhab: NamazMadhab.hanafi,
      utcOffsetMinutes: 360,
    ),
    NamazCityPreset(
      id: 'jakarta',
      city: 'Jakarta',
      country: 'Indonesia',
      latitude: -6.2088,
      longitude: 106.8456,
      defaultMethod: NamazCalculationPreset.singapore,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: 420,
    ),
    NamazCityPreset(
      id: 'kuala_lumpur',
      city: 'Kuala Lumpur',
      country: 'Malaysia',
      latitude: 3.1390,
      longitude: 101.6869,
      defaultMethod: NamazCalculationPreset.singapore,
      defaultMadhab: NamazMadhab.shafi,
      utcOffsetMinutes: 480,
    ),
  ];

  static NamazCityPreset? findCityById(String? id) {
    if (id == null) return null;
    for (final city in cityPresets) {
      if (city.id == id) return city;
    }
    return null;
  }

  /// Picks a sensible city matching the device timezone offset on first launch.
  static NamazCityPreset defaultCityForTimezone([Duration? offset]) {
    final targetMinutes = (offset ?? DateTime.now().timeZoneOffset).inMinutes;
    NamazCityPreset best = cityPresets.first;
    var smallestDiff = (best.utcOffsetMinutes - targetMinutes).abs();

    for (final city in cityPresets.skip(1)) {
      final diff = (city.utcOffsetMinutes - targetMinutes).abs();
      if (diff < smallestDiff) {
        smallestDiff = diff;
        best = city;
      }
    }
    return best;
  }

  static List<PrayerTimeModel> calculateDailyPrayers({
    required DateTime date,
    required double latitude,
    required double longitude,
    required NamazCalculationPreset method,
    required NamazMadhab madhab,
    Map<String, TimeOfDay> customTimeOverrides = const {},
    Map<String, bool> reminderOverrides = const {},
    Map<String, int> leadMinuteOverrides = const {},
    Map<String, PrayerAlarmMode> alarmModeOverrides = const {},
    PrayerAlarmMode defaultAlarmMode = PrayerAlarmMode.alarm,
    int defaultLeadMinutes = 0,
    List<CustomPrayerConfig> customPrayers = const [],
  }) {
    final coordinates = adhan.Coordinates(
      latitude.clamp(-90.0, 90.0),
      longitude.clamp(-180.0, 180.0),
    );
    final params = method.adhanMethod.getParameters();
    params.madhab = madhab.adhanMadhab;

    final dateComponents = adhan.DateComponents(date.year, date.month, date.day);
    final calculated = adhan.PrayerTimes(coordinates, dateComponents, params);

    final baseEntries = <({String id, String name, DateTime time, bool isPrayer})>[
      (id: 'fajr', name: 'Fajr', time: calculated.fajr.toLocal(), isPrayer: true),
      (
        id: 'sunrise',
        name: 'Sunrise',
        time: calculated.sunrise.toLocal(),
        isPrayer: false,
      ),
      (id: 'dhuhr', name: 'Dhuhr', time: calculated.dhuhr.toLocal(), isPrayer: true),
      (id: 'asr', name: 'Asr', time: calculated.asr.toLocal(), isPrayer: true),
      (
        id: 'maghrib',
        name: 'Maghrib',
        time: calculated.maghrib.toLocal(),
        isPrayer: true,
      ),
      (id: 'isha', name: 'Isha', time: calculated.isha.toLocal(), isPrayer: true),
    ];

    final models = <PrayerTimeModel>[];

    for (final entry in baseEntries) {
      final customTime = customTimeOverrides[entry.id];
      final effectiveDateTime = customTime != null
          ? DateTime(
              date.year,
              date.month,
              date.day,
              customTime.hour,
              customTime.minute,
            )
          : DateTime(
              date.year,
              date.month,
              date.day,
              entry.time.hour,
              entry.time.minute,
            );

      final defaultReminder = entry.isPrayer;
      models.add(
        PrayerTimeModel(
          id: entry.id,
          name: entry.name,
          dateTime: effectiveDateTime,
          time: _formatHHmm(effectiveDateTime),
          isPrayer: entry.isPrayer,
          isCustomPrayer: false,
          hasCustomTimeOverride: customTime != null,
          leadMinutes: leadMinuteOverrides[entry.id] ?? defaultLeadMinutes,
          alarmMode: alarmModeOverrides[entry.id] ?? defaultAlarmMode,
          reminderEnabled: reminderOverrides[entry.id] ?? defaultReminder,
        ),
      );
    }

    for (final custom in customPrayers) {
      final customDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        custom.hour,
        custom.minute,
      );
      models.add(
        PrayerTimeModel(
          id: custom.id,
          name: custom.name,
          dateTime: customDateTime,
          time: _formatHHmm(customDateTime),
          isPrayer: true,
          isCustomPrayer: true,
          hasCustomTimeOverride: true,
          note: custom.note,
          leadMinutes: custom.leadMinutes,
          alarmMode: custom.alarmMode,
          reminderEnabled: reminderOverrides[custom.id] ?? custom.reminderEnabled,
        ),
      );
    }

    models.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return models;
  }

  static String _formatHHmm(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$hh:$mm';
  }
}
