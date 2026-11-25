import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Data/Models/dua_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:islam786/features_slices/View/Duas/Controller/dua_controller.dart';

class DuaDetailScreen extends GetView<DuaController> {
  const DuaDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dua = Get.arguments is DuaModel ? Get.arguments as DuaModel : null;

    if (dua == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Dua'),
          leading: Navigator.of(context).canPop()
              ? IconButton(
                  tooltip: 'Back',
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                )
              : null,
        ),
        body: const Center(child: Text('Dua not found.')),
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
        title: Text(dua.title),
        actions: [
          Obx(() {
            final saved = controller.favoriteDuas.any(
              (item) => item.id == dua.id,
            );
            return IconButton(
              tooltip: saved ? 'Remove favorite' : 'Add favorite',
              onPressed: () => controller.toggleFavorite(dua),
              icon: Icon(
                saved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
              ),
            );
          }),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppColors.softGreenGradient,
              borderRadius: BorderRadius.circular(context.widthPct(0.04)),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SelectableText(
                    dua.arabic,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      height: 1.9,
                      fontFamily: 'NotoNaskhArabic',
                    ),
                  ),
                ),
                if (dua.urdu.isNotEmpty) ...[
                  const SizedBox(height: 18),
                  Text(
                    dua.urdu,
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 16, height: 1.7),
                  ),
                ],
                if (dua.english.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    dua.english,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                ],
                if (dua.reference.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Container(
                    padding: context.responsiveAll(0.03),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(
                        context.widthPct(0.025),
                      ),
                    ),
                    child: Text(
                      'Reference: ${dua.reference}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: context.scaledFont(13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(
                      ClipboardData(
                        text:
                            '${dua.arabic}\n\n${dua.urdu}\n\n${dua.english}\n\n${dua.reference}',
                      ),
                    );
                    AppSnackbar.success('Dua copied to clipboard');
                  },
                  icon: const Icon(Icons.copy_rounded),
                  label: const Text('Copy Dua'),
                ),
              ],
            ),
          ),
          if (dua.steps.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Instructions',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            ...dua.steps.map(
              (step) => Card(
                color: AppColors.white,
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.softGreenGradient.colors.first,
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
    );
  }
}
