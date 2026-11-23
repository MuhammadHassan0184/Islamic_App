import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

import '../Controller/home_controller.dart';

class HomeHeader extends StatelessWidget {
  final HomeController controller;

  const HomeHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedSwitcher(
        duration: const Duration(milliseconds: 220),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        child: SizedBox(
          key: ValueKey(controller.isSearchOpen.value),
          height: context.heightPct(0.055),
          child: Row(
            children: [
              _HeaderIconButton(
                icon: Icons.menu_rounded,
                onTap: controller.openDrawer,
              ),
              SizedBox(width: context.widthPct(0.025)),
              if (controller.isSearchOpen.value)
                Expanded(child: _searchField(context))
              else ...[
                const Spacer(),
                Text(
                  'Hafiz',
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: context.scaledFont(19),
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                const Spacer(),
                _HeaderIconButton(
                  icon: Icons.search_rounded,
                  onTap: controller.openSearch,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchField(BuildContext context) {
    return TextField(
      controller: controller.searchTextController,
      autofocus: true,
      textInputAction: TextInputAction.search,
      onChanged: (value) => controller.searchQuery.value = value,
      style: TextStyle(
        color: AppColors.textPrimary,
        fontSize: context.scaledFont(14),
      ),
      decoration: InputDecoration(
        hintText: 'Search Quran, Duas, and more...',
        hintStyle: TextStyle(
          color: AppColors.textSecondary,
          fontSize: context.scaledFont(13),
        ),
        prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
        suffixIcon: IconButton(
          tooltip: 'Close search',
          onPressed: controller.closeSearch,
          icon: const Icon(Icons.close_rounded),
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.white,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(
          vertical: context.heightPct(0.012),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.widthPct(0.04)),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.widthPct(0.04)),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.widthPct(0.04)),
          borderSide: const BorderSide(color: AppColors.primaryLight),
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: EdgeInsets.all(context.widthPct(0.012)),
          child: Icon(
            icon,
            color: const Color(0xFF2E2E2E),
            size: context.scaledFont(25),
          ),
        ),
      ),
    );
  }
}
