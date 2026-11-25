import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:islam786/Widgets/first_time_permission_dialog.dart';
import 'package:islam786/features_slices/View/Namaz/Controller/namaz_controller.dart';
import 'package:islam786/features_slices/View/Namaz/Services/namaz_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPermissionService {
  AppPermissionService._();

  static const String keyHasPromptedPermissions =
      'has_prompted_first_time_permissions';
  static const String keyFirstLaunchDone = 'is_first_launch_done';

  /// Whether the user has already been shown the initial permission prompt.
  static Future<bool> hasPromptedPermissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(keyHasPromptedPermissions) ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Whether this is the user's first time launching the app.
  static Future<bool> isFirstLaunch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final done = prefs.getBool(keyFirstLaunchDone) ?? false;
      return !done;
    } catch (_) {
      return true;
    }
  }

  /// Mark that the onboarding / first launch phase has completed.
  static Future<void> markFirstLaunchDone() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(keyFirstLaunchDone, true);
      await prefs.setBool(keyHasPromptedPermissions, true);
    } catch (error) {
      debugPrint('Failed to save first launch flag: $error');
    }
  }

  /// Request all necessary app permissions:
  /// 1. POST_NOTIFICATIONS (Android 13+ & iOS)
  /// 2. SCHEDULE_EXACT_ALARM / AlarmClock (Android 12/13/14+)
  /// 3. Arms active daily prayer notifications immediately.
  static Future<bool> requestAllPermissions({bool markPrompted = true}) async {
    if (kIsWeb || Get.testMode) {
      if (markPrompted) await markFirstLaunchDone();
      return true;
    }

    try {
      final notificationService = NamazNotificationService();
      await notificationService.init();

      final granted = await notificationService.requestPermissions();

      // If NamazController is already loaded, arm all notifications now
      if (Get.isRegistered<NamazController>()) {
        try {
          final namazController = Get.find<NamazController>();
          await namazController.checkExactAlarmPermission();
          await namazController.scheduleAllPrayers();
        } catch (error) {
          debugPrint('Failed to trigger namaz controller schedule: $error');
        }
      }

      if (markPrompted) {
        await markFirstLaunchDone();
      }

      return granted;
    } catch (error) {
      debugPrint('Error requesting app permissions: $error');
      if (markPrompted) {
        await markFirstLaunchDone();
      }
      return false;
    }
  }

  /// Checks if the permission prompt has been shown yet. If not, displays the sheet.
  static Future<void> checkAndPromptFirstTime(BuildContext context) async {
    if (Get.testMode) return;

    final alreadyPrompted = await hasPromptedPermissions();
    if (alreadyPrompted) return;
    if (!context.mounted) return;

    await showPermissionSheet(context);
  }

  /// Displays the elegant FirstTimePermissionSheet.
  static Future<void> showPermissionSheet(
    BuildContext context, {
    VoidCallback? onCompleted,
  }) async {
    if (!context.mounted) return;

    var completed = false;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return FirstTimePermissionSheet(
          onGrant: () async {
            Navigator.of(modalContext).pop();
            completed = true;
            final granted = await requestAllPermissions(markPrompted: true);
            if (granted) {
              AppSnackbar.success(
                'Prayer alerts and exact alarms have been enabled.',
              );
            } else {
              AppSnackbar.info(
                'Notifications enabled. You can adjust exact alarm settings anytime in Namaz.',
              );
            }
            onCompleted?.call();
          },
          onSkip: () async {
            Navigator.of(modalContext).pop();
            completed = true;
            await markFirstLaunchDone();
            onCompleted?.call();
          },
        );
      },
    );

    // If dismissed by dragging down, ensure first launch flag is saved
    if (!completed) {
      await markFirstLaunchDone();
      onCompleted?.call();
    }
  }
}
