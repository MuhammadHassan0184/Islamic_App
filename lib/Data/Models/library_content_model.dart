class LibraryContentModel {
  final String id;
  final String category;
  final String title;
  final String arabic;
  final String urdu;
  final String english;
  final String reference;
  final List<LibraryStepModel> steps;
  final Map<String, dynamic> extraFields;

  const LibraryContentModel({
    required this.id,
    required this.category,
    required this.title,
    required this.arabic,
    required this.urdu,
    required this.english,
    required this.reference,
    required this.steps,
    required this.extraFields,
  });

  factory LibraryContentModel.fromJson(Map<String, dynamic> json) {
    final rawSteps = json['steps'];
    final steps = rawSteps is List
        ? rawSteps
              .whereType<Map>()
              .map(
                (step) =>
                    LibraryStepModel.fromJson(Map<String, dynamic>.from(step)),
              )
              .toList()
        : <LibraryStepModel>[];

    const standardFields = {
      'id',
      'category',
      'title',
      'arabic',
      'urdu',
      'english',
      'reference',
      'steps',
    };

    return LibraryContentModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      arabic: json['arabic']?.toString() ?? '',
      urdu: json['urdu']?.toString() ?? '',
      english: json['english']?.toString() ?? '',
      reference: json['reference']?.toString() ?? '',
      steps: List.unmodifiable(steps),
      extraFields: Map.unmodifiable({
        for (final entry in json.entries)
          if (!standardFields.contains(entry.key)) entry.key: entry.value,
      }),
    );
  }
}

class LibraryStepModel {
  final int stepNumber;
  final String title;
  final String detail;

  const LibraryStepModel({
    required this.stepNumber,
    required this.title,
    required this.detail,
  });

  factory LibraryStepModel.fromJson(Map<String, dynamic> json) {
    return LibraryStepModel(
      stepNumber: int.tryParse(json['step_no']?.toString() ?? '') ?? 0,
      title: json['title']?.toString() ?? '',
      detail: json['detail']?.toString() ?? '',
    );
  }
}
