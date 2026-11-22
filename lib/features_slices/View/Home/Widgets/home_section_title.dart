
import 'package:flutter/material.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

class HomeSectionTitle extends StatelessWidget {
  final String title;

  const HomeSectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.darkGreen,
        fontSize: context.scaledFont(19),
        fontWeight: FontWeight.w800,
        letterSpacing: -0.3,
      ),
    );
  }
}
