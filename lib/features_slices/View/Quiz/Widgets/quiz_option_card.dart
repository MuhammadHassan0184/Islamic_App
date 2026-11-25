import 'package:flutter/material.dart';
import '../../../../Config/Colors/app_colors.dart';
import '../../../../Utils/mediaquery_extension.dart';

class QuizOptionCard extends StatelessWidget {
  final int index;
  final String text;
  final bool isSelected;
  final bool isSubmitted;
  final bool isCorrect;
  final VoidCallback onTap;

  const QuizOptionCard({
    super.key,
    required this.index,
    required this.text,
    required this.isSelected,
    required this.isSubmitted,
    required this.isCorrect,
    required this.onTap,
  });

  String get _optionLabel {
    const labels = ['A', 'B', 'C', 'D', 'E', 'F'];
    if (index >= 0 && index < labels.length) {
      return labels[index];
    }
    return '${index + 1}';
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = AppColors.white;
    Color borderColor = const Color(0xFFE2E8F0);
    Color textColor = AppColors.textPrimary;
    Color labelBgColor = const Color(0xFFF1F5F9);
    Color labelTextColor = const Color(0xFF475569);
    Widget? trailingIcon;

    if (isSubmitted) {
      if (isCorrect) {
        backgroundColor = const Color(0xFFE8F5E9);
        borderColor = AppColors.success;
        textColor = const Color(0xFF1B5E20);
        labelBgColor = AppColors.success;
        labelTextColor = AppColors.white;
        trailingIcon = const Icon(
          Icons.check_circle_rounded,
          color: AppColors.success,
          size: 22,
        );
      } else if (isSelected) {
        backgroundColor = const Color(0xFFFFEBEE);
        borderColor = AppColors.error;
        textColor = const Color(0xFFB71C1C);
        labelBgColor = AppColors.error;
        labelTextColor = AppColors.white;
        trailingIcon = const Icon(
          Icons.cancel_rounded,
          color: AppColors.error,
          size: 22,
        );
      }
    } else if (isSelected) {
      backgroundColor = const Color(0xFFE8F3E3);
      borderColor = AppColors.primaryGreen;
      textColor = AppColors.darkGreen;
      labelBgColor = AppColors.primaryGreen;
      labelTextColor = AppColors.white;
      trailingIcon = const Icon(
        Icons.radio_button_checked_rounded,
        color: AppColors.primaryGreen,
        size: 22,
      );
    } else {
      trailingIcon = const Icon(
        Icons.radio_button_unchecked_rounded,
        color: Color(0xFFCBD5E1),
        size: 22,
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: context.heightPct(0.012)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isSubmitted ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(0.04),
              vertical: context.heightPct(0.016),
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: borderColor,
                width: isSelected || (isSubmitted && isCorrect) ? 1.8 : 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: context.scaledFont(34),
                  height: context.scaledFont(34),
                  decoration: BoxDecoration(
                    color: labelBgColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _optionLabel,
                    style: TextStyle(
                      color: labelTextColor,
                      fontSize: context.scaledFont(14),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: context.widthPct(0.035)),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: context.scaledFont(15),
                      fontWeight:
                          isSelected || (isSubmitted && isCorrect)
                              ? FontWeight.w600
                              : FontWeight.w500,
                      height: 1.3,
                    ),
                  ),
                ),
                if (trailingIcon != null) ...[
                  SizedBox(width: context.widthPct(0.02)),
                  trailingIcon,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
