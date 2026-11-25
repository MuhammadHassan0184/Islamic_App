import '../Models/quiz_model.dart';
import '../Sources/asset_data_source.dart';

class QuizRepository {
  final AssetDataSource dataSource;

  QuizRepository(this.dataSource);

  Future<List<QuizModel>> getQuizList() async {
    final records = await dataSource.loadJsonList('quiz.json');
    return List<QuizModel>.unmodifiable(
      records.map((item) => QuizModel.fromJson(item)),
    );
  }
}
