
class DuaModel {
  final String id;
  final String category;
  final String title;
  final String arabic;
  final String urdu;
  final String english;
  final String reference;
  final List<DuaStep> steps;

  const DuaModel({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.urdu,
    required this.english,
    required this.reference,
    required this.steps,
  });

  factory DuaModel.fromJson(Map<String, dynamic> json) {
    return DuaModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      arabic: json['arabic']?.toString() ?? '',
      urdu: json['urdu']?.toString() ?? '',
      english: json['english']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      steps: (json['steps'] as List? ?? [])
          .whereType<Map>()
          .map(
            (step) => DuaStep.fromJson(
              Map<String, dynamic>.from(step),
            ),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'arabic': arabic,
      'urdu': urdu,
      'english': english,
      'reference': reference,
      'steps': steps.map((step) => step.toJson()).toList(),
    };
  }
}

class DuaStep {
  final int stepNo;
  final String title;
  final String detail;

  const DuaStep({
    required this.stepNo,
    required this.title,
    required this.detail,
  });

  factory DuaStep.fromJson(Map<String, dynamic> json) {
    return DuaStep(
      stepNo: int.tryParse(json['step_no']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'step_no': stepNo,
      'title': title,
      'detail': detail,
    };
  }
}
