import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Data/Models/adaab_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

class AdaabDetailScreen extends StatelessWidget {
  const AdaabDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final item = Get.arguments is AdaabModel
        ? Get.arguments as AdaabModel
        : null;

    if (item == null) {
      return Scaffold(
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
          title: const Text('Adaab'),
        ),
        body: const Center(child: Text('Adaab not found.')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
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
      body: ListView(
        padding: context.responsivePadding(horizontal: 0.04, vertical: 0.018),
        children: [
          Container(
            width: double.infinity,
            padding: context.responsiveAll(0.045),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(context.widthPct(0.04)),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
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
                  Text(
                    item.urdu,
                    textDirection: TextDirection.rtl,
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
                      color: AppColors.softGreenGradient.colors.first,
                      borderRadius: BorderRadius.circular(
                        context.widthPct(0.03),
                      ),
                    ),
                    child: Text(
                      'Reference: ${item.reference}',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: context.scaledFont(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (item.steps.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.025)),
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
                margin: EdgeInsets.only(bottom: context.heightPct(0.012)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.widthPct(0.035)),
                  side: const BorderSide(color: AppColors.cardBorder),
                ),
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
