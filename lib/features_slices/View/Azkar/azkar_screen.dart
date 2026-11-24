import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Azkar/Controller/azkar_controller.dart';
import 'package:islam786/features_slices/View/Azkar/Widgets/zikr_card.dart';
import 'Widgets/azkar_responsive.dart';

class AzkarScreen extends GetView<AzkarController> {
  const AzkarScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Azkar',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: azkarFontSize(context, 22),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: context.heightPct(0.004)),
                              Text(
                                'Remember Allah at your own pace',
                                style: TextStyle(
                                  color: AppColors.white.withValues(
                                    alpha: 0.82,
                                  ),
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
                Padding(
                  padding: context.responsivePadding(
                    horizontal: 0.04,
                    vertical: 0.014,
                  ),
                  child: TextField(
                    onChanged: (value) => controller.searchQuery.value = value,
                    decoration: InputDecoration(
                      hintText: 'Search Azkar',
                      prefixIcon: const Icon(Icons.search_rounded),
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
                Obx(() {
                  if (controller.categories.length < 2) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: context.heightPct(0.052),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(0.04),
                      ),
                      children: [
                        _categoryChip(context, '', 'All'),
                        ...controller.categories.map(
                          (category) => _categoryChip(
                            context,
                            category,
                            _formatCategory(category),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (controller.errorMessage.value.isNotEmpty) {
                      return _errorState(context);
                    }
                    if (controller.filteredAzkar.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            controller.azkar.isEmpty
                                ? 'No Azkar are available yet.'
                                : 'No Azkar match your search.',
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
                        final items = controller.filteredAzkar;

                        if (columns == 1) {
                          return ListView.builder(
                            padding: context.responsivePadding(
                              horizontal: 0.035,
                              vertical: 0.008,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) => ZikrCard(
                              zikr: items[index],
                              controller: controller,
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: context.responsivePadding(
                            horizontal: 0.025,
                            vertical: 0.008,
                          ),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 4,
                                childAspectRatio: 0.75,
                              ),
                          itemCount: items.length,
                          itemBuilder: (context, index) => ZikrCard(
                            zikr: items[index],
                            controller: controller,
                          ),
                        );
                      },
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
            fontSize: azkarFontSize(context, 12),
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
          side: BorderSide(
            color: selected ? AppColors.primaryLight : AppColors.cardBorder,
          ),
        ),
      );
    });
  }

  Widget _errorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
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
                fontSize: azkarFontSize(context, 14),
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controller.loadAzkar,
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
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
