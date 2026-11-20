import 'package:flutter/material.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/features_slices/View/Duas/Controller/dua_controller.dart';

class DuaCategoryCard extends StatelessWidget {
  final DuaCategory category;
  final VoidCallback onTap;

  const DuaCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: context.heightPct(0.13),
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Color(category.colorValue),
          borderRadius: BorderRadius.circular(context.widthPct(0.030)),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (category.image != null)
              Image.asset(
                category.image!,
                fit: BoxFit.cover,
                cacheWidth:
                    (MediaQuery.sizeOf(context).width *
                            MediaQuery.devicePixelRatioOf(context))
                        .round(),
                errorBuilder: (context, error, stackTrace) {
                  return Container(color: Color(category.colorValue));
                },
              ),

            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.20),
                    Colors.black.withValues(alpha: 0.48),
                  ],
                ),
              ),
            ),

            Padding(
              padding: context.responsivePadding(
                horizontal: 0.040,
                vertical: 0.015,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    category.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: context.scaledFont(18),
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(0.025),
                        vertical: context.heightPct(0.0025),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.48),
                        borderRadius: BorderRadius.circular(
                          context.widthPct(0.04),
                        ),
                      ),
                      child: Text(
                        category.count.toString(),
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: context.scaledFont(10),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
