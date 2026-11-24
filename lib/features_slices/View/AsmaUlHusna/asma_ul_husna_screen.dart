import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Data/Models/asma_ul_husna_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/AsmaUlHusna/Controller/asma_ul_husna_controller.dart';
import 'package:zi_core/zi_core_io.dart';

class AsmaUlHusnaScreen extends GetView<AsmaUlHusnaController> {
  const AsmaUlHusnaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ZiScaffoldB(
      showPagePadding: false,
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Home_bg_image.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: Colors.white);
            },
          ),
          SafeArea(
            child: Column(
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
                                onPressed: () =>
                                    Navigator.of(context).maybePop(),
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          Column(
                            children: [
                              Text(
                                'Asma-ul-Husna',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: context.scaledFont(22),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: context.heightPct(0.005)),
                              Text(
                                'Discover the beautiful names of Allah',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.white.withValues(
                                    alpha: 0.82,
                                  ),
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
                      hintText: 'Search names',
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          context.widthPct(0.03),
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.cardBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          context.widthPct(0.03),
                        ),
                        borderSide: const BorderSide(
                          color: AppColors.cardBorder,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }
                    if (controller.errorMessage.value.isNotEmpty) {
                      return _errorState(context);
                    }

                    return Column(
                      children: [
                        if (controller.categories.length > 1)
                          _categoryChips(context),
                        Expanded(child: _namesList(context)),
                      ],
                    );
                  }),
                ),
              ],
            ),
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

  Widget _namesList(BuildContext context) {
    final items = controller.filteredNames;
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: context.responsiveAll(0.06),
          child: Text(
            controller.names.isEmpty
                ? 'No names are available yet.'
                : 'No names match your search.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: context.scaledFont(14),
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 600
            ? 2
            : 1;

        if (columns == 1) {
          return ListView.builder(
            padding: context.responsivePadding(
              horizontal: 0.035,
              vertical: 0.008,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => _nameCard(context, items[index]),
          );
        }

        return GridView.builder(
          padding: context.responsivePadding(
            horizontal: 0.025,
            vertical: 0.008,
          ),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: context.widthPct(0.02),
            mainAxisSpacing: context.heightPct(0.012),
            childAspectRatio: 0.82,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) => _nameCard(context, items[index]),
        );
      },
    );
  }

  Widget _nameCard(BuildContext context, AsmaUlHusnaModel item) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      margin: context.isMobile
          ? EdgeInsets.only(bottom: context.heightPct(0.012))
          : EdgeInsets.zero,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(context.widthPct(0.04)),
      //   side: const BorderSide(color: AppColors.cardBorder),
      // ),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.widthPct(0.04)),
        onTap: () => Get.toNamed(AppRoutes.asmaUlHusnaDetail, arguments: item),
        child: Padding(
          padding: context.responsiveAll(context.isMobile ? 0.04 : 0.025),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: context.widthPct(0.105),
                    height: context.widthPct(0.105),
                    decoration: BoxDecoration(
                      color: AppColors.softGreenGradient.colors.first,
                      borderRadius: BorderRadius.circular(
                        context.widthPct(0.03),
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${item.number}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: context.scaledFont(15),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  SizedBox(width: context.widthPct(0.03)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: context.scaledFont(16),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          item.transliteration,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: context.scaledFont(12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.primary),
                ],
              ),
              SizedBox(height: context.heightPct(0.012)),
              SizedBox(
                height: context.isMobile
                    ? context.heightPct(0.08)
                    : context.heightPct(0.12),
                child: Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Center(
                    child: Text(
                      item.arabic,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: context.scaledFont(30),
                        height: 1.6,
                        fontFamily: 'NotoNaskhArabic',
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                item.english,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: context.scaledFont(13),
                  height: 1.45,
                ),
              ),
            ],
          ),
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
            const Icon(
              Icons.cloud_off_rounded,
              color: AppColors.textSecondary,
              size: 48,
            ),
            SizedBox(height: context.heightPct(0.015)),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(14),
              ),
            ),
            SizedBox(height: context.heightPct(0.015)),
            FilledButton(
              onPressed: controller.loadNames,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
              ),
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
