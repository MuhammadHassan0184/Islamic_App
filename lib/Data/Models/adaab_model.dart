class AdaabModel {
  final String id;
  final String category;
  final String title;
  final String arabic;
  final String urdu;
  final String english;
  final String reference;
  final List<AdaabStep> steps;

  const AdaabModel({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.urdu,
    required this.english,
    required this.reference,
    required this.steps,
  });

  factory AdaabModel.fromJson(Map<String, dynamic> json) {
    return AdaabModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      arabic: json['arabic']?.toString() ?? '',
      urdu: json['urdu']?.toString() ?? '',
      english: json['english']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      steps: (json['steps'] as List? ?? const [])
          .whereType<Map>()
          .map((step) => AdaabStep.fromJson(Map<String, dynamic>.from(step)))
          .toList(),
    );
  }
}

class AdaabStep {
  final int stepNo;
  final String title;
  final String detail;

  const AdaabStep({
    required this.stepNo,
    required this.title,
    required this.detail,
  });

  factory AdaabStep.fromJson(Map<String, dynamic> json) {
    return AdaabStep(
      stepNo: int.tryParse(json['step_no']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
    );
  }
}
