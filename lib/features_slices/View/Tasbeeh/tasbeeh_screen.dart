import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart' hide TextDirection;
import 'Controller/tasbeeh_controller.dart';
import 'Widgets/tasbeeh_counter_display.dart';
import 'Widgets/tasbeeh_dhikr_sheet.dart';

class TasbeehScreen extends StatelessWidget {
  const TasbeehScreen({super.key});

  TasbeehController get controller => Get.find<TasbeehController>();

  void _confirmResetAll(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ZiRadius.card),
          ),
          title: const Text('Reset Tasbeeh?'),
          content: const Text(
            'Are you sure you want to reset current count and completed rounds?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ZiRadius.sm),
                ),
              ),
              onPressed: () {
                Navigator.of(ctx).pop();
                controller.resetAll();
              },
              child: const Text('Reset All'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Ensure controller is registered
    if (!Get.isRegistered<TasbeehController>()) {
      Get.put(TasbeehController());
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Home_bg_image.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: AppColors.background);
            },
          ),
          Column(
            children: [
              // Top Header
              _buildHeader(context),

              // Scrollable Body
              Expanded(
                child: SafeArea(
                  top: false,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: context.isDesktop ? 860 : 640,
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: context.responsivePadding(
                          horizontal: context.isMobile ? 0.048 : 0.035,
                          vertical: 0.018,
                        ),
                        child: Column(
                          children: [
                            // Selected Dhikr Card
                            _buildDhikrCard(context),

                            ziGap(context.heightPct(0.024)),

                            // Main Interactive Counter
                            TasbeehCounterDisplay(controller: controller),

                            ziGap(context.heightPct(0.024)),

                            // Target Quick Chips
                            _buildTargetSelector(context),

                            ziGap(context.heightPct(0.020)),

                            // Action Buttons (Undo & Reset)
                            _buildActionButtons(context),

                            ziGap(context.heightPct(0.020)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final canGoBack = Navigator.of(context).canPop();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: context.responsivePadding(
            horizontal: 0.04,
            vertical: 0.016,
          ),
          child: Row(
            children: [
              if (canGoBack)
                IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.white,
                  ),
                )
              else
                SizedBox(width: context.widthPct(0.02)),
              Expanded(
                child: Column(
                  crossAxisAlignment: canGoBack
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Digital Tasbeeh',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: context.scaledFont(20).clamp(18.0, 26.0),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: context.heightPct(0.002)),
                    Text(
                      'Remember Allah with every breath',
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.85),
                        fontSize: context.scaledFont(11.5).clamp(11.0, 14.0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                final sound = controller.soundEnabled.value;
                return IconButton(
                  tooltip: sound ? 'Mute Sound' : 'Enable Sound',
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: controller.toggleSound,
                  icon: Icon(
                    sound
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                    color: AppColors.white,
                    size: 20,
                  ),
                );
              }),
              Obx(() {
                final vib = controller.vibrationEnabled.value;
                return IconButton(
                  tooltip: vib ? 'Disable Vibration' : 'Enable Vibration',
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                  onPressed: controller.toggleVibration,
                  icon: Icon(
                    vib
                        ? Icons.vibration_rounded
                        : Icons.phonelink_ring_outlined,
                    color: AppColors.white,
                    size: 20,
                  ),
                );
              }),
              IconButton(
                tooltip: 'Reset All',
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(minWidth: 36, minHeight: 36),
                onPressed: () => _confirmResetAll(context),
                icon: const Icon(
                  Icons.restart_alt_rounded,
                  color: AppColors.white,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDhikrCard(BuildContext context) {
    return Obx(() {
      final dhikr = controller.selectedDhikr.value;

      return Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(ZiRadius.card),
        elevation: 0,
        child: InkWell(
          borderRadius: BorderRadius.circular(ZiRadius.card),
          onTap: () => showDhikrSelectionSheet(context, controller),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ZiRadius.card),
              border: Border.all(color: AppColors.cardBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.softGreenGradient.colors.first,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppColors.primary,
                            size: 14,
                          ),
                          ziGap(4),
                          Text(
                            'Active Dhikr',
                            style: TextStyle(
                              fontSize: context
                                  .scaledFont(11)
                                  .clamp(10.0, 12.5),
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        foregroundColor: AppColors.primary,
                      ),
                      onPressed: () =>
                          showDhikrSelectionSheet(context, controller),
                      icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                      label: Text(
                        'Change',
                        style: TextStyle(
                          fontSize: context
                              .scaledFont(12)
                              .clamp(11.0, 13.5),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                ziGap(10),
                Text(
                  dhikr.arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontSize: context.scaledFont(24).clamp(20.0, 30.0),
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    height: 1.3,
                  ),
                ),
                ziGap(6),
                Text(
                  dhikr.transliteration,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: context.scaledFont(14.5).clamp(13.0, 17.0),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (dhikr.meaning.isNotEmpty) ...[
                  ziGap(4),
                  Text(
                    dhikr.meaning,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: context.scaledFont(12).clamp(11.0, 14.0),
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTargetSelector(BuildContext context) {
    const targets = [33, 99, 100, 0];

    return Obx(() {
      final currentTarget = controller.targetCount.value;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(ZiRadius.card),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.flag_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
                ziGap(6),
                Text(
                  'Target Count',
                  style: TextStyle(
                    fontSize: context.scaledFont(12.5).clamp(11.5, 14.0),
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            ziGap(8),
            Row(
              children: targets.map((t) {
                final isSelected = currentTarget == t;
                final label = t == 0 ? 'Free (∞)' : '$t';

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(ZiRadius.md),
                      onTap: () => controller.setTarget(t),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(ZiRadius.md),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.cardBorder,
                          ),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            label,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context
                                  .scaledFont(12)
                                  .clamp(11.0, 14.0),
                              fontWeight: isSelected
                                  ? FontWeight.w800
                                  : FontWeight.w600,
                              color: isSelected
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // Undo (-1) button
        Expanded(
          child: ZiButtonB(
            variant: ZiButtonVariantB.outline,
            icon: const Icon(
              Icons.undo_rounded,
              color: AppColors.textPrimary,
              size: 18,
            ),
            label: 'Undo (-1)',
            style: ZiButtonStyleB(
              height: 44,
              borderColor: AppColors.cardBorder,
              foregroundColor: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(ZiRadius.md),
            ),
            action: controller.decrement,
          ),
        ),
        ziGap(12),
        // Reset Round button
        Expanded(
          child: ZiButtonB(
            variant: ZiButtonVariantB.outline,
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppColors.warning,
              size: 18,
            ),
            label: 'Reset Round',
            style: ZiButtonStyleB(
              height: 44,
              borderColor: AppColors.warning.withValues(alpha: 0.5),
              foregroundColor: AppColors.warning,
              borderRadius: BorderRadius.circular(ZiRadius.md),
            ),
            action: controller.resetCurrentRound,
          ),
        ),
      ],
    );
  }
}
