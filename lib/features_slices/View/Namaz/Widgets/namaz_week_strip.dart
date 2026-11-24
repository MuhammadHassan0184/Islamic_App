
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

import '../Controller/namaz_controller.dart';

class NamazWeekStrip extends StatelessWidget {
  final NamazController controller;

  const NamazWeekStrip({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: List.generate(
          controller.weekDays.length,
          (index) {
            final date = controller.weekDays[index];
            final isSelected =
                controller.selectedDayIndex.value == index;

            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectDay(index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  padding: EdgeInsets.symmetric(
                    vertical: context.heightPct(0.008),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Text(
                        controller.weekdayShort(date),
                        maxLines: 1,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF65A96D)
                              : const Color(0xFFB2B8B4),
                          fontSize: context.scaledFont(11),
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: context.heightPct(0.006)),

                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: context.widthPct(0.085),
                        height: context.widthPct(0.085),
                        constraints: const BoxConstraints(
                          minWidth: 29,
                          minHeight: 29,
                          maxWidth: 38,
                          maxHeight: 38,
                        ),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF70B778)
                              : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${date.day}',
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF26352E),
                            fontSize: context.scaledFont(12),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
