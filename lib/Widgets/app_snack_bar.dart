import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';

enum SnackbarType { success, error, warning, info }

class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String title = 'Success'}) {
    _show(title: title, message: message, type: SnackbarType.success);
  }

  static void error(String message, {String title = 'Error'}) {
    _show(title: title, message: message, type: SnackbarType.error);
  }

  static void warning(String message, {String title = 'Warning'}) {
    _show(title: title, message: message, type: SnackbarType.warning);
  }

  static void info(String message, {String title = 'Information'}) {
    _show(title: title, message: message, type: SnackbarType.info);
  }

  static void _show({
    required String title,
    required String message,
    required SnackbarType type,
  }) {
    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    final Color color = _getColor(type);
    final IconData icon = _getIcon(type);

    Get.showSnackbar(
      GetSnackBar(
        titleText: Row(
          children: [
            Icon(icon, color: color, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),

        messageText: Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text(
            message,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              height: 1.4,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),

        backgroundColor: AppColors.white,
        borderRadius: 14,

        margin: EdgeInsets.symmetric(
          horizontal: Get.width * 0.04,
          vertical: Get.height * 0.015,
        ),

        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),

        snackPosition: SnackPosition.BOTTOM,

        duration: Duration(seconds: 3),

        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,

        animationDuration: Duration(milliseconds: 350),
        forwardAnimationCurve: Curves.easeOutCubic,
        reverseAnimationCurve: Curves.easeInCubic,

        boxShadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );
  }

  static Color _getColor(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return AppColors.success;

      case SnackbarType.error:
        return AppColors.error;

      case SnackbarType.warning:
        return AppColors.warning;

      case SnackbarType.info:
        return AppColors.primary;
    }
  }

  static IconData _getIcon(SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return Icons.check_circle_rounded;

      case SnackbarType.error:
        return Icons.error_rounded;

      case SnackbarType.warning:
        return Icons.warning_amber_rounded;

      case SnackbarType.info:
        return Icons.info_rounded;
    }
  }
}
