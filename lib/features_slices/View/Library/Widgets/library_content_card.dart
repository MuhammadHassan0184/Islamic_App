import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Data/Models/library_content_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

class LibraryContentCard extends StatelessWidget {
  const LibraryContentCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final LibraryContentModel item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.only(bottom: context.heightPct(0.012)),
      elevation: 2,
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(context.widthPct(0.04)),
      //   side: const BorderSide(color: AppColors.cardBorder),
      // ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.widthPct(0.04)),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
              if (item.arabic.isNotEmpty) ...[
                SizedBox(height: context.heightPct(0.009)),
                Directionality(
                  textDirection: ui.TextDirection.rtl,
                  child: Text(
                    item.arabic,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: context.scaledFont(20),
                      height: 1.7,
                      fontFamily: 'NotoNaskhArabic',
                    ),
                  ),
                ),
              ],
              if (item.english.isNotEmpty) ...[
                SizedBox(height: context.heightPct(0.008)),
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
              ],
              if (item.category.isNotEmpty || item.steps.isNotEmpty) ...[
                SizedBox(height: context.heightPct(0.012)),
                Row(
                  children: [
                    if (item.category.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.widthPct(0.027),
                          vertical: context.heightPct(0.006),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.softGreenGradient.colors.first,
                          borderRadius: BorderRadius.circular(
                            context.widthPct(0.05),
                          ),
                        ),
                        child: Text(
                          _formatCategory(item.category),
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: context.scaledFont(11),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const Spacer(),
                    if (item.steps.isNotEmpty)
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
            ],
          ),
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
