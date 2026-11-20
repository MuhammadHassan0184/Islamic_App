
import '../Models/dua_model.dart';
import '../Sources/asset_data_source.dart';

class DuaRepository {
  final AssetDataSource dataSource;

  DuaRepository(this.dataSource);

  Future<List<DuaModel>> getDuas() async {
    final jsonList = await dataSource.loadJsonList(
      'daily_duas.json',
    );

    return jsonList
        .map((json) => DuaModel.fromJson(json))
        .toList();
  }
}
