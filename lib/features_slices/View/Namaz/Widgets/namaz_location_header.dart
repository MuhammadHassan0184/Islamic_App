
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

import '../Controller/namaz_controller.dart';

class NamazLocationHeader extends StatelessWidget {
  final NamazController controller;

  const NamazLocationHeader({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: InkWell(
            onTap: controller.openLocationSettings,
            borderRadius: BorderRadius.circular(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: const Color(0xFFD6A52D),
                      size: context.scaledFont(19),
                    ),
                    SizedBox(width: context.widthPct(0.012)),
                    Obx(
                      () => Flexible(
                        child: Text(
                          controller.cityName.value,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: const Color(0xFF929B95),
                            fontSize: context.scaledFont(12),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.grey.shade500,
                      size: context.scaledFont(18),
                    ),
                  ],
                ),
                SizedBox(height: context.heightPct(0.004)),
                Obx(
                  () => Text(
                    controller.areaName.value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF172C26),
                      fontSize: context.scaledFont(17),
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Material(
          color: const Color(0xFFF4F7F4),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: controller.openPrayerSettings,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: EdgeInsets.all(context.widthPct(0.025)),
              child: Icon(
                Icons.settings_outlined,
                color: const Color(0xFF263D34),
                size: context.scaledFont(23),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
