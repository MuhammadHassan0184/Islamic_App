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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.widthPct(0.04)),
        side: const BorderSide(color: AppColors.cardBorder),
      ),
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
              if (item.category.isNotEmpty) ...[
                SizedBox(height: context.heightPct(0.012)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
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
