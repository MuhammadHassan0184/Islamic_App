import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:islam786/features_slices/View/Namaz/Controller/namaz_controller.dart';
import 'package:islam786/features_slices/View/Namaz/Model/prayer_time_model.dart';
import 'package:islam786/features_slices/View/Namaz/Services/namaz_notification_service.dart';
import 'package:islam786/features_slices/View/Namaz/Services/namaz_time_calculator.dart';
import 'package:islam786/features_slices/View/Namaz/namaz_screen.dart';
import 'package:islam786/features_slices/app_shell_binding.dart';
import 'package:islam786/features_slices/name_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
  });

  tearDown(Get.reset);

  testWidgets('home shell builds the Namaz tab with its controller', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        initialBinding: AppShellBinding(),
        home: const NameAppView(),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(Get.isRegistered<NamazController>(), isTrue);
  });

  test('NamazController calculates daily prayer times and updates on city/madhab change', () async {
    final controller = NamazController(
      notificationService: NamazNotificationService(enabled: false),
      enableTicker: false,
    );
    controller.onInit();

    expect(controller.prayerTimes, hasLength(6));
    expect(
      controller.prayerTimes.map((p) => p.name).toList(),
      ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'],
    );

    // Ensure chronological order
    for (var i = 1; i < controller.prayerTimes.length; i++) {
      expect(
        controller.prayerTimes[i].dateTime.isAfter(
          controller.prayerTimes[i - 1].dateTime,
        ),
        isTrue,
      );
    }

    final makkah = NamazTimeCalculator.findCityById('makkah')!;
    await controller.selectCityPreset(makkah);
    expect(controller.cityName.value, 'Makkah, Saudi Arabia');
    expect(controller.calculationMethod.value, NamazCalculationPreset.ummAlQura);

    final shafiAsr =
        controller.prayerTimes.firstWhere((p) => p.id == 'asr').dateTime;
    await controller.setMadhab(NamazMadhab.hanafi);
    final hanafiAsr =
        controller.prayerTimes.firstWhere((p) => p.id == 'asr').dateTime;
    expect(hanafiAsr.isAfter(shafiAsr), isTrue);

    controller.onClose();
  });

  test('NamazController persists custom prayers, time overrides, and alarm settings', () async {
    final controller = NamazController(
      notificationService: NamazNotificationService(enabled: false),
      enableTicker: false,
    );
    controller.onInit();

    await controller.addCustomPrayer(
      name: 'Tahajjud',
      time: const TimeOfDay(hour: 3, minute: 45),
      note: 'Night prayer',
      reminderEnabled: true,
      leadMinutes: 10,
      alarmMode: PrayerAlarmMode.alarm,
    );

    expect(
      controller.prayerTimes.any((p) => p.name == 'Tahajjud' && p.isCustomPrayer),
      isTrue,
    );

    final fajr = controller.prayerTimes.firstWhere((p) => p.id == 'fajr');
    await controller.updatePrayerTiming(
      fajr,
      time: const TimeOfDay(hour: 5, minute: 30),
      reminderEnabled: true,
      leadMinutes: 5,
      alarmMode: PrayerAlarmMode.notification,
    );

    final updatedFajr = controller.prayerTimes.firstWhere((p) => p.id == 'fajr');
    expect(updatedFajr.hasCustomTimeOverride, isTrue);
    expect(updatedFajr.time, '05:30');
    expect(updatedFajr.leadMinutes, 5);

    // Reload into a fresh controller to verify SharedPreferences persistence
    final reloaded = NamazController(
      notificationService: NamazNotificationService(enabled: false),
      enableTicker: false,
    );
    reloaded.onInit();
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(reloaded.prayerTimes.any((p) => p.name == 'Tahajjud'), isTrue);
    final reloadedFajr =
        reloaded.prayerTimes.firstWhere((p) => p.id == 'fajr');
    expect(reloadedFajr.hasCustomTimeOverride, isTrue);
    expect(reloadedFajr.time, '05:30');

    // Reset auto & delete custom prayer
    await reloaded.resetPrayerToAuto(reloadedFajr);
    expect(
      reloaded.prayerTimes.firstWhere((p) => p.id == 'fajr').hasCustomTimeOverride,
      isFalse,
    );

    final tahajjud =
        reloaded.prayerTimes.firstWhere((p) => p.name == 'Tahajjud');
    await reloaded.deleteCustomPrayer(tahajjud);
    expect(reloaded.prayerTimes.any((p) => p.name == 'Tahajjud'), isFalse);

    controller.onClose();
    reloaded.onClose();
  });

  testWidgets('NamazScreen renders prayer list and adds a custom Namaz timing', (
    tester,
  ) async {
    final controller = NamazController(
      notificationService: NamazNotificationService(enabled: false),
      enableTicker: false,
    );
    Get.put<NamazController>(controller);

    await tester.pumpWidget(const GetMaterialApp(home: NamazScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Prayer Times'), findsOneWidget);
    expect(find.text('Fajr'), findsOneWidget);
    expect(find.text('Add Custom'), findsOneWidget);

    await tester.tap(find.text('Add Custom'));
    await tester.pumpAndSettle();

    expect(find.text('Add Custom Namaz Timing'), findsOneWidget);
    await tester.tap(find.text('Tahajjud'));
    await tester.pumpAndSettle();

    final saveButton = find.text('Add Namaz Timing');
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Tahajjud'), findsOneWidget);
    expect(find.text('Custom'), findsOneWidget);

    // Allow GetSnackBar's 3-second timer to finish cleanly before test teardown.
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });
}
