
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
    return Row(
      children: [
        Container(
          width: 4,
          height: context.scaledFont(21),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(width: context.widthPct(0.022)),
        Text(
          title,
          style: TextStyle(
            color: const Color(0xFF01463D),
            fontSize: context.scaledFont(20),
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
      ],
    );
  }
}
