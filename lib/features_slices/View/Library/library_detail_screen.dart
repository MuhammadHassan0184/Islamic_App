import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Data/Models/library_content_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart';

class LibraryDetailScreen extends StatelessWidget {
  const LibraryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final argument = Get.arguments;
    if (argument is! LibraryContentModel) {
      throw StateError('A library item is required for this screen.');
    }
    final item = argument;

    return ZiScaffoldB(
      appBar: ZiAppBarB(title: item.title, centerTitle: true),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: context.responsivePadding(horizontal: 0.04, vertical: 0.018),
        children: [
          if (item.arabic.isNotEmpty)
            _sectionCard(
              context,
              title: 'Arabic',
              child: Directionality(
                textDirection: ui.TextDirection.rtl,
                child: SelectableText(
                  item.arabic,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primaryDark,
                    fontSize: context.scaledFont(28),
                    height: 1.8,
                    fontFamily: 'NotoNaskhArabic',
                  ),
                ),
              ),
            ),
          if (item.urdu.isNotEmpty)
            _sectionCard(
              context,
              title: 'Urdu',
              child: SelectableText(
                item.urdu,
                textDirection: ui.TextDirection.rtl,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: context.scaledFont(16),
                  height: 1.8,
                ),
              ),
            ),
          if (item.english.isNotEmpty)
            _sectionCard(
              context,
              title: 'Meaning',
              child: SelectableText(
                item.english,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: context.scaledFont(15),
                  height: 1.6,
                ),
              ),
            ),
          if (item.reference.isNotEmpty)
            _sectionCard(
              context,
              title: 'Reference',
              child: Text(
                item.reference,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: context.scaledFont(14),
                ),
              ),
            ),
          if (item.extraFields.isNotEmpty)
            _sectionCard(
              context,
              title: 'Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.extraFields.entries
                    .map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(
                          bottom: context.heightPct(0.012),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatLabel(entry.key),
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: context.scaledFont(13),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: context.heightPct(0.004)),
                            Text(
                              _formatValue(entry.value),
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: context.scaledFont(14),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          if (item.steps.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(
                top: context.heightPct(0.01),
                bottom: context.heightPct(0.012),
              ),
              child: Text(
                'Steps',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: context.scaledFont(18),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            ...item.steps.map(
              (step) => _sectionCard(
                context,
                title: step.title.isEmpty
                    ? 'Step ${step.stepNumber}'
                    : step.title,
                child: Text(
                  step.detail,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: context.scaledFont(14),
                    height: 1.55,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.only(bottom: context.heightPct(0.014)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.widthPct(0.04)),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: Padding(
        padding: context.responsiveAll(0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: context.scaledFont(14),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: context.heightPct(0.008)),
            child,
          ],
        ),
      ),
    );
  }

  String _formatLabel(String value) {
    return value
        .split('_')
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) => '${match[1]} ${match[2]}')}',
        )
        .join(' ');
  }

  String _formatValue(dynamic value) {
    if (value is List) {
      return value.map((item) => '- ${item.toString()}').join('\n');
    }
    if (value is bool) return value ? 'Yes' : 'No';
    return value?.toString() ?? '';
  }
}
