import 'package:flutter/material.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Data/Models/library_collection_model.dart';

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;
        final scale = (cardWidth / 180).clamp(0.9, 1.1).toDouble();
        final iconSize = (cardWidth * 0.25).clamp(42.0, 50.0).toDouble();
        final padding = (cardWidth * 0.075).clamp(12.0, 16.0).toDouble();

        return Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          elevation: 2,
          shadowColor: AppColors.primaryDark.withValues(alpha: 0.12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.white,
                    Color(0xFFF5F9F1),
                    Color(0xFFEAF3E5),
                  ],
                ),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFDCE9D5)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withValues(alpha: 0.08),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: -34,
                    right: -26,
                    child: Container(
                      width: cardWidth * 0.55,
                      height: cardWidth * 0.55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.055),
                          width: 18,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: iconSize,
                              height: iconSize,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryDark.withValues(
                                      alpha: 0.18,
                                    ),
                                    blurRadius: 9,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                collection.icon,
                                color: AppColors.white,
                                size: iconSize * 0.48,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 27.0 * scale,
                              height: 27.0 * scale,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4D9),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.auto_awesome_rounded,
                                color: const Color(0xFFB58A38),
                                size: 15.0 * scale,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.0 * scale),
                        Text(
                          collection.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.primaryDark,
                            fontSize: 15.0 * scale,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.15,
                          ),
                        ),
                        SizedBox(height: 5.0 * scale),
                        Expanded(
                          child: Text(
                            collection.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11.5 * scale,
                              height: 1.35,
                            ),
                          ),
                        ),
                        SizedBox(height: 9.0 * scale),
                        Row(
                          children: [
                            Flexible(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 9.0 * scale,
                                  vertical: 6.0 * scale,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.white.withValues(alpha: 0.8),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  '$itemCount ${itemCount == 1 ? 'item' : 'items'}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.primaryDark,
                                    fontSize: 10.5 * scale,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.0 * scale),
                            Container(
                              width: 30.0 * scale,
                              height: 30.0 * scale,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(11),
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: AppColors.white,
                                size: 16.0 * scale,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
