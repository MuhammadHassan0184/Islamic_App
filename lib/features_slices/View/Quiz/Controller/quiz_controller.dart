import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../Data/Models/quiz_model.dart';
import '../../../../Data/Repositories/quiz_repository.dart';

class QuizController extends GetxController {
  final QuizRepository repository;

  QuizController(this.repository);

  final RxList<QuizModel> allQuizzes = <QuizModel>[].obs;
  final RxList<String> categories = <String>['All'].obs;
  final RxString selectedCategory = 'All'.obs;

  final RxInt currentIndex = 0.obs;
  final Rx<int?> selectedOptionIndex = Rx<int?>(null);
  final RxBool isSubmitted = false.obs;
  final RxInt score = 0.obs;
  final RxMap<int, int> answeredQuestions = <int, int>{}.obs;
  final RxBool isFinished = false.obs;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadQuizzes();
  }

  List<QuizModel> get filteredQuizzes {
    if (selectedCategory.value == 'All') {
      return allQuizzes;
    }
    return allQuizzes
        .where(
          (q) =>
              q.category.toLowerCase() == selectedCategory.value.toLowerCase(),
        )
        .toList();
  }

  QuizModel? get currentQuestion {
    final list = filteredQuizzes;
    if (list.isEmpty || currentIndex.value >= list.length) return null;
    return list[currentIndex.value];
  }

  int get totalQuestions => filteredQuizzes.length;

  double get progress {
    if (totalQuestions == 0) return 0.0;
    return (currentIndex.value + 1) / totalQuestions;
  }

  Future<void> loadQuizzes() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await repository.getQuizList();
      allQuizzes.assignAll(list);

      // Extract unique categories
      final catSet = <String>{'All'};
      for (final q in list) {
        if (q.category.isNotEmpty) {
          catSet.add(q.category);
        }
      }
      categories.assignAll(catSet.toList());

      // If category was passed as argument via Get.toNamed
      final dynamic args = Get.arguments;
      if (args is Map<String, dynamic> && args.containsKey('category')) {
        final cat = args['category']?.toString();
        if (cat != null && categories.contains(cat)) {
          selectedCategory.value = cat;
        }
      } else if (args is String && categories.contains(args)) {
        selectedCategory.value = args;
      }

      resetQuizState();
    } catch (e, stack) {
      debugPrint('Error loading quiz: $e');
      debugPrintStack(stackTrace: stack);
      errorMessage.value = 'Failed to load Islamic Quiz data. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String cat) {
    if (selectedCategory.value == cat) return;
    selectedCategory.value = cat;
    resetQuizState();
  }

  void resetQuizState() {
    currentIndex.value = 0;
    selectedOptionIndex.value = null;
    isSubmitted.value = false;
    score.value = 0;
    answeredQuestions.clear();
    isFinished.value = false;
  }

  void selectOption(int index) {
    if (isSubmitted.value) return; // Do not allow changing once submitted
    selectedOptionIndex.value = index;
  }

  void submitAnswer() {
    if (selectedOptionIndex.value == null || isSubmitted.value) return;

    final question = currentQuestion;
    if (question == null) return;

    isSubmitted.value = true;
    final selected = selectedOptionIndex.value!;
    answeredQuestions[currentIndex.value] = selected;

    if (selected == question.correctIndex) {
      score.value++;
    }
  }

  void nextQuestion() {
    if (currentIndex.value < totalQuestions - 1) {
      currentIndex.value++;
      selectedOptionIndex.value = null;
      isSubmitted.value = false;
    } else {
      isFinished.value = true;
    }
  }

  void previousQuestion() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      final prevSelected = answeredQuestions[currentIndex.value];
      selectedOptionIndex.value = prevSelected;
      isSubmitted.value = prevSelected != null;
    }
  }

  void restartQuiz() {
    resetQuizState();
  }

  void jumpToQuestion(int index) {
    if (index >= 0 && index < totalQuestions) {
      currentIndex.value = index;
      final prevSelected = answeredQuestions[index];
      selectedOptionIndex.value = prevSelected;
      isSubmitted.value = prevSelected != null;
    }
  }
}
