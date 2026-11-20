import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:islam786/Data/Models/zikr_model.dart';
import 'package:islam786/Data/Repositories/azkar_repository.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzkarController extends GetxController {
  AzkarController(this.repository);

  final AzkarRepository repository;
  static const _countKeyPrefix = 'azkar_count_';

  final RxList<ZikrModel> azkar = <ZikrModel>[].obs;
  final RxMap<String, int> counts = <String, int>{}.obs;
  final RxMap<String, int> targets = <String, int>{}.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Map<String, Future<void>> _pendingWrites = {};

  List<String> get categories {
    final values =
        azkar
            .map((zikr) => zikr.category)
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return values;
  }

  List<ZikrModel> get filteredAzkar {
    final query = searchQuery.value.trim().toLowerCase();
    return azkar.where((zikr) {
      final matchesCategory =
          selectedCategory.value.isEmpty ||
          zikr.category == selectedCategory.value;
      final matchesQuery =
          query.isEmpty ||
          zikr.title.toLowerCase().contains(query) ||
          zikr.arabic.contains(query) ||
          zikr.urdu.toLowerCase().contains(query) ||
          zikr.english.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    loadAzkar();
  }

  Future<void> loadAzkar() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final records = await repository.getAzkar();
      azkar.assignAll(records);
      await _loadCounts();
    } catch (error, stackTrace) {
      debugPrint('Unable to load Azkar: $error');
      debugPrintStack(stackTrace: stackTrace);
      errorMessage.value = 'Unable to load Azkar. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCounts() async {
    try {
      final preferences = await SharedPreferences.getInstance();
      final restoredTargets = <String, int>{};
      final restoredCounts = <String, int>{};
      for (final zikr in azkar) {
        final savedTarget = preferences.getInt('azkar_target_${zikr.id}');
        final target = savedTarget != null && savedTarget > 0
            ? savedTarget
            : zikr.defaultTarget;
        restoredTargets[zikr.id] = target;
        restoredCounts[zikr.id] =
            (preferences.getInt('$_countKeyPrefix${zikr.id}') ?? 0).clamp(
              0,
              target,
            );
      }
      targets.assignAll(restoredTargets);
      counts.assignAll(restoredCounts);
    } catch (error, stackTrace) {
      debugPrint('Unable to restore Azkar progress: $error');
      debugPrintStack(stackTrace: stackTrace);
      targets.assignAll({
        for (final zikr in azkar) zikr.id: zikr.defaultTarget,
      });
      counts.assignAll({for (final zikr in azkar) zikr.id: 0});
      AppSnackbar.warning(
        'Azkar loaded, but saved counter progress could not be restored.',
      );
    }
  }

  int countFor(ZikrModel zikr) => counts[zikr.id] ?? 0;

  int targetFor(ZikrModel zikr) => targets[zikr.id] ?? zikr.defaultTarget;

  double progressFor(ZikrModel zikr) =>
      (countFor(zikr) / targetFor(zikr)).clamp(0.0, 1.0).toDouble();

  Future<void> increment(ZikrModel zikr) async {
    final current = countFor(zikr);
    final target = targetFor(zikr);
    if (current >= target) return;

    final next = current + 1;
    counts[zikr.id] = next;
    await _queueCountSave(zikr.id);

    if (next == target) {
      AppSnackbar.success('${zikr.title} target completed');
    }
  }

  Future<void> setTarget(ZikrModel zikr, int target) async {
    if (target <= 0) return;

    targets[zikr.id] = target;
    final current = countFor(zikr);
    if (current > target) {
      counts[zikr.id] = target;
    }

    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setInt('azkar_target_${zikr.id}', target);
      if (current > target) {
        await _queueCountSave(zikr.id);
      }
    } catch (error, stackTrace) {
      debugPrint('Unable to save Azkar target: $error');
      debugPrintStack(stackTrace: stackTrace);
      AppSnackbar.warning('Counter target could not be saved.');
    }
  }

  Future<void> resetCount(ZikrModel zikr) async {
    counts[zikr.id] = 0;
    await _queueCountSave(zikr.id);
  }

  Future<void> _queueCountSave(String id) {
    final previous = _pendingWrites[id] ?? Future<void>.value();
    final pending = previous.then((_) => _saveCount(id));
    _pendingWrites[id] = pending;
    return pending;
  }

  Future<void> _saveCount(String id) async {
    try {
      final preferences = await SharedPreferences.getInstance();
      await preferences.setInt('$_countKeyPrefix$id', counts[id] ?? 0);
    } catch (error, stackTrace) {
      debugPrint('Unable to save Azkar progress: $error');
      debugPrintStack(stackTrace: stackTrace);
      AppSnackbar.warning('Counter progress could not be saved.');
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }
}
