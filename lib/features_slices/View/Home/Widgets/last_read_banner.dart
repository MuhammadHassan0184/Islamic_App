
import 'package:flutter/material.dart';

import '../Controller/home_controller.dart';

class LastReadBanner extends StatelessWidget {
  final HomeController controller;

  const LastReadBanner({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = (width / 1.78).clamp(155.0, 215.0);
        final compact = width < 350;

        return Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(23),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: controller.continueReading,
            child: Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(23),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF005242),
                    Color(0xFF2D7259),
                    Color(0xFF80B897),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.55),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF176C56).withValues(alpha: 0.17),
                    blurRadius: 16,
                    offset: const Offset(0, 7),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  // Decorative background circle.
                  Positioned(
                    right: -width * 0.12,
                    bottom: -height * 0.48,
                    child: Container(
                      width: width * 0.72,
                      height: width * 0.72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  // Subtle top highlight.
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: height * 0.16,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.10),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Quran artwork.
                  Positioned(
                    right: width * 0.025,
                    top: height * 0.08,
                    bottom: height * 0.06,
                    width: width * 0.40,
                    child: Image.asset(
                      'assets/Quran_image.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.menu_book_rounded,
                          size: width * 0.24,
                          color: Colors.white.withValues(alpha: 0.85),
                        );
                      },
                    ),
                  ),

                  // Text content.
                  Positioned(
                    left: width * 0.065,
                    top: height * 0.12,
                    bottom: height * 0.10,
                    width: width * 0.55,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bookmark_rounded,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: width * 0.043,
                            ),
                            SizedBox(width: width * 0.015),
                            Text(
                              'Last Read',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.94),
                                fontSize: compact ? 10 : 11.5,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'الْفَاتِحَة',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: (width * 0.068).clamp(20.0, 27.0),
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.012),

                        Row(
                          children: [
                            Container(
                              width: 3,
                              height: height * 0.10,
                              constraints: const BoxConstraints(
                                minHeight: 13,
                                maxHeight: 19,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFD36A),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            SizedBox(width: width * 0.018),
                            Text(
                              'Ayah no. 1',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.95),
                                fontSize: compact ? 9 : 10.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        _ContinueReadingButton(
                          controller: controller,
                          compact: compact,
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

class _ContinueReadingButton extends StatelessWidget {
  final HomeController controller;
  final bool compact;

  const _ContinueReadingButton({
    required this.controller,
    required this.compact,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFFFF9EB),
      borderRadius: BorderRadius.circular(30),
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      child: InkWell(
        onTap: controller.continueReading,
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 9 : 12,
            vertical: compact ? 4 : 6,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Continue',
                style: TextStyle(
                  color: const Color(0xFF303B35),
                  fontSize: compact ? 9 : 10.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(width: compact ? 6 : 9),
              Container(
                width: compact ? 23 : 27,
                height: compact ? 23 : 27,
                decoration: const BoxDecoration(
                  color: Color(0xFF087C65),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: compact ? 14 : 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
