import 'package:flutter/material.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Data/Models/library_collection_model.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

class LibraryCollectionCard extends StatelessWidget {
  const LibraryCollectionCard({
    super.key,
    required this.collection,
    required this.itemCount,
    required this.onTap,
  });

  final LibraryCollectionModel collection;
  final int itemCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.zero,
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
              Container(
                padding: context.responsiveAll(0.025),
                decoration: BoxDecoration(
                  color: AppColors.softGreenGradient.colors.first,
                  borderRadius: BorderRadius.circular(context.widthPct(0.03)),
                ),
                child: Icon(
                  collection.icon,
                  color: AppColors.primary,
                  size: context.widthPct(0.075),
                ),
              ),
              SizedBox(height: context.heightPct(0.014)),
              Text(
                collection.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: context.scaledFont(15),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: context.heightPct(0.006)),
              Expanded(
                child: Text(
                  collection.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: context.scaledFont(12),
                    height: 1.4,
                  ),
                ),
              ),
              Text(
                '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: context.scaledFont(12),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
