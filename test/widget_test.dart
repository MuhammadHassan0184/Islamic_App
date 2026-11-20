import 'package:flutter_test/flutter_test.dart';
import 'package:islam786/Data/Models/dua_model.dart';
import 'package:islam786/Data/Sources/asset_data_source.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AssetDataSource loads the bundled daily Duas JSON', () async {
    final records = await AssetDataSource().loadJsonList('daily_duas.json');

    expect(records, isNotEmpty);
    expect(records.first['id'], isNotEmpty);
  });

  test('DuaModel parses Arabic, translations, reference, and steps', () {
    final dua = DuaModel.fromJson({
      'id': 'dua_test',
      'category': 'morning',
      'title': 'Test Dua',
      'arabic': 'اللهم',
      'urdu': 'اے اللہ',
      'english': 'O Allah',
      'reference': 'Test Reference',
      'steps': [
        {'step_no': 1, 'title': 'Step', 'detail': 'Read sincerely'},
      ],
    });

    expect(dua.id, 'dua_test');
    expect(dua.category, 'morning');
    expect(dua.arabic, 'اللهم');
    expect(dua.urdu, 'اے اللہ');
    expect(dua.reference, 'Test Reference');
    expect(dua.steps, hasLength(1));
    expect(dua.steps.first.detail, 'Read sincerely');
  });
}
