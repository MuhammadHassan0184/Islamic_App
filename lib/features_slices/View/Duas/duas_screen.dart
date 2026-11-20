import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Config/Routes/app_routes.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

import 'package:islam786/features_slices/View/Duas/Controller/dua_controller.dart';
import 'package:islam786/features_slices/View/Duas/Widgets/dua_category_card.dart';
import 'package:islam786/features_slices/View/Duas/Widgets/dua_header.dart';
import 'package:islam786/features_slices/View/Duas/Widgets/today_dua_card.dart';

class DuaScreen extends GetView<DuaController> {
  const DuaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          DuaHeader(controller: controller),

          Expanded(
            child: Obx(() {
              if (controller.selectedTab.value == 0) {
                return _buildCategories(context);
              }

              return _buildFavorites(context);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 48),
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
              ElevatedButton(
                onPressed: controller.loadDuas,
                style: ElevatedButton.styleFrom(
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

    return ListView(
      padding: context.responsivePadding(horizontal: 0.035, vertical: 0.018),
      children: [
        TextField(
          onChanged: (value) => controller.searchQuery.value = value,
          decoration: InputDecoration(
            hintText: 'Search Duas',
            prefixIcon: const Icon(Icons.search_rounded),
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.widthPct(0.025)),
              borderSide: BorderSide(color: AppColors.cardBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.widthPct(0.025)),
              borderSide: BorderSide(color: AppColors.cardBorder),
            ),
          ),
        ),

        SizedBox(height: context.heightPct(0.018)),

        if (controller.searchQuery.value.trim().isNotEmpty)
          ...controller.searchResults.map(
            (dua) => Padding(
              padding: EdgeInsets.only(bottom: context.heightPct(0.012)),
              child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      dua.arabic,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 20,
                        height: 1.8,
                        fontFamily: 'NotoNaskhArabic',
                      ),
                    ),
                  ),
                  subtitle: Text(
                    dua.title,
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Get.toNamed(AppRoutes.duaDetail, arguments: dua),
                ),
              ),
            ),
          )
        else ...[
          GestureDetector(
            onTap: () {
              final dua = controller.todayDua;
              if (dua != null) {
                Get.toNamed(AppRoutes.duaDetail, arguments: dua);
              }
            },
            child: TodayDuaCard(controller: controller),
          ),

          SizedBox(height: context.heightPct(0.018)),

          ...controller.categories.map(
            (category) => Padding(
              padding: EdgeInsets.only(bottom: context.heightPct(0.012)),
              child: DuaCategoryCard(
                category: category,
                onTap: () {
                  controller.openCategory(category);
                },
              ),
            ),
          ),
        ],

        SizedBox(height: context.heightPct(0.015)),
      ],
    );
  }

  Widget _buildFavorites(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.favoriteDuas.isEmpty) {
        return Center(
          child: Padding(
            padding: context.responsivePadding(
              horizontal: 0.08,
              vertical: 0.04,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: context.widthPct(0.20),
                  height: context.widthPct(0.20),
                  decoration: BoxDecoration(
                    color: AppColors.softGreenGradient.colors.first,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.bookmark_border_rounded,
                    color: AppColors.primary,
                    size: context.scaledFont(42),
                  ),
                ),

                SizedBox(height: context.heightPct(0.020)),

                Text(
                  'No Favorites Yet',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: context.scaledFont(18),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: context.heightPct(0.008)),

                Text(
                  'Save your favorite Duas and find them here whenever you need them.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: context.scaledFont(13),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return ListView(
        padding: context.responsivePadding(horizontal: 0.035, vertical: 0.018),
        children: controller.favoriteDuas.map((dua) {
          return Card(
            margin: EdgeInsets.only(bottom: context.heightPct(0.012)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Directionality(
                textDirection: TextDirection.rtl,
                child: Text(
                  dua.arabic,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.8,
                    fontFamily: 'NotoNaskhArabic',
                  ),
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(dua.title),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(AppRoutes.duaDetail, arguments: dua),
            ),
          );
        }).toList(),
      );
    });
  }
}
