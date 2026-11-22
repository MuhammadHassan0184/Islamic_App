
import 'package:flutter/material.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

import '../Controller/home_controller.dart';

class LastReadBanner extends StatelessWidget {
  final HomeController controller;

  const LastReadBanner({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: controller.continueReading,
        child: Container(
          width: double.infinity,
          height: context.heightPct(0.20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00765F),
                Color(0xFF9BDDB7),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -context.widthPct(0.10),
                bottom: -context.heightPct(0.065),
                child: Container(
                  width: context.widthPct(0.65),
                  height: context.heightPct(0.18),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Positioned(
                right: context.widthPct(0.025),
                top: context.heightPct(0.018),
                bottom: context.heightPct(0.015),
                width: context.widthPct(0.40),
                child: Image.asset(
                  'assets/Quran_image.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.menu_book_rounded,
                      size: context.widthPct(0.25),
                      color: Colors.white,
                    );
                  },
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.widthPct(0.065),
                  vertical: context.heightPct(0.027),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Last Read',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.92),
                        fontSize: context.scaledFont(11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الْفَاتِحَة',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: context.scaledFont(23),
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),

                        Text(
                          'Ayah no. 1',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: context.scaledFont(10),
                          ),
                        ),
                      ],
                    ),

                    Material(
                      color: const Color(0xFFFFF9EB),
                      borderRadius: BorderRadius.circular(30),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: controller.continueReading,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: context.widthPct(0.025),
                            vertical: context.heightPct(0.009),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Continue',
                                style: TextStyle(
                                  color: const Color(0xFF303B35),
                                  fontSize: context.scaledFont(10),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),

                              SizedBox(
                                width: context.widthPct(0.025),
                              ),

                              Icon(
                                Icons.arrow_forward_rounded,
                                color: const Color(0xFF087C65),
                                size: context.scaledFont(19),
                              ),
                            ],
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
      ),
    );
  }
}
