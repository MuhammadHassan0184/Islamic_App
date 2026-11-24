
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart';

import '../Model/prayer_time_model.dart';

class PrayerTimeTile extends StatelessWidget {
  final PrayerTimeModel prayer;
  final VoidCallback onSoundTap;

  const PrayerTimeTile({
    super.key,
    required this.prayer,
    required this.onSoundTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: context.heightPct(0.075),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: context.widthPct(0.045),
        vertical: context.heightPct(0.012),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFEAEFEB),
          width: 0.9,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF203D30).withValues(alpha: 0.025),
            blurRadius: 9,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Text(
              prayer.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: const Color(0xFF1D2823),
                fontSize: context.scaledFont(14),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Text(
              prayer.time,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFFA4AAA6),
                fontSize: context.scaledFont(12),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          SizedBox(
            width: context.widthPct(0.10),
            child: Obx(
              () => IconButton(
                onPressed: onSoundTap,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 34,
                  minHeight: 34,
                ),
                splashRadius: 20,
                icon: Icon(
                  prayer.isReminderEnabled.value
                      ? Icons.volume_up_outlined
                      : Icons.volume_off_outlined,
                  color: prayer.isReminderEnabled.value
                      ? ZiColors.primary
                      : const Color(0xFFE35B55),
                  size: context.scaledFont(21),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
