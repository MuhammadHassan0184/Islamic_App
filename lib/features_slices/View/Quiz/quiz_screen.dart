import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zi_core/zi_core_io.dart' hide TextDirection;
import '../../../../Config/Colors/app_colors.dart';
import '../../../../Utils/mediaquery_extension.dart';
import 'Controller/quiz_controller.dart';
import 'Widgets/quiz_option_card.dart';
import 'Widgets/quiz_result_dialog.dart';

class QuizScreen extends GetView<QuizController> {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // If controller is not yet registered (e.g. direct push)
    if (!Get.isRegistered<QuizController>()) {
      Get.put(QuizController(Get.find()));
    }

    // Listen for completion
    ever(controller.isFinished, (bool finished) {
      if (finished) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => QuizResultDialog(controller: controller),
        );
      }
    });

    return ZiScaffoldB(
      showPagePadding: false,
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/Home_bg_image.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(color: Colors.white);
            },
          ),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                _buildCategoryFilter(context),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.errorMessage.value.isNotEmpty) {
                      return _buildErrorState(context);
                    }

                    final question = controller.currentQuestion;
                    if (question == null) {
                      return _buildEmptyState(context);
                    }

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: context.responsivePadding(
                        horizontal: 0.045,
                        vertical: 0.012,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildQuestionMeta(context, question),
                          SizedBox(height: context.heightPct(0.016)),
                          _buildQuestionCard(context, question),
                          SizedBox(height: context.heightPct(0.022)),
                          _buildOptionsList(context, question),
                          if (controller.isSubmitted.value) ...[
                            SizedBox(height: context.heightPct(0.02)),
                            _buildExplanationCard(context, question),
                          ],
                          SizedBox(height: context.heightPct(0.03)),
                        ],
                      ),
                    );
                  }),
                ),
                _buildBottomActionBar(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: context.responsivePadding(
            horizontal: 0.04,
            vertical: 0.016,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.white,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Islamic Quiz',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: context.scaledFont(20),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Test & enhance your Islamic knowledge',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.85),
                            fontSize: context.scaledFont(12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(() {
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(0.03),
                        vertical: context.heightPct(0.006),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.stars_rounded,
                            color: AppColors.tabIndicator,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Score: ${controller.score.value}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: context.scaledFont(12),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
              SizedBox(height: context.heightPct(0.01)),
              Obx(() {
                final total = controller.totalQuestions;
                final current = controller.currentIndex.value + 1;
                final progress = controller.progress;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          total > 0 ? 'Question $current of $total' : 'Question 0 of 0',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.9),
                            fontSize: context.scaledFont(12),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.9),
                            fontSize: context.scaledFont(12),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withValues(alpha: 0.25),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.tabIndicator,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(BuildContext context) {
    return Obx(() {
      final cats = controller.categories;
      if (cats.length <= 1) return const SizedBox.shrink();

      return Container(
        height: context.heightPct(0.055),
        margin: EdgeInsets.symmetric(vertical: context.heightPct(0.008)),
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: context.widthPct(0.04)),
          itemCount: cats.length,
          separatorBuilder: (_, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final cat = cats[index];
            final isSelected = controller.selectedCategory.value == cat;
            final label = cat == 'All'
                ? 'All Categories'
                : cat
                    .replaceAll('_', ' ')
                    .split(' ')
                    .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
                    .join(' ');

            return ChoiceChip(
              label: Text(label),
              selected: isSelected,
              onSelected: (_) => controller.selectCategory(cat),
              selectedColor: AppColors.primaryGreen,
              backgroundColor: AppColors.white,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontSize: context.scaledFont(12),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? AppColors.primaryGreen : const Color(0xFFE2E8F0),
                ),
              ),
              showCheckmark: false,
            );
          },
        ),
      );
    });
  }

  Widget _buildQuestionMeta(BuildContext context, dynamic question) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(0.03),
            vertical: context.heightPct(0.006),
          ),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            question.categoryDisplayName,
            style: TextStyle(
              color: AppColors.primaryGreen,
              fontSize: context.scaledFont(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (question.reference.isNotEmpty)
          Row(
            children: [
              const Icon(
                Icons.bookmark_outline_rounded,
                size: 14,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                question.reference,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: context.scaledFont(11),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context, dynamic question) {
    return Container(
      width: double.infinity,
      padding: context.responsivePadding(
        horizontal: 0.045,
        vertical: 0.02,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: context.scaledFont(18),
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          if (question.arabic.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.016)),
            Container(
              width: double.infinity,
              padding: context.responsivePadding(
                horizontal: 0.035,
                vertical: 0.012,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAF7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8F3E3)),
              ),
              child: Text(
                question.arabic,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: AppColors.darkGreen,
                  fontSize: context.scaledFont(19),
                  fontWeight: FontWeight.w700,
                  height: 1.6,
                ),
              ),
            ),
          ],
          if (question.urdu.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.01)),
            Text(
              question.urdu,
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: const Color(0xFF475569),
                fontSize: context.scaledFont(14),
                height: 1.5,
              ),
            ),
          ],
          if (question.english.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.008)),
            Text(
              question.english,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(13),
                fontStyle: FontStyle.italic,
                height: 1.3,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionsList(BuildContext context, dynamic question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose the correct answer:',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: context.scaledFont(13),
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: context.heightPct(0.012)),
        Obx(() {
          final selectedOption = controller.selectedOptionIndex.value;
          final isSubmitted = controller.isSubmitted.value;

          return Column(
            children: List.generate(question.options.length, (optIdx) {
              final optText = question.options[optIdx];
              final isThisSelected = selectedOption == optIdx;
              final isCorrect = optIdx == question.correctIndex;

              return QuizOptionCard(
                index: optIdx,
                text: optText,
                isSelected: isThisSelected,
                isSubmitted: isSubmitted,
                isCorrect: isCorrect,
                onTap: () => controller.selectOption(optIdx),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildExplanationCard(BuildContext context, dynamic question) {
    final isCorrect =
        controller.selectedOptionIndex.value == question.correctIndex;

    return Container(
      width: double.infinity,
      padding: context.responsivePadding(
        horizontal: 0.045,
        vertical: 0.018,
      ),
      decoration: BoxDecoration(
        color: isCorrect ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect ? const Color(0xFF86EFAC) : const Color(0xFFFECACA),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.info_outline_rounded,
                color: isCorrect ? AppColors.success : AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct! Well done.' : 'Incorrect answer',
                style: TextStyle(
                  color: isCorrect ? AppColors.success : AppColors.error,
                  fontSize: context.scaledFont(14),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (question.explanation.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.01)),
            Text(
              question.explanation,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: context.scaledFont(13),
                height: 1.4,
              ),
            ),
          ],
          if (question.steps.isNotEmpty) ...[
            SizedBox(height: context.heightPct(0.012)),
            const Divider(color: Color(0xFFCBD5E1), thickness: 0.7),
            SizedBox(height: context.heightPct(0.008)),
            Text(
              'Practical Takeaway:',
              style: TextStyle(
                color: AppColors.darkGreen,
                fontSize: context.scaledFont(12),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            ...question.steps.map<Widget>((step) {
              return Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(
                        color: AppColors.primaryGreen,
                        fontSize: context.scaledFont(14),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '${step.title}: ${step.detail}',
                        style: TextStyle(
                          color: const Color(0xFF475569),
                          fontSize: context.scaledFont(12),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(0.045),
        vertical: context.heightPct(0.014),
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(
          top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Obx(() {
        final isSubmitted = controller.isSubmitted.value;
        final selectedOption = controller.selectedOptionIndex.value;
        final isLast =
            controller.currentIndex.value >= controller.totalQuestions - 1;

        if (!isSubmitted) {
          return SizedBox(
            width: double.infinity,
            height: context.heightPct(0.058),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: selectedOption != null
                    ? AppColors.primaryGreen
                    : const Color(0xFFCBD5E1),
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: selectedOption != null
                  ? () => controller.submitAnswer()
                  : null,
              child: Text(
                'Submit Answer',
                style: TextStyle(
                  fontSize: context.scaledFont(15),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        }

        return Row(
          children: [
            if (controller.currentIndex.value > 0) ...[
              IconButton(
                tooltip: 'Previous question',
                onPressed: () => controller.previousQuestion(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Expanded(
              child: SizedBox(
                height: context.heightPct(0.058),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => controller.nextQuestion(),
                  icon: Icon(
                    isLast
                        ? Icons.emoji_events_rounded
                        : Icons.arrow_forward_rounded,
                    size: 20,
                  ),
                  label: Text(
                    isLast ? 'Complete & View Results' : 'Next Question',
                    style: TextStyle(
                      fontSize: context.scaledFont(15),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.responsiveAll(0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.quiz_rounded,
              size: 48,
              color: AppColors.primaryLight,
            ),
            SizedBox(height: context.heightPct(0.016)),
            Text(
              'No questions available in this category.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(14),
              ),
            ),
            SizedBox(height: context.heightPct(0.016)),
            ElevatedButton(
              onPressed: () => controller.selectCategory('All'),
              child: const Text('Show All Questions'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: context.responsiveAll(0.06),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 48,
              color: AppColors.error,
            ),
            SizedBox(height: context.heightPct(0.016)),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: context.scaledFont(14),
              ),
            ),
            SizedBox(height: context.heightPct(0.016)),
            ElevatedButton(
              onPressed: () => controller.loadQuizzes(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
