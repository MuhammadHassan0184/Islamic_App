class QuizStepModel {
  final int stepNo;
  final String title;
  final String detail;

  const QuizStepModel({
    required this.stepNo,
    required this.title,
    required this.detail,
  });

  factory QuizStepModel.fromJson(Map<String, dynamic> json) {
    return QuizStepModel(
      stepNo: (json['step_no'] as num?)?.toInt() ?? 1,
      title: json['title']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'step_no': stepNo,
    'title': title,
    'detail': detail,
  };
}

class QuizModel {
  final String id;
  final String category;
  final String title;
  final String arabic;
  final String urdu;
  final String english;
  final String reference;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final List<QuizStepModel> steps;

  const QuizModel({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.urdu,
    required this.english,
    required this.reference,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.steps,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    final rawOptions = json['options'];
    final optionsList = <String>[];
    if (rawOptions is List) {
      for (final opt in rawOptions) {
        optionsList.add(opt.toString());
      }
    }

    final rawSteps = json['steps'];
    final stepsList = <QuizStepModel>[];
    if (rawSteps is List) {
      for (final step in rawSteps) {
        if (step is Map<String, dynamic>) {
          stepsList.add(QuizStepModel.fromJson(step));
        } else if (step is Map) {
          stepsList.add(QuizStepModel.fromJson(Map<String, dynamic>.from(step)));
        }
      }
    }

    return QuizModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      arabic: json['arabic']?.toString() ?? '',
      urdu: json['urdu']?.toString() ?? '',
      english: json['english']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      options: List.unmodifiable(optionsList),
      correctIndex: (json['correct_index'] as num?)?.toInt() ?? 0,
      explanation: json['explanation']?.toString() ?? '',
      steps: List.unmodifiable(stepsList),
    );
  }

  String get categoryDisplayName {
    switch (category.toLowerCase()) {
      case 'pillars_of_islam':
        return 'Pillars of Islam';
      case 'quran':
        return 'Quran';
      case 'nimaz':
        return 'Namaz & Salah';
      case 'seerah':
        return 'Seerah';
      default:
        if (category.isEmpty) return 'General';
        return category
            .replaceAll('_', ' ')
            .split(' ')
            .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
            .join(' ');
    }
  }
}
