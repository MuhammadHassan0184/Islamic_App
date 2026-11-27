import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Repositories/azkar_repository.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/tasbeeh_model.dart';

class TasbeehController extends GetxController {
  TasbeehController({AzkarRepository? azkarRepository})
    : _azkarRepository = azkarRepository ?? AzkarRepository(AssetDataSource());

  final AzkarRepository _azkarRepository;

  static const _keyCount = 'tasbeeh_current_count';
  static const _keyTarget = 'tasbeeh_target_count';
  static const _keyRounds = 'tasbeeh_round_count';
  static const _keyTotal = 'tasbeeh_total_count';
  static const _keyVibrate = 'tasbeeh_vibrate_enabled';
  static const _keySound = 'tasbeeh_sound_enabled';
  static const _keyDhikrId = 'tasbeeh_selected_dhikr_id';
  static const _keyCustomDhikrs = 'tasbeeh_custom_dhikrs';

  final RxInt currentCount = 0.obs;
  final RxInt targetCount = 33.obs;
  final RxInt roundCount = 0.obs;
  final RxInt totalCount = 0.obs;

  final RxBool vibrationEnabled = true.obs;
  final RxBool soundEnabled = true.obs;

  final Rx<DhikrItem> selectedDhikr = DhikrItem.presets.first.obs;
  final RxList<DhikrItem> azkarDhikrList = <DhikrItem>[].obs;
  final RxList<DhikrItem> customDhikrList = <DhikrItem>[].obs;

  List<DhikrItem> get allDhikrs => [
    ...DhikrItem.presets,
    ...azkarDhikrList,
    ...customDhikrList,
  ];

  double get progress {
    if (targetCount.value <= 0) return 0.0;
    return (currentCount.value / targetCount.value).clamp(0.0, 1.0);
  }

  int get remainingCount {
    if (targetCount.value <= 0) return 0;
    final rem = targetCount.value - currentCount.value;
    return rem < 0 ? 0 : rem;
  }

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadAzkarDhikrs();
    await _loadState();
  }

  Future<void> _loadAzkarDhikrs() async {
    try {
      final records = await _azkarRepository.getAzkar();
      azkarDhikrList.assignAll(
        records.map(
          (zikr) => DhikrItem(
            id: zikr.id,
            arabic: zikr.arabic,
            transliteration: zikr.title,
            meaning: zikr.english,
            defaultTarget: zikr.defaultTarget,
          ),
        ),
      );
    } catch (error, stackTrace) {
      debugPrint('Unable to load Azkar into Tasbeeh: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      currentCount.value = prefs.getInt(_keyCount) ?? 0;
      targetCount.value = prefs.getInt(_keyTarget) ?? 33;
      roundCount.value = prefs.getInt(_keyRounds) ?? 0;
      totalCount.value = prefs.getInt(_keyTotal) ?? 0;
      vibrationEnabled.value = prefs.getBool(_keyVibrate) ?? true;
      soundEnabled.value = prefs.getBool(_keySound) ?? true;

      final savedDhikrId = prefs.getString(_keyDhikrId);

      final customRaw = prefs.getString(_keyCustomDhikrs);
      if (customRaw != null && customRaw.isNotEmpty) {
        try {
          final decoded = jsonDecode(customRaw) as List;
          customDhikrList.assignAll(
            decoded
                .whereType<Map<String, dynamic>>()
                .map(DhikrItem.fromJson)
                .toList(),
          );
        } catch (_) {}
      }

      if (savedDhikrId != null) {
        final match = allDhikrs.firstWhereOrNull((d) => d.id == savedDhikrId);
        if (match != null) {
          selectedDhikr.value = match;
        }
      }
    } catch (_) {}
  }

  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_keyCount, currentCount.value);
      await prefs.setInt(_keyTarget, targetCount.value);
      await prefs.setInt(_keyRounds, roundCount.value);
      await prefs.setInt(_keyTotal, totalCount.value);
      await prefs.setBool(_keyVibrate, vibrationEnabled.value);
      await prefs.setBool(_keySound, soundEnabled.value);
      await prefs.setString(_keyDhikrId, selectedDhikr.value.id);
      await prefs.setString(
        _keyCustomDhikrs,
        jsonEncode(customDhikrList.map((d) => d.toJson()).toList()),
      );
    } catch (_) {}
  }

  void increment() {
    currentCount.value++;
    totalCount.value++;

    if (soundEnabled.value) {
      SystemSound.play(SystemSoundType.click);
    }

    if (vibrationEnabled.value) {
      HapticFeedback.lightImpact();
    }

    if (targetCount.value > 0 && currentCount.value >= targetCount.value) {
      roundCount.value++;
      currentCount.value = 0;

      if (vibrationEnabled.value) {
        HapticFeedback.vibrate();
      }

      AppSnackbar.success(
        'Completed ${roundCount.value} ${roundCount.value == 1 ? "round" : "rounds"} of ${selectedDhikr.value.transliteration}!',
      );
    }

    _saveState();
  }

  void decrement() {
    if (currentCount.value > 0) {
      currentCount.value--;
      if (totalCount.value > 0) {
        totalCount.value--;
      }
      if (vibrationEnabled.value) {
        HapticFeedback.selectionClick();
      }
      _saveState();
    }
  }

  void resetCurrentRound() {
    currentCount.value = 0;
    if (vibrationEnabled.value) {
      HapticFeedback.mediumImpact();
    }
    _saveState();
  }

  void resetAll() {
    currentCount.value = 0;
    roundCount.value = 0;
    if (vibrationEnabled.value) {
      HapticFeedback.heavyImpact();
    }
    _saveState();
    AppSnackbar.info('Tasbeeh counter reset');
  }

  void setTarget(int target) {
    targetCount.value = target;
    _saveState();
  }

  void selectDhikr(DhikrItem dhikr) {
    selectedDhikr.value = dhikr;
    targetCount.value = dhikr.defaultTarget;
    currentCount.value = 0;
    _saveState();
  }

  void toggleVibration() {
    vibrationEnabled.value = !vibrationEnabled.value;
    if (vibrationEnabled.value) {
      HapticFeedback.mediumImpact();
    }
    _saveState();
  }

  void toggleSound() {
    soundEnabled.value = !soundEnabled.value;
    if (soundEnabled.value) {
      SystemSound.play(SystemSoundType.click);
    }
    _saveState();
  }

  void addCustomDhikr({
    required String arabic,
    required String transliteration,
    required String meaning,
    required int target,
  }) {
    final newDhikr = DhikrItem(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      arabic: arabic.trim(),
      transliteration: transliteration.trim(),
      meaning: meaning.trim(),
      defaultTarget: target,
    );
    customDhikrList.add(newDhikr);
    selectDhikr(newDhikr);
    _saveState();
  }
}
