import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Data/Models/zikr_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:islam786/features_slices/View/Azkar/Controller/azkar_controller.dart';
import 'azkar_responsive.dart';

class ZikrCard extends StatelessWidget {
  const ZikrCard({super.key, required this.zikr, required this.controller});

  final ZikrModel zikr;
  final AzkarController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = controller.countFor(zikr);
      final progress = controller.progressFor(zikr);
      final target = controller.targetFor(zikr);

      return Card(
        color: AppColors.white,
        margin: EdgeInsets.only(bottom: context.heightPct(0.014)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.widthPct(0.035)),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
        child: Padding(
          padding: context.responsivePadding(
            horizontal: 0.045,
            vertical: 0.018,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      zikr.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: azkarFontSize(context, 17),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Reset counter',
                    onPressed: count == 0
                        ? null
                        : () => controller.resetCount(zikr),
                    icon: const Icon(Icons.restart_alt_rounded),
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
              SizedBox(height: context.heightPct(0.008)),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  zikr.arabic,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: azkarFontSize(context, 25),
                    height: 1.8,
                    fontFamily: 'NotoNaskhArabic',
                  ),
                ),
              ),
              if (zikr.urdu.isNotEmpty) ...[
                SizedBox(height: context.heightPct(0.008)),
                Text(
                  zikr.urdu,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: azkarFontSize(context, 13),
                    height: 1.55,
                  ),
                ),
              ],
              if (zikr.english.isNotEmpty) ...[
                SizedBox(height: context.heightPct(0.006)),
                Text(
                  zikr.english,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: azkarFontSize(context, 13),
                    height: 1.45,
                  ),
                ),
              ],
              if (zikr.reference.isNotEmpty) ...[
                SizedBox(height: context.heightPct(0.008)),
                Text(
                  zikr.reference,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: azkarFontSize(context, 11),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              SizedBox(height: context.heightPct(0.016)),
              Row(
                children: [
                  Text(
                    '$count / $target',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: azkarFontSize(context, 12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: context.widthPct(0.025)),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.primary,
                      backgroundColor: AppColors.softGreenGradient.colors.first,
                    ),
                  ),
                  SizedBox(width: context.widthPct(0.025)),
                  FilledButton(
                    onPressed: () => _openCounter(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(0.035),
                      ),
                    ),
                    child: const Text('Count'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  void _openCounter(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ZikrCounterSheet(zikr: zikr, controller: controller),
    );
  }
}

class ZikrCounterSheet extends StatelessWidget {
  const ZikrCounterSheet({
    super.key,
    required this.zikr,
    required this.controller,
  });

  final ZikrModel zikr;
  final AzkarController controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.widthPct(0.06)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: context.responsivePadding(
              horizontal: 0.05,
              vertical: 0.018,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        zikr.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: context.scaledFont(18),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close counter',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: context.heightPct(0.01)),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            zikr.arabic,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: azkarFontSize(context, 29),
                              height: 1.9,
                              fontFamily: 'NotoNaskhArabic',
                            ),
                          ),
                        ),
                        if (zikr.urdu.isNotEmpty) ...[
                          SizedBox(height: context.heightPct(0.012)),
                          Text(
                            zikr.urdu,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: azkarFontSize(context, 14),
                              height: 1.5,
                            ),
                          ),
                        ],
                        if (zikr.english.isNotEmpty) ...[
                          SizedBox(height: context.heightPct(0.008)),
                          Text(
                            zikr.english,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: azkarFontSize(context, 13),
                              height: 1.45,
                            ),
                          ),
                        ],
                        if (zikr.reference.isNotEmpty) ...[
                          SizedBox(height: context.heightPct(0.01)),
                          Text(
                            zikr.reference,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: azkarFontSize(context, 12),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        if (zikr.steps.isNotEmpty) ...[
                          SizedBox(height: context.heightPct(0.014)),
                          ...zikr.steps.map(
                            (step) => Padding(
                              padding: EdgeInsets.only(
                                bottom: context.heightPct(0.008),
                              ),
                              child: ListTile(
                                dense: true,
                                tileColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                leading: CircleAvatar(
                                  backgroundColor:
                                      AppColors.softGreenGradient.colors.first,
                                  foregroundColor: AppColors.primary,
                                  child: Text('${step.stepNo}'),
                                ),
                                title: Text(step.title),
                                subtitle: Text(step.detail),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.heightPct(0.01)),
                Obx(() {
                  final count = controller.countFor(zikr);
                  final target = controller.targetFor(zikr);
                  final complete = count >= target;
                  final diameter = (size.width * 0.42).clamp(132.0, 180.0);

                  return Column(
                    children: [
                      TextButton.icon(
                        onPressed: () => _editTarget(context),
                        icon: const Icon(Icons.tune_rounded),
                        label: Text('Target: $target'),
                      ),
                      Semantics(
                        button: true,
                        label: 'Increment ${zikr.title} counter',
                        child: SizedBox(
                          width: diameter,
                          height: diameter,
                          child: Material(
                            color: AppColors.white,
                            shape: const CircleBorder(),
                            elevation: 2,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: complete
                                  ? null
                                  : () {
                                      HapticFeedback.selectionClick();
                                      controller.increment(zikr);
                                    },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: diameter - 12,
                                    height: diameter - 12,
                                    child: CircularProgressIndicator(
                                      value: controller.progressFor(zikr),
                                      strokeWidth: 7,
                                      color: AppColors.primary,
                                      backgroundColor: AppColors
                                          .softGreenGradient
                                          .colors
                                          .first,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '$count',
                                        style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: azkarFontSize(context, 32),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Text(
                                        complete ? 'Complete' : 'of $target',
                                        style: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: azkarFontSize(context, 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: context.heightPct(0.008)),
                      Text(
                        complete ? 'Target reached' : 'Tap the circle to count',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: azkarFontSize(context, 12),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: count == 0
                            ? null
                            : () => controller.resetCount(zikr),
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text('Reset'),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editTarget(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => _TargetEditDialog(zikr: zikr, controller: controller),
    );
  }
}

class _TargetEditDialog extends StatefulWidget {
  const _TargetEditDialog({required this.zikr, required this.controller});

  final ZikrModel zikr;
  final AzkarController controller;

  @override
  State<_TargetEditDialog> createState() => _TargetEditDialogState();
}

class _TargetEditDialogState extends State<_TargetEditDialog> {
  late final TextEditingController _input;

  @override
  void initState() {
    super.initState();
    _input = TextEditingController(
      text: '${widget.controller.targetFor(widget.zikr)}',
    );
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  Future<void> _saveTarget() async {
    final target = int.tryParse(_input.text);
    if (target == null || target < 1) {
      AppSnackbar.warning('Enter a target greater than zero.');
      return;
    }

    await widget.controller.setTarget(widget.zikr, target);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set repetition target'),
      content: TextField(
        controller: _input,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          labelText: 'Repetitions',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(onPressed: _saveTarget, child: const Text('Save')),
      ],
    );
  }
}
