import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:islam786/Config/Colors/app_colors.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';
import 'package:islam786/Widgets/app_snack_bar.dart';
import 'package:zi_core/zi_core_io.dart';

import '../Controller/namaz_controller.dart';
import '../Model/prayer_time_model.dart';
import '../Services/namaz_time_calculator.dart';

Future<void> showAddOrEditPrayerSheet(
  BuildContext context,
  NamazController controller, {
  PrayerTimeModel? existingPrayer,
}) {
  final isEdit = existingPrayer != null;
  final title = isEdit
      ? (existingPrayer.isCustomPrayer
            ? 'Edit Custom Prayer'
            : 'Customize ${existingPrayer.name} Timing')
      : 'Add Custom Namaz Timing';

  return ziShowFeedOver<void>(
    context,
    type: ZiFeedOverType.bottomSheet,
    size: ZiFeedOverSize.auto,
    dismissOutside: true,
    title: title,
    style: ZiFeedOverStyle.defaults(context).copyWith(
      backgroundColor: AppColors.white,
      radius: ZiRadius.xl,
    ),
    body: _CustomPrayerSheetBody(
      controller: controller,
      existingPrayer: existingPrayer,
    ),
  );
}

Future<void> showLocationAndMethodSheet(
  BuildContext context,
  NamazController controller,
) {
  return ziShowFeedOver<void>(
    context,
    type: ZiFeedOverType.bottomSheet,
    size: ZiFeedOverSize.auto,
    dismissOutside: true,
    title: 'Location & Calculation',
    style: ZiFeedOverStyle.defaults(context).copyWith(
      backgroundColor: AppColors.white,
      radius: ZiRadius.xl,
    ),
    body: _LocationAndMethodSheetBody(controller: controller),
  );
}

Future<void> showAlarmSettingsSheet(
  BuildContext context,
  NamazController controller,
) {
  return ziShowFeedOver<void>(
    context,
    type: ZiFeedOverType.bottomSheet,
    size: ZiFeedOverSize.auto,
    dismissOutside: true,
    title: 'Alarms & Notifications',
    style: ZiFeedOverStyle.defaults(context).copyWith(
      backgroundColor: AppColors.white,
      radius: ZiRadius.xl,
    ),
    body: _AlarmSettingsSheetBody(controller: controller),
  );
}

Future<void> showForegroundPrayerAlarmDialog(
  BuildContext context,
  NamazController controller,
  PrayerTimeModel prayer,
) {
  return ziShowFeedOver<void>(
    context,
    type: ZiFeedOverType.dialog,
    dismissOutside: false,
    showCloseButton: false,
    showHeaderDivider: false,
    style: ZiFeedOverStyle.defaults(context).copyWith(
      backgroundColor: AppColors.white,
      radius: ZiRadius.xl,
    ),
    body: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.mosque_rounded,
            color: AppColors.white,
            size: 32,
          ),
        ),
        ziGap(14),
        Text(
          '${prayer.name} Prayer Time',
          textAlign: TextAlign.center,
          style: ZiTypoStyles.titleLg.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        ziGap(6),
        Text(
          prayer.formattedTime(controller.use24HourFormat.value),
          style: ZiTypoStyles.noLg.copyWith(
            color: AppColors.primary,
            fontSize: context.scaledFont(22).clamp(20.0, 26.0),
          ),
        ),
        ziGap(8),
        Text(
          prayer.note?.isNotEmpty == true
              ? prayer.note!
              : 'Hayya \'alas-Salah — Time to stand for ${prayer.name}.',
          textAlign: TextAlign.center,
          style: ZiTypoStyles.bodySm.copyWith(color: AppColors.textSecondary),
        ),
        ziGap(20),
        Row(
          children: [
            Expanded(
              child: ZiButtonB(
                variant: ZiButtonVariantB.outline,
                label: 'Snooze 5m',
                style: ZiButtonStyleB(
                  borderColor: AppColors.primary,
                  foregroundColor: AppColors.primary,
                  borderRadius: BorderRadius.circular(ZiRadius.md),
                ),
                action: () {
                  Navigator.of(context).pop();
                  controller.snoozeForegroundAlarm(minutes: 5);
                },
              ),
            ),
            ziGap(10),
            Expanded(
              child: ZiButtonB(
                variant: ZiButtonVariantB.primary,
                label: 'Dismiss',
                style: ZiButtonStyleB(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  borderRadius: BorderRadius.circular(ZiRadius.md),
                ),
                action: () {
                  Navigator.of(context).pop();
                  controller.dismissForegroundAlarm();
                },
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _CustomPrayerSheetBody extends StatefulWidget {
  const _CustomPrayerSheetBody({
    required this.controller,
    this.existingPrayer,
  });

  final NamazController controller;
  final PrayerTimeModel? existingPrayer;

  @override
  State<_CustomPrayerSheetBody> createState() => _CustomPrayerSheetBodyState();
}

class _CustomPrayerSheetBodyState extends State<_CustomPrayerSheetBody> {
  static const List<({String name, TimeOfDay time, String note})>
  _quickPresets = [
    (
      name: 'Tahajjud',
      time: TimeOfDay(hour: 3, minute: 30),
      note: 'Night voluntary prayer',
    ),
    (
      name: 'Ishraq',
      time: TimeOfDay(hour: 6, minute: 55),
      note: 'After sunrise',
    ),
    (
      name: 'Duha / Chasht',
      time: TimeOfDay(hour: 9, minute: 30),
      note: 'Forenoon prayer',
    ),
    (
      name: 'Jumu\'ah',
      time: TimeOfDay(hour: 13, minute: 30),
      note: 'Friday congregation',
    ),
    (
      name: 'Awwabin',
      time: TimeOfDay(hour: 18, minute: 15),
      note: 'After Maghrib',
    ),
  ];

  late final TextEditingController _nameController;
  late final TextEditingController _noteController;
  late TimeOfDay _selectedTime;
  late bool _reminderEnabled;
  late int _leadMinutes;
  late PrayerAlarmMode _alarmMode;

  bool get _isEditing => widget.existingPrayer != null;
  bool get _isDefaultPrayer =>
      widget.existingPrayer != null && !widget.existingPrayer!.isCustomPrayer;

  @override
  void initState() {
    super.initState();
    final existing = widget.existingPrayer;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _noteController = TextEditingController(text: existing?.note ?? '');
    _selectedTime = existing?.timeOfDay ?? const TimeOfDay(hour: 4, minute: 0);
    _reminderEnabled = existing?.isReminderEnabled.value ?? true;
    _leadMinutes = existing?.leadMinutes ?? widget.controller.defaultLeadMinutes.value;
    _alarmMode = existing?.alarmMode ?? widget.controller.globalAlarmMode.value;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _selectedTime = picked);
    }
  }

  String _formatSelectedTime() {
    if (widget.controller.use24HourFormat.value) {
      final hh = _selectedTime.hour.toString().padLeft(2, '0');
      final mm = _selectedTime.minute.toString().padLeft(2, '0');
      return '$hh:$mm';
    }
    final period = _selectedTime.hour >= 12 ? 'PM' : 'AM';
    final h12 = _selectedTime.hour % 12 == 0 ? 12 : _selectedTime.hour % 12;
    final mm = _selectedTime.minute.toString().padLeft(2, '0');
    return '${h12.toString().padLeft(2, '0')}:$mm $period';
  }

  Future<void> _save() async {
    if (_isEditing) {
      await widget.controller.updatePrayerTiming(
        widget.existingPrayer!,
        name: _isDefaultPrayer ? null : _nameController.text,
        time: _selectedTime,
        note: _noteController.text,
        reminderEnabled: _reminderEnabled,
        leadMinutes: _leadMinutes,
        alarmMode: _alarmMode,
      );
      if (mounted) Navigator.of(context).pop();
      return;
    }

    if (_nameController.text.trim().isEmpty) {
      AppSnackbar.warning('Please enter a prayer name');
      return;
    }

    await widget.controller.addCustomPrayer(
      name: _nameController.text,
      time: _selectedTime,
      note: _noteController.text,
      reminderEnabled: _reminderEnabled,
      leadMinutes: _leadMinutes,
      alarmMode: _alarmMode,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_isEditing) ...[
          Text(
            'Quick Presets',
            style: ZiTypoStyles.titleXsm.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          ziGap(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickPresets.map((preset) {
              final isSelected = _nameController.text.trim() == preset.name;
              return ChoiceChip(
                label: Text(preset.name),
                selected: isSelected,
                selectedColor: AppColors.softGreenGradient.colors.last,
                labelStyle: TextStyle(
                  color: isSelected
                      ? AppColors.primaryDark
                      : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: context.scaledFont(12).clamp(11.0, 14.0),
                ),
                side: BorderSide(
                  color: isSelected
                      ? AppColors.primaryLight
                      : AppColors.cardBorder,
                ),
                onSelected: (_) {
                  setState(() {
                    _nameController.text = preset.name;
                    _noteController.text = preset.note;
                    _selectedTime = preset.time;
                  });
                },
              );
            }).toList(),
          ),
          ziGap(14),
        ],

        if (!_isDefaultPrayer) ...[
          ZiInput(
            label: 'Prayer Name',
            hint: 'e.g. Tahajjud, Ishraq, Jama\'at',
            controller: _nameController,
            isRequired: true,
            variant: ZiInputVariant.outline,
            prefix: const Icon(Icons.mosque_outlined, color: AppColors.primary),
          ),
          ziGap(12),
        ],

        // Time selector card
        Text(
          'Prayer Timing',
          style: ZiTypoStyles.inputLabel.copyWith(color: AppColors.textPrimary),
        ),
        ziGap(6),
        Material(
          color: AppColors.softGreenGradient.colors.first.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(ZiRadius.md),
          child: InkWell(
            onTap: _pickTime,
            borderRadius: BorderRadius.circular(ZiRadius.md),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(ZiRadius.md),
                border: Border.all(
                  color: AppColors.primaryLight.withValues(alpha: 0.45),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.access_time_filled_rounded,
                    color: AppColors.primary,
                  ),
                  ziGap(12),
                  Expanded(
                    child: Text(
                      _formatSelectedTime(),
                      style: ZiTypoStyles.noLg.copyWith(
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                  const ZiBadge(
                    label: 'Change Time',
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
        ziGap(12),

        if (!_isDefaultPrayer) ...[
          ZiInput(
            label: 'Note (Optional)',
            hint: 'e.g. Mosque Jama\'at or Sunnah',
            controller: _noteController,
            variant: ZiInputVariant.outline,
            prefix: const Icon(
              Icons.notes_rounded,
              color: AppColors.textSecondary,
            ),
          ),
          ziGap(12),
        ],

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(ZiRadius.md),
          ),
          child: ZiSwitchTile(
            label: 'Enable Prayer Alarm',
            value: _reminderEnabled,
            onChanged: (value) => setState(() => _reminderEnabled = value),
          ),
        ),

        if (_reminderEnabled) ...[
          ziGap(14),
          Text(
            'Alarm Style',
            style: ZiTypoStyles.inputLabel.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          ziGap(8),
          Row(
            children: PrayerAlarmMode.values.map((mode) {
              final selected = _alarmMode == mode;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: InkWell(
                    onTap: () => setState(() => _alarmMode = mode),
                    borderRadius: BorderRadius.circular(ZiRadius.md),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(ZiRadius.md),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.cardBorder,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            mode.icon,
                            size: 18,
                            color: selected
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                          ziGap(4),
                          Text(
                            mode.label,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected
                                  ? AppColors.primaryDark
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          ziGap(14),
          Text(
            'Remind Me',
            style: ZiTypoStyles.inputLabel.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          ziGap(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [0, 5, 10, 15, 30].map((mins) {
              final selected = _leadMinutes == mins;
              return ChoiceChip(
                label: Text(mins == 0 ? 'At prayer time' : '$mins min early'),
                selected: selected,
                selectedColor: AppColors.softGreenGradient.colors.last,
                labelStyle: TextStyle(
                  color: selected
                      ? AppColors.primaryDark
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
                onSelected: (_) => setState(() => _leadMinutes = mins),
              );
            }).toList(),
          ),
        ],

        ziGap(18),
        Row(
          children: [
            if (_isDefaultPrayer &&
                widget.existingPrayer!.hasCustomTimeOverride) ...[
              Expanded(
                child: ZiButtonB(
                  variant: ZiButtonVariantB.outline,
                  label: 'Reset Auto',
                  style: ZiButtonStyleB(
                    borderColor: AppColors.primary,
                    foregroundColor: AppColors.primary,
                    borderRadius: BorderRadius.circular(ZiRadius.md),
                  ),
                  action: () async {
                    await widget.controller.resetPrayerToAuto(
                      widget.existingPrayer!,
                    );
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ),
              ziGap(10),
            ] else if (widget.existingPrayer?.isCustomPrayer == true) ...[
              Expanded(
                child: ZiButtonB(
                  variant: ZiButtonVariantB.outline,
                  label: 'Delete',
                  style: ZiButtonStyleB(
                    borderColor: AppColors.error,
                    foregroundColor: AppColors.error,
                    borderRadius: BorderRadius.circular(ZiRadius.md),
                  ),
                  action: () async {
                    await widget.controller.deleteCustomPrayer(
                      widget.existingPrayer!,
                    );
                    if (context.mounted) Navigator.of(context).pop();
                  },
                ),
              ),
              ziGap(10),
            ],
            Expanded(
              flex: 2,
              child: ZiButtonB(
                variant: ZiButtonVariantB.primary,
                label: _isEditing ? 'Save Changes' : 'Add Namaz Timing',
                style: ZiButtonStyleB(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  borderRadius: BorderRadius.circular(ZiRadius.md),
                ),
                action: _save,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _LocationAndMethodSheetBody extends StatefulWidget {
  const _LocationAndMethodSheetBody({required this.controller});

  final NamazController controller;

  @override
  State<_LocationAndMethodSheetBody> createState() =>
      _LocationAndMethodSheetBodyState();
}

class _LocationAndMethodSheetBodyState
    extends State<_LocationAndMethodSheetBody> {
  final TextEditingController _searchController = TextEditingController();
  late final TextEditingController _customCityController;
  late final TextEditingController _latController;
  late final TextEditingController _lngController;
  String _query = '';
  bool _showCustomCoords = false;

  @override
  void initState() {
    super.initState();
    _showCustomCoords = widget.controller.useCustomCoordinates.value;
    _customCityController = TextEditingController(
      text: widget.controller.cityName.value,
    );
    _latController = TextEditingController(
      text: widget.controller.latitude.value.toStringAsFixed(4),
    );
    _lngController = TextEditingController(
      text: widget.controller.longitude.value.toStringAsFixed(4),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _customCityController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCities = NamazTimeCalculator.cityPresets.where((city) {
      if (_query.trim().isEmpty) return true;
      final q = _query.trim().toLowerCase();
      return city.city.toLowerCase().contains(q) ||
          city.country.toLowerCase().contains(q);
    }).toList();

    return Obx(() {
      final selectedMethod = widget.controller.calculationMethod.value;
      final selectedMadhab = widget.controller.madhab.value;
      final selectedCityId = widget.controller.selectedCityId.value;
      final use24h = widget.controller.use24HourFormat.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Time format & Madhab quick settings
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(ZiRadius.md),
            ),
            child: ZiSwitchTile(
              label: '24-Hour Time Format',
              value: use24h,
              onChanged: widget.controller.toggleTimeFormat,
            ),
          ),
          ziGap(14),

          Text(
            'Asr Juristic Method (Madhab)',
            style: ZiTypoStyles.titleSm.copyWith(color: AppColors.textPrimary),
          ),
          ziGap(8),
          Row(
            children: NamazMadhab.values.map((m) {
              final selected = selectedMadhab == m;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => widget.controller.setMadhab(m),
                    borderRadius: BorderRadius.circular(ZiRadius.md),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(ZiRadius.md),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.cardBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: selected
                                  ? AppColors.primaryDark
                                  : AppColors.textPrimary,
                            ),
                          ),
                          ziGap(2),
                          Text(
                            m.description,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          ziGap(14),

          Text(
            'Calculation Method',
            style: ZiTypoStyles.titleSm.copyWith(color: AppColors.textPrimary),
          ),
          ziGap(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: NamazCalculationPreset.values.map((method) {
              final selected = selectedMethod == method;
              return ChoiceChip(
                label: Text(method.shortLabel),
                selected: selected,
                selectedColor: AppColors.softGreenGradient.colors.last,
                labelStyle: TextStyle(
                  color: selected
                      ? AppColors.primaryDark
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
                onSelected: (_) =>
                    widget.controller.setCalculationMethod(method),
              );
            }).toList(),
          ),
          ziGap(16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'City / Coordinates',
                style: ZiTypoStyles.titleSm.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() => _showCustomCoords = !_showCustomCoords);
                },
                icon: Icon(
                  _showCustomCoords ? Icons.location_city : Icons.my_location,
                  size: 16,
                  color: AppColors.primary,
                ),
                label: Text(
                  _showCustomCoords ? 'City Presets' : 'Custom Lat/Lng',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          if (_showCustomCoords) ...[
            ZiInput(
              label: 'Location Name',
              hint: 'e.g. Multan, Pakistan',
              controller: _customCityController,
              variant: ZiInputVariant.outline,
            ),
            ziGap(10),
            Row(
              children: [
                Expanded(
                  child: ZiInput(
                    label: 'Latitude',
                    hint: '31.5204',
                    controller: _latController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    variant: ZiInputVariant.outline,
                  ),
                ),
                ziGap(10),
                Expanded(
                  child: ZiInput(
                    label: 'Longitude',
                    hint: '74.3587',
                    controller: _lngController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    variant: ZiInputVariant.outline,
                  ),
                ),
              ],
            ),
            ziGap(12),
            ZiButtonB(
              variant: ZiButtonVariantB.primary,
              expand: true,
              label: 'Apply Coordinates',
              style: ZiButtonStyleB(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                borderRadius: BorderRadius.circular(ZiRadius.md),
              ),
              action: () async {
                final lat = double.tryParse(_latController.text.trim());
                final lng = double.tryParse(_lngController.text.trim());
                if (lat == null ||
                    lng == null ||
                    lat < -90 ||
                    lat > 90 ||
                    lng < -180 ||
                    lng > 180) {
                  AppSnackbar.warning(
                    'Enter valid latitude (-90..90) and longitude (-180..180)',
                  );
                  return;
                }
                await widget.controller.setCustomCoordinates(
                  cityLabel: _customCityController.text,
                  lat: lat,
                  lng: lng,
                );
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ] else ...[
            ZiInput(
              hint: 'Search city or country...',
              controller: _searchController,
              variant: ZiInputVariant.outline,
              prefix: const Icon(Icons.search_rounded, color: AppColors.primary),
              onChanged: (value) => setState(() => _query = value),
            ),
            ziGap(10),
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: filteredCities.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final city = filteredCities[index];
                  final isSelected =
                      !widget.controller.useCustomCoordinates.value &&
                      selectedCityId == city.id;
                  return ListTile(
                    dense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                    leading: Icon(
                      Icons.location_on_rounded,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    title: Text(
                      city.displayName,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryDark
                            : AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      '${city.defaultMethod.shortLabel} • ${city.defaultMadhab.label}',
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          )
                        : null,
                    onTap: () async {
                      await widget.controller.selectCityPreset(city);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ],
      );
    });
  }
}

class _AlarmSettingsSheetBody extends StatelessWidget {
  const _AlarmSettingsSheetBody({required this.controller});

  final NamazController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final enabled = controller.adhanEnabled.value;
      final mode = controller.globalAlarmMode.value;
      final lead = controller.defaultLeadMinutes.value;
      final vibrate = controller.vibrateEnabled.value;
      final scheduled = controller.scheduledNotificationsCount.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(ZiRadius.md),
            ),
            child: ZiSwitchTile(
              label: 'Enable Prayer Alarms & Alerts',
              value: enabled,
              onChanged: (_) => controller.toggleAdhan(),
            ),
          ),
          ziGap(12),
          Row(
            children: [
              ZiStatusDot(
                color: enabled ? AppColors.success : AppColors.error,
                size: 9,
              ),
              ziGap(8),
              Expanded(
                child: Text(
                  enabled
                      ? '$scheduled upcoming prayer alerts scheduled for the next 7 days'
                      : 'All prayer alarms are currently paused',
                  style: ZiTypoStyles.bodySm.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          ziGap(16),

          Text(
            'Default Alarm Mode',
            style: ZiTypoStyles.titleSm.copyWith(color: AppColors.textPrimary),
          ),
          ziGap(8),
          Column(
            children: PrayerAlarmMode.values.map((item) {
              final selected = mode == item;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => controller.setGlobalAlarmMode(item),
                  borderRadius: BorderRadius.circular(ZiRadius.md),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primary.withValues(alpha: 0.10)
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(ZiRadius.md),
                      border: Border.all(
                        color: selected
                            ? AppColors.primary
                            : AppColors.cardBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          color: selected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        ziGap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: selected
                                      ? AppColors.primaryDark
                                      : AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                item.description,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selected)
                          const Icon(
                            Icons.check_circle_rounded,
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          ziGap(8),

          Text(
            'Default Reminder Offset',
            style: ZiTypoStyles.titleSm.copyWith(color: AppColors.textPrimary),
          ),
          ziGap(8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [0, 5, 10, 15, 30].map((mins) {
              final selected = lead == mins;
              return ChoiceChip(
                label: Text(mins == 0 ? 'Exact time' : '$mins min before'),
                selected: selected,
                selectedColor: AppColors.softGreenGradient.colors.last,
                labelStyle: TextStyle(
                  color: selected
                      ? AppColors.primaryDark
                      : AppColors.textSecondary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                ),
                onSelected: (_) => controller.setDefaultLeadMinutes(mins),
              );
            }).toList(),
          ),
          ziGap(14),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(ZiRadius.md),
            ),
            child: ZiSwitchTile(
              label: 'Vibrate on Alarm',
              value: vibrate,
              onChanged: controller.setVibrateEnabled,
            ),
          ),
          ziGap(16),

          ZiButtonB(
            variant: ZiButtonVariantB.primary,
            expand: true,
            icon: const Icon(
              Icons.notifications_active_rounded,
              color: AppColors.white,
              size: 18,
            ),
            label: 'Test Alarm Notification',
            style: ZiButtonStyleB(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              borderRadius: BorderRadius.circular(ZiRadius.md),
            ),
            action: controller.testAlarmNotification,
          ),
        ],
      );
    });
  }
}
