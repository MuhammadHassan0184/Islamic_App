import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Services/app_permission_service.dart';
import 'package:islam786/Widgets/first_time_permission_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zi_core/zi_core_io.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Get.testMode = true;
    ziCoreInit(beta: true);
    ZiColors.override(ZiColorOverrides(primary: AppColors.primary));
  });

  tearDown(Get.reset);

  test('AppPermissionService manages first launch and permission prompt flags', () async {
    expect(await AppPermissionService.isFirstLaunch(), isTrue);
    expect(await AppPermissionService.hasPromptedPermissions(), isFalse);

    await AppPermissionService.markFirstLaunchDone();

    expect(await AppPermissionService.isFirstLaunch(), isFalse);
    expect(await AppPermissionService.hasPromptedPermissions(), isTrue);
  });

  testWidgets('FirstTimePermissionSheet renders and triggers onGrant callback', (
    tester,
  ) async {
    var grantCalled = false;
    var skipCalled = false;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: FirstTimePermissionSheet(
            onGrant: () async {
              grantCalled = true;
            },
            onSkip: () {
              skipCalled = true;
            },
          ),
        ),
      ),
    );

    expect(find.text('Stay Connected With Every Prayer'), findsOneWidget);
    expect(find.text('Adhan & Prayer Times'), findsOneWidget);
    expect(find.text('Exact Alarms & Off-Screen Wakeup'), findsOneWidget);
    expect(find.text('Daily Azkar & Remembrances'), findsOneWidget);
    expect(find.text('Allow Alerts & Exact Alarms'), findsOneWidget);
    expect(find.text('Maybe Later'), findsOneWidget);

    final grantButton = find.text('Allow Alerts & Exact Alarms');
    await tester.ensureVisible(grantButton);
    await tester.tap(grantButton);
    await tester.pumpAndSettle();

    expect(grantCalled, isTrue);
    expect(skipCalled, isFalse);
  });

  testWidgets('FirstTimePermissionSheet triggers onSkip callback', (
    tester,
  ) async {
    var skipCalled = false;

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: FirstTimePermissionSheet(
            onGrant: () async {},
            onSkip: () {
              skipCalled = true;
            },
          ),
        ),
      ),
    );

    final skipButton = find.text('Maybe Later');
    await tester.ensureVisible(skipButton);
    await tester.tap(skipButton);
    await tester.pumpAndSettle();

    expect(skipCalled, isTrue);
  });
}
