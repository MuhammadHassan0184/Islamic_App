import '../Models/dua_model.dart';
import '../Sources/asset_data_source.dart';

class DuaRepository {
  final AssetDataSource dataSource;
  List<DuaModel>? _cachedDuas;

  DuaRepository(this.dataSource);

  Future<List<DuaModel>> getDuas() async {
    if (_cachedDuas != null) {
      return List<DuaModel>.unmodifiable(_cachedDuas!);
    }

    final jsonList = await dataSource.loadJsonList('daily_duas.json');

    _cachedDuas = jsonList.map((json) => DuaModel.fromJson(json)).toList();

    return List<DuaModel>.unmodifiable(_cachedDuas!);
  }
}
