import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Data/Models/asma_ul_husna_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:zi_core/zi_core_io.dart';

class AsmaUlHusnaDetailScreen extends StatelessWidget {
  const AsmaUlHusnaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = Get.arguments is AsmaUlHusnaModel
        ? Get.arguments as AsmaUlHusnaModel
        : null;

    if (item == null) {
      return ZiScaffoldB(
        appBar: const ZiAppBarB(title: 'Asma-ul-Husna'),
        backgroundColor: AppColors.background,
        body: const Center(child: Text('Name not found.')),
      );
    }

    return ZiScaffoldB(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        leading: Navigator.of(context).canPop()
            ? IconButton(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
              )
            : null,
        title: Text(item.title),
        centerTitle: true,
      ),
      // ZiAppBarB(title: item.title, centerTitle: true, ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: context.responsivePadding(horizontal: 0.01, vertical: 0.018),
        children: [
          Container(
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
                Container(
                  width: context.widthPct(0.14),
                  height: context.widthPct(0.14),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${item.number}',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: context.scaledFont(18),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(height: context.heightPct(0.012)),
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: SelectableText(
                    item.arabic,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: context.scaledFont(32),
                      height: 1.8,
                      fontFamily: 'NotoNaskhArabic',
                    ),
                  ),
                ),
                SizedBox(height: context.heightPct(0.008)),
                Text(
                  item.transliteration,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: context.scaledFont(16),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (item.urdu.isNotEmpty) ...[
                  SizedBox(height: context.heightPct(0.02)),
                  Text(
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
                  SizedBox(height: context.heightPct(0.014)),
                  Text(
                    item.english,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: context.scaledFont(15),
                      height: 1.6,
                    ),
                  ),
                ],
                if (item.reference.isNotEmpty) ...[
                  SizedBox(height: context.heightPct(0.016)),
                  Container(
                    padding: context.responsiveAll(0.03),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        context.widthPct(0.025),
                      ),
                    ),
                    child: Text(
                      'Reference: ${item.reference}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: context.scaledFont(13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: context.heightPct(0.016)),
                FilledButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text:
                            '${item.arabic}\n${item.title}\n${item.transliteration}\n\n${item.urdu}\n\n${item.english}\n\n${item.reference}',
                      ),
                    );
                    AppSnackbar.success('Name copied to clipboard');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Copy name'),
                ),
              ],
            ),
          ),
          if (item.steps.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.025)),
            Text(
              'Meaning and practice',
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
                elevation: 2,
                margin: EdgeInsets.only(bottom: context.heightPct(0.012)),
                // shape: RoundedRectangleBorder(
                //   borderRadius: BorderRadius.circular(context.widthPct(0.035)),
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
                        child: Text('${step.stepNo}'),
                      ),
                      SizedBox(width: context.widthPct(0.035)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: context.scaledFont(14),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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
    );
  }
}
