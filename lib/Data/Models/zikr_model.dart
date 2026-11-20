class ZikrModel {
  final String id;
  final String category;
  final String title;
  final String arabic;
  final String urdu;
  final String english;
  final String reference;
  final int defaultTarget;
  final List<ZikrStep> steps;

  const ZikrModel({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.urdu,
    required this.english,
    required this.reference,
    required this.defaultTarget,
    required this.steps,
  });

  factory ZikrModel.fromJson(Map<String, dynamic> json) {
    final target = int.tryParse(json['default_target']?.toString() ?? '');
    return ZikrModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      arabic: json['arabic']?.toString() ?? '',
      urdu: json['urdu']?.toString() ?? '',
      english: json['english']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      defaultTarget: target != null && target > 0 ? target : 1,
      steps: (json['steps'] as List? ?? const [])
          .whereType<Map>()
          .map((step) => ZikrStep.fromJson(Map<String, dynamic>.from(step)))
          .toList(),
    );
  }
}

class ZikrStep {
  final int stepNo;
  final String title;
  final String detail;

  const ZikrStep({
    required this.stepNo,
    required this.title,
    required this.detail,
  });

  factory ZikrStep.fromJson(Map<String, dynamic> json) {
    return ZikrStep(
      stepNo: int.tryParse(json['step_no']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
    );
  }
}
