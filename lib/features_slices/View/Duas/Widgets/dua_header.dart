import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Duas/Controller/dua_controller.dart';

class DuaHeader extends StatelessWidget {
  final DuaController controller;

  const DuaHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.primaryGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: context.responsivePadding(
                horizontal: 0.035,
                vertical: 0.012,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (Navigator.of(context).canPop())
                    IconButton(
                      tooltip: 'Back',
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.white,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      'Dua',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: context.scaledFont(18),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (Navigator.of(context).canPop())
                    SizedBox(width: context.widthPct(0.12)),
                ],
              ),
            ),

            Obx(
              () => Row(
                children: [
                  _buildTab(context, title: 'Categories', index: 0),
                  _buildTab(context, title: 'Favorite', index: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String title,
    required int index,
  }) {
    final bool isSelected = controller.selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: context.heightPct(0.017)),
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? AppColors.white : AppColors.inactiveTab,
                  fontSize: context.scaledFont(14),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            Container(
              height: context.heightPct(0.003),
              width: context.widthPct(0.25),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.tabIndicator : Colors.transparent,
                borderRadius: BorderRadius.circular(context.widthPct(0.02)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
