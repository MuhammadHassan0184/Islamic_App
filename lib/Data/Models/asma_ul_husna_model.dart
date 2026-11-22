class AsmaUlHusnaModel {
  final String id;
  final String category;
  final String title;
  final String arabic;
  final String urdu;
  final String english;
  final String reference;
  final int number;
  final String transliteration;
  final List<AsmaUlHusnaStep> steps;

  const AsmaUlHusnaModel({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.urdu,
    required this.english,
    required this.reference,
    required this.number,
    required this.transliteration,
    required this.steps,
  });

  factory AsmaUlHusnaModel.fromJson(Map<String, dynamic> json) {
    return AsmaUlHusnaModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      arabic: json['arabic']?.toString() ?? '',
      urdu: json['urdu']?.toString() ?? '',
      english: json['english']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      number: int.tryParse(json['number']?.toString() ?? '') ?? 0,
      transliteration: json['transliteration']?.toString() ?? '',
      steps: (json['steps'] as List? ?? const [])
          .whereType<Map>()
          .map(
            (step) => AsmaUlHusnaStep.fromJson(Map<String, dynamic>.from(step)),
          )
          .toList(),
    );
  }
}

class AsmaUlHusnaStep {
  final int stepNo;
  final String title;
  final String detail;

  const AsmaUlHusnaStep({
    required this.stepNo,
    required this.title,
    required this.detail,
  });

  factory AsmaUlHusnaStep.fromJson(Map<String, dynamic> json) {
    return AsmaUlHusnaStep(
      stepNo: int.tryParse(json['step_no']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
    );
  }
}
