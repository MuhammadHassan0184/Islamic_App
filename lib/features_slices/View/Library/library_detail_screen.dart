import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Data/Models/library_content_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Library/Widgets/library_page_header.dart';
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
      showPagePadding: false,
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          LibraryPageHeader(
            title: item.title,
            subtitle: item.category.isEmpty
                ? 'Islamic Library'
                : _formatLabel(item.category),
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: context.responsivePadding(
                horizontal: 0.04,
                vertical: 0.018,
              ),
              children: [
                _mainContentCard(context, item),
                SizedBox(height: context.heightPct(0.02)),
                if (item.extraFields.isNotEmpty)
                  _sectionCard(
                    context,
                    title: 'Details',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: item.extraFields.entries
                          .map(
                            (entry) =>
                                _detailRow(context, entry.key, entry.value),
                          )
                          .toList(),
                    ),
                  ),
                if (item.steps.isNotEmpty) ...[
                  SizedBox(height: context.heightPct(0.008)),
                  Text(
                    'Practice step by step',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: context.scaledFont(18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: context.heightPct(0.012)),
                  ...item.steps.map(
                    (step) => Card(
                      color: AppColors.white,
                      // elevation: 2,
                      margin: EdgeInsets.only(bottom: context.heightPct(0.012)),
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(
                      //     context.widthPct(0.035),
                      //   ),
                      //   side: const BorderSide(color: AppColors.cardBorder),
                      // ),
                      child: Padding(
                        padding: context.responsiveAll(0.04),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: context.widthPct(0.055),
                              backgroundColor:
                                  AppColors.softGreenGradient.colors.first,
                              foregroundColor: AppColors.primary,
                              child: Text('${step.stepNumber}'),
                            ),
                            SizedBox(width: context.widthPct(0.035)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    step.title.isEmpty
                                        ? 'Step ${step.stepNumber}'
                                        : step.title,
                                    style: TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: context.scaledFont(14),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (step.detail.isNotEmpty) ...[
                                    SizedBox(height: context.heightPct(0.008)),
                                    Text(
                                      step.detail,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: context.scaledFont(14),
                                        height: 1.55,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _mainContentCard(BuildContext context, LibraryContentModel item) {
    return Container(
      width: double.infinity,
      padding: context.responsiveAll(0.045),
      decoration: BoxDecoration(
        gradient: AppColors.softGreenGradient,
        borderRadius: BorderRadius.circular(context.widthPct(0.04)),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (item.arabic.isNotEmpty)
            Directionality(
              textDirection: ui.TextDirection.rtl,
              child: SelectableText(
                item.arabic,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: context.scaledFont(25),
                  height: 1.9,
                  fontFamily: 'NotoNaskhArabic',
                ),
              ),
            ),
          if (item.urdu.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.022)),
            SelectableText(
              item.urdu,
              textDirection: ui.TextDirection.rtl,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: context.scaledFont(16),
                height: 1.8,
              ),
            ),
          ],
          if (item.english.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.017)),
            Text(
              'Meaning',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: context.scaledFont(13),
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: context.heightPct(0.005)),
            SelectableText(
              item.english,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(15),
                height: 1.6,
              ),
            ),
          ],
          if (item.reference.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.02)),
            Container(
              padding: context.responsiveAll(0.03),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(context.widthPct(0.03)),
              ),
              child: Text(
                'Reference: ${item.reference}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: context.scaledFont(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, dynamic value) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.heightPct(0.012)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatLabel(label),
            style: TextStyle(
              color: AppColors.primary,
              fontSize: context.scaledFont(13),
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: context.heightPct(0.004)),
          Text(
            _formatValue(value),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: context.scaledFont(14),
              height: 1.5,
            ),
          ),
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
      // elevation: 2,
      margin: EdgeInsets.only(bottom: context.heightPct(0.014)),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(context.widthPct(0.04)),
      //   side: const BorderSide(color: AppColors.cardBorder),
      // ),
      child: Padding(
        padding: context.responsiveAll(0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(
            //   title,
            //   style: TextStyle(
            //     color: AppColors.primary,
            //     fontSize: context.scaledFont(14),
            //     fontWeight: FontWeight.w700,
            //   ),
            // ),
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
