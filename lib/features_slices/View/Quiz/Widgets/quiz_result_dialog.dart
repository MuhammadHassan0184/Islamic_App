import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Config/Colors/app_colors.dart';
import '../../../../Utils/mediaquery_extension.dart';
import '../Controller/quiz_controller.dart';

class QuizResultDialog extends StatelessWidget {
  final QuizController controller;

  const QuizResultDialog({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final score = controller.score.value;
    final total = controller.totalQuestions;
    final percentage = total > 0 ? (score / total) * 100 : 0.0;

    String headline = 'MashaAllah! Excellent!';
    String message = 'You have a deep understanding of Islamic knowledge.';
    IconData icon = Icons.emoji_events_rounded;
    Color color = AppColors.success;

    if (percentage < 50) {
      headline = 'Keep Learning!';
      message = 'Review the questions and explanations to strengthen your knowledge.';
      icon = Icons.auto_stories_rounded;
      color = AppColors.warning;
    } else if (percentage < 80) {
      headline = 'Well Done!';
      message = 'Good job! A little more study will make it perfect.';
      icon = Icons.thumb_up_alt_rounded;
      color = AppColors.primaryGreen;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: AppColors.white,
      insetPadding: context.responsivePadding(horizontal: 0.06),
      child: Padding(
        padding: context.responsivePadding(horizontal: 0.06, vertical: 0.03),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: context.scaledFont(76),
              height: context.scaledFont(76),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: context.scaledFont(40), color: color),
            ),
            SizedBox(height: context.heightPct(0.02)),
            Text(
              headline,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: context.scaledFont(20),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.heightPct(0.008)),
            Text(
              message,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(13),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.heightPct(0.024)),
            Container(
              width: double.infinity,
              padding: context.responsivePadding(
                horizontal: 0.04,
                vertical: 0.018,
              ),
              decoration: BoxDecoration(
                gradient: AppColors.softGreenGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _statItem(
                    context,
                    label: 'Score',
                    value: '$score / $total',
                    color: AppColors.darkGreen,
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: AppColors.primaryGreen.withValues(alpha: 0.3),
                  ),
                  _statItem(
                    context,
                    label: 'Percentage',
                    value: '${percentage.toStringAsFixed(0)}%',
                    color: AppColors.darkGreen,
                  ),
                ],
              ),
            ),
            SizedBox(height: context.heightPct(0.028)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryGreen),
                      padding: EdgeInsets.symmetric(
                        vertical: context.heightPct(0.015),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      controller.restartQuiz();
                    },
                    child: Text(
                      'Try Again',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: context.scaledFont(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: context.widthPct(0.03)),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: AppColors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: context.heightPct(0.015),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                        fontSize: context.scaledFont(14),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statItem(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: context.scaledFont(20),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: context.scaledFont(12),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
