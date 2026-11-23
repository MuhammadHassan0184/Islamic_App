import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Data/Models/adaab_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Adaab/Controller/adaab_controller.dart';

class AdaabScreen extends GetView<AdaabController> {
  const AdaabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.primaryGradient,
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: context.responsivePadding(
                  horizontal: 0.05,
                  vertical: 0.022,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (Navigator.of(context).canPop())
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          tooltip: 'Back',
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    Column(
                      children: [
                        Text(
                          'Adaab',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: context.scaledFont(22),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Beautiful manners for everyday life',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.82),
                            fontSize: context.scaledFont(12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: context.responsivePadding(
              horizontal: 0.04,
              vertical: 0.014,
            ),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Search Adaab',
                prefixIcon: const Icon(Icons.search_rounded),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.widthPct(0.03)),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(context.widthPct(0.03)),
                  borderSide: const BorderSide(color: AppColors.cardBorder),
                ),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.errorMessage.value.isNotEmpty) {
                return _errorState(context);
              }

              return Column(
                children: [
                  if (controller.categories.length > 1) _categoryChips(context),
                  Expanded(child: _adaabList(context)),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _categoryChips(BuildContext context) {
    return SizedBox(
      height: context.heightPct(0.052),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.04)),
        children: [
          _categoryChip(context, '', 'All'),
          ...controller.categories.map(
            (category) =>
                _categoryChip(context, category, _formatCategory(category)),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(BuildContext context, String value, String label) {
    return Obx(() {
      final selected = controller.selectedCategory.value == value;
      return Padding(
        padding: EdgeInsets.only(right: context.widthPct(0.02)),
        child: ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => controller.selectCategory(value),
          selectedColor: AppColors.softGreenGradient.colors.last,
          labelStyle: TextStyle(
            color: selected ? AppColors.primary : AppColors.textSecondary,
            fontSize: context.scaledFont(12),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
          side: BorderSide(
            color: selected ? AppColors.primaryLight : AppColors.cardBorder,
          ),
        ),
      );
    });
  }

  Widget _adaabList(BuildContext context) {
    final items = controller.filteredAdaab;
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: context.responsiveAll(0.06),
          child: Text(
            controller.adaab.isEmpty
                ? 'No Adaab are available yet.'
                : 'No Adaab match your search.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: context.scaledFont(14),
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: context.responsivePadding(horizontal: 0.035, vertical: 0.008),
      itemCount: items.length,
      itemBuilder: (context, index) => _adaabCard(context, items[index]),
    );
  }

  Widget _adaabCard(BuildContext context, AdaabModel item) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.only(bottom: context.heightPct(0.012)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.widthPct(0.04)),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.widthPct(0.04)),
        onTap: () => Get.toNamed(AppRoutes.adaabDetail, arguments: item),
        child: Padding(
          padding: context.responsiveAll(0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: context.scaledFont(16),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.primary),
                ],
              ),
              SizedBox(height: context.heightPct(0.01)),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  item.arabic,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: context.scaledFont(21),
                    height: 1.8,
                    fontFamily: 'NotoNaskhArabic',
                  ),
                ),
              ),
              SizedBox(height: context.heightPct(0.01)),
              Text(
                item.english,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: context.scaledFont(14),
                  height: 1.5,
                ),
              ),
              SizedBox(height: context.heightPct(0.012)),
              Row(
                children: [
                  _categoryLabel(context, item.category),
                  const Spacer(),
                  Text(
                    '${item.steps.length} ${item.steps.length == 1 ? 'step' : 'steps'}',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: context.scaledFont(12),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _categoryLabel(BuildContext context, String category) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(0.027),
        vertical: context.heightPct(0.006),
      ),
      decoration: BoxDecoration(
        color: AppColors.softGreenGradient.colors.first,
        borderRadius: BorderRadius.circular(context.widthPct(0.05)),
      ),
      child: Text(
        _formatCategory(category),
        style: TextStyle(
          color: AppColors.primary,
          fontSize: context.scaledFont(11),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _errorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.responsiveAll(0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(14),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controller.loadAdaab,
              style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCategory(String category) {
    return category
        .split('_')
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
