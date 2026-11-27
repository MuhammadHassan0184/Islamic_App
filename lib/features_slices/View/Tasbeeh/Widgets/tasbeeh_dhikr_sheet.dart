import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:zi_core/zi_core_io.dart' hide TextDirection;
import '../Controller/tasbeeh_controller.dart';

Future<void> showDhikrSelectionSheet(
  BuildContext context,
  TasbeehController controller,
) {
  return ziShowFeedOver<void>(
    context,
    type: ZiFeedOverType.bottomSheet,
    size: ZiFeedOverSize.auto,
    dismissOutside: true,
    title: 'Select Dhikr / Tasbeeh',
    style: ZiFeedOverStyle.defaults(context).copyWith(
      backgroundColor: AppColors.white,
      radius: ZiRadius.xl,
    ),
    body: _DhikrSheetBody(controller: controller),
  );
}

class _DhikrSheetBody extends StatefulWidget {
  final TasbeehController controller;

  const _DhikrSheetBody({required this.controller});

  @override
  State<_DhikrSheetBody> createState() => _DhikrSheetBodyState();
}

class _DhikrSheetBodyState extends State<_DhikrSheetBody> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddCustomDialog() {
    final arabicCtrl = TextEditingController();
    final transCtrl = TextEditingController();
    final meaningCtrl = TextEditingController();
    final targetCtrl = TextEditingController(text: '33');

    showDialog<void>(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ZiRadius.card),
          ),
          title: Text(
            'Add Custom Dhikr',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: context.scaledFont(17),
              color: AppColors.textPrimary,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: arabicCtrl,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    labelText: 'Arabic (العربية)',
                    hintText: 'سُبْحَانَ اللَّهِ',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ZiRadius.md),
                    ),
                  ),
                ),
                ziGap(12),
                TextField(
                  controller: transCtrl,
                  decoration: InputDecoration(
                    labelText: 'Transliteration / Name',
                    hintText: 'e.g. SubhanAllah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ZiRadius.md),
                    ),
                  ),
                ),
                ziGap(12),
                TextField(
                  controller: meaningCtrl,
                  decoration: InputDecoration(
                    labelText: 'Meaning / Translation',
                    hintText: 'e.g. Glory be to Allah',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ZiRadius.md),
                    ),
                  ),
                ),
                ziGap(12),
                TextField(
                  controller: targetCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target Count (0 for infinite)',
                    hintText: '33',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(ZiRadius.md),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogCtx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(ZiRadius.sm),
                ),
              ),
              onPressed: () {
                final trans = transCtrl.text.trim();
                if (trans.isEmpty) return;
                final target = int.tryParse(targetCtrl.text.trim()) ?? 33;
                widget.controller.addCustomDhikr(
                  arabic: arabicCtrl.text.trim().isEmpty
                      ? trans
                      : arabicCtrl.text.trim(),
                  transliteration: trans,
                  meaning: meaningCtrl.text.trim(),
                  target: target,
                );
                Navigator.of(dialogCtx).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Add Dhikr'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final all = widget.controller.allDhikrs;
      final filtered = all.where((item) {
        if (_query.isEmpty) return true;
        final q = _query.toLowerCase();
        return item.transliteration.toLowerCase().contains(q) ||
            item.meaning.toLowerCase().contains(q) ||
            item.arabic.contains(_query);
      }).toList();

      final selectedId = widget.controller.selectedDhikr.value.id;
      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
      final screenHeight = MediaQuery.of(context).size.height;
      final availableHeight = (screenHeight - bottomInset)
          .clamp(0.0, screenHeight)
          .toDouble();
      final maxAvailableHeight = (bottomInset > 0
              ? availableHeight * 0.9
              : screenHeight * 0.72)
          .clamp(0.0, screenHeight)
          .toDouble();

      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxAvailableHeight,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() => _query = val.trim()),
                    decoration: InputDecoration(
                      hintText: 'Search Dhikr...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: AppColors.background,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(ZiRadius.md),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                ziGap(8),
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(ZiRadius.md),
                    ),
                  ),
                  tooltip: 'Add Custom Dhikr',
                  onPressed: _showAddCustomDialog,
                  icon: const Icon(Icons.add_rounded, size: 22),
                ),
              ],
            ),
            ziGap(12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemCount: filtered.length,
                separatorBuilder: (context, index) => ziGap(8),
                itemBuilder: (context, index) {
                  final dhikr = filtered[index];
                  final isSelected = dhikr.id == selectedId;

                  return Material(
                    color: isSelected
                        ? AppColors.softGreenGradient.colors.first
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(ZiRadius.card),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(ZiRadius.card),
                      onTap: () {
                        widget.controller.selectDhikr(dhikr);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(ZiRadius.card),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.cardBorder,
                            width: isSelected ? 1.5 : 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    dhikr.transliteration,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: context
                                          .scaledFont(13.5)
                                          .clamp(12.0, 15.5)
                                          .toDouble(),
                                      color: isSelected
                                          ? AppColors.primaryDark
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 4,
                                  children: [
                                    if (dhikr.defaultTarget > 0)
                                      ZiBadge(
                                        label: '${dhikr.defaultTarget}x',
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                      )
                                    else
                                      const ZiBadge(
                                        label: '∞',
                                        color: AppColors.textSecondary,
                                      ),
                                    if (isSelected)
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: context.heightPct(0.006)),
                            Text(
                              dhikr.arabic,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: context
                                    .scaledFont(15)
                                    .clamp(13.0, 18.0)
                                    .toDouble(),
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                                height: 1.35,
                              ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                            if (dhikr.meaning.isNotEmpty) ...[
                              SizedBox(height: context.heightPct(0.004)),
                              Text(
                                dhikr.meaning,
                                style: TextStyle(
                                  fontSize: context
                                      .scaledFont(11.5)
                                      .clamp(10.5, 13.0)
                                      .toDouble(),
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
