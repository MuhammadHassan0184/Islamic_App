import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Tasbeeh/Widgets/tasbeeh_dhikr_sheet.dart';
import 'package:zi_core/zi_core_io.dart';
import '../Controller/tasbeeh_controller.dart';

class TasbeehCounterDisplay extends StatefulWidget {
  final TasbeehController controller;

  const TasbeehCounterDisplay({super.key, required this.controller});

  @override
  State<TasbeehCounterDisplay> createState() => _TasbeehCounterDisplayState();
}

class _TasbeehCounterDisplayState extends State<TasbeehCounterDisplay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animCtrl;
  late final Animation<double> _scaleAnimation;
  TasbeehController get controller => Get.find<TasbeehController>();

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 90),
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _animCtrl.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _animCtrl.reverse();
    widget.controller.increment();
  }

  void _onTapCancel() {
    _animCtrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final widthBound = context.widthPct(context.isMobile ? 0.64 : 0.42);
    final heightBound = context.heightPct(0.33);
    final size = (widthBound < heightBound ? widthBound : heightBound).clamp(
      190.0,
      290.0,
    );

    return Obx(() {
      final count = widget.controller.currentCount.value;
      final target = widget.controller.targetCount.value;
      final progress = widget.controller.progress;
      final rounds = widget.controller.roundCount.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Stat chips: Laps / Rounds & Total count
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 8,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: AppColors.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.repeat_rounded,
                      color: AppColors.primary,
                      size: 16,
                    ),
                    ziGap(6),
                    Text(
                      'Rounds: $rounds',
                      style: TextStyle(
                        fontSize: context.scaledFont(12).clamp(11.0, 14.0),
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
                    vertical: 0,
                  ),
                  foregroundColor: AppColors.primary,
                ),
                onPressed: () => showDhikrSelectionSheet(context, controller),
                icon: const Icon(Icons.swap_horiz_rounded, size: 16),
                label: Text(
                  'Change',
                  style: TextStyle(
                    fontSize: context.scaledFont(12).clamp(11.0, 13.5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          ziGap(context.heightPct(0.024)),

          // Main Interactive Circular Bead / Button
          GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                );
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glowing ring
                  Container(
                    width: size + 20,
                    height: size + 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.18),
                          blurRadius: 28,
                          spreadRadius: 4,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                  ),

                  // Circular Progress Indicator Track
                  SizedBox(
                    width: size + 10,
                    height: size + 10,
                    child: CircularProgressIndicator(
                      value: target > 0 ? progress : null,
                      strokeWidth: 7,
                      backgroundColor: AppColors.cardBorder,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.tabIndicator,
                      ),
                    ),
                  ),

                  // Main Bead Container
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      border: Border.all(
                        color: AppColors.white.withValues(alpha: 0.35),
                        width: 3.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryDark.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Subtle top highlight reflection
                        Positioned(
                          top: size * 0.08,
                          child: Container(
                            width: size * 0.58,
                            height: size * 0.22,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.elliptical(size * 0.58, size * 0.22),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.white.withValues(alpha: 0.28),
                                  AppColors.white.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Center Counter Readout
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: (size * 0.32).clamp(42.0, 74.0),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                    height: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            ziGap(4),
                            Text(
                              target > 0 ? '/ $target' : 'FREE MODE',
                              style: TextStyle(
                                color: AppColors.white.withValues(alpha: 0.85),
                                fontSize: context
                                    .scaledFont(14)
                                    .clamp(12.0, 16.0),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.6,
                              ),
                            ),
                            ziGap(6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.16),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'TAP TO COUNT',
                                style: TextStyle(
                                  color: AppColors.white.withValues(
                                    alpha: 0.90,
                                  ),
                                  fontSize: context
                                      .scaledFont(10)
                                      .clamp(9.0, 11.5),
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
