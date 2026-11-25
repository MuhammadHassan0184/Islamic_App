import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zi_core/zi_core_io.dart';
import '../../../../Config/Colors/app_colors.dart';
import '../../../../Config/Routes/app_routes.dart';
import '../../../../Data/Models/quiz_model.dart';
import '../../../../Utils/mediaquery_extension.dart';
import '../Controller/home_controller.dart';

class HomeQuizHorizontalSection extends StatelessWidget {
  final HomeController controller;

  const HomeQuizHorizontalSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isQuizLoading.value) {
        return SizedBox(
          height: context.heightPct(0.18),
          child: const Center(
            child: CircularProgressIndicator(color: AppColors.primaryGreen),
          ),
        );
      }

      final quizzes = controller.quizHighlights;
      if (quizzes.isEmpty) {
        return _buildDefaultBanner(context);
      }

      final cardWidth = (context.screenWidth * 0.76).clamp(260.0, 320.0);
      final cardHeight = (context.heightPct(0.19)).clamp(150.0, 175.0);

      return SizedBox(
        height: cardHeight,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: quizzes.length + 1,
          separatorBuilder: (_, index) => SizedBox(width: context.widthPct(0.035)),
          itemBuilder: (context, index) {
            if (index == quizzes.length) {
              return _buildViewAllCard(context, cardWidth, cardHeight);
            }

            final quiz = quizzes[index];
            return _buildQuizCard(context, quiz, index, cardWidth, cardHeight);
          },
        ),
      );
    });
  }

  Widget _buildQuizCard(
    BuildContext context,
    QuizModel quiz,
    int index,
    double cardWidth,
    double cardHeight,
  ) {
    // Elegant green gradients alternating subtly
    final gradients = [
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF005242), Color(0xFF1B6B54)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF0F5A48), Color(0xFF287961)],
      ),
      const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF165B42), Color(0xFF2E8262)],
      ),
    ];
    final gradient = gradients[index % gradients.length];

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ZiRadius.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => controller.openQuiz(category: quiz.category),
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ZiRadius.card),
            gradient: gradient,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF005242).withValues(alpha: 0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Subtle background circle decoration
              Positioned(
                right: -cardWidth * 0.15,
                bottom: -cardHeight * 0.35,
                child: Container(
                  width: cardWidth * 0.55,
                  height: cardWidth * 0.55,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: context.responsivePadding(
                  horizontal: 0.038,
                  vertical: 0.015,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.widthPct(0.024),
                            vertical: context.heightPct(0.005),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(ZiRadius.full),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.quiz_rounded,
                                color: AppColors.tabIndicator,
                                size: 13,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                quiz.categoryDisplayName,
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: context.scaledFont(11),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (quiz.reference.isNotEmpty)
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Text(
                                quiz.reference,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.white.withValues(alpha: 0.75),
                                  fontSize: context.scaledFont(10),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        quiz.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: context.scaledFont(14),
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${quiz.options.length} Options',
                          style: TextStyle(
                            color: AppColors.white.withValues(alpha: 0.8),
                            fontSize: context.scaledFont(11),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.widthPct(0.026),
                            vertical: context.heightPct(0.006),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(ZiRadius.full),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Play Now',
                                style: TextStyle(
                                  color: AppColors.primaryDark,
                                  fontSize: context.scaledFont(11),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(width: 3),
                              const Icon(
                                Icons.play_arrow_rounded,
                                color: AppColors.primaryDark,
                                size: 14,
                              ),
                            ],
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
  }

  Widget _buildViewAllCard(
    BuildContext context,
    double cardWidth,
    double cardHeight,
  ) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ZiRadius.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => controller.openQuiz(),
        child: Container(
          width: cardWidth * 0.7,
          height: cardHeight,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(ZiRadius.card),
            border: Border.all(
              color: AppColors.primaryGreen.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: context.scaledFont(44),
                height: context.scaledFont(44),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
              ),
              SizedBox(height: context.heightPct(0.01)),
              Text(
                'Explore All',
                style: TextStyle(
                  color: AppColors.primaryGreen,
                  fontSize: context.scaledFont(14),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'All Categories',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: context.scaledFont(11),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultBanner(BuildContext context) {
    final width = double.infinity;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ZiRadius.card),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Get.toNamed(AppRoutes.quiz),
        child: Container(
          width: width,
          padding: context.responsivePadding(
            horizontal: 0.045,
            vertical: 0.018,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ZiRadius.card),
            gradient: AppColors.primaryGradient,
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryDark.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: context.scaledFont(48),
                height: context.scaledFont(48),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color: AppColors.white,
                  size: 26,
                ),
              ),
              SizedBox(width: context.widthPct(0.035)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Islamic Quiz',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: context.scaledFont(15),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Sharpen your Quran & Sunnah knowledge',
                      style: TextStyle(
                        color: AppColors.white.withValues(alpha: 0.85),
                        fontSize: context.scaledFont(11),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
