import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:islam786/features_slices/View/Duas/Controller/dua_controller.dart';

class TodayDuaCard extends StatelessWidget {
  final DuaController controller;

  const TodayDuaCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: context.responsivePadding(horizontal: 0.035, vertical: 0.020),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(context.widthPct(0.035)),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: context.widthPct(0.075),
                height: context.widthPct(0.075),
                decoration: BoxDecoration(
                  color: AppColors.softGreenGradient.colors.first,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.primary,
                  size: context.scaledFont(20),
                ),
              ),
              SizedBox(width: context.widthPct(0.020)),
              Text(
                "Today's Dua",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: context.scaledFont(13),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.iconSecondary,
                size: context.scaledFont(23),
              ),
            ],
          ),

          SizedBox(height: context.heightPct(0.018)),

          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              controller.todayDua?.arabic ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: context.scaledFont(21),
                height: 1.9,
                fontWeight: FontWeight.w500,
                fontFamily: 'NotoNaskhArabic',
              ),
            ),
          ),

          SizedBox(height: context.heightPct(0.018)),

          Container(height: 1, color: AppColors.cardBorder),

          SizedBox(height: context.heightPct(0.012)),

          Row(
            children: [
              Expanded(
                child: Obx(
                  () => _actionButton(
                    context,
                    icon: controller.isTodayDuaFavorite.value
                        ? Icons.bookmark_rounded
                        : Icons.bookmark_border_rounded,
                    title: controller.isTodayDuaFavorite.value
                        ? 'Saved'
                        : 'Favorites',
                    onTap: controller.toggleTodayFavorite,
                  ),
                ),
              ),
              Expanded(
                child: _actionButton(
                  context,
                  icon: Icons.share_rounded,
                  title: 'Share',
                  onTap: () async {
                    await Clipboard.setData(
                      ClipboardData(text: controller.todayDua?.arabic ?? ''),
                    );

                    AppSnackbar.success('Dua copied to clipboard');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.widthPct(0.025)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.heightPct(0.006)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: context.scaledFont(19),
              color: AppColors.iconPrimary,
            ),
            SizedBox(width: context.widthPct(0.020)),
            Text(
              title,
              style: TextStyle(
                fontSize: context.scaledFont(12),
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
