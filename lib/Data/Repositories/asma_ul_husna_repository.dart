import '../Models/asma_ul_husna_model.dart';
import '../Sources/asset_data_source.dart';

class AsmaUlHusnaRepository {
  final AssetDataSource dataSource;
  List<AsmaUlHusnaModel>? _cachedNames;

  AsmaUlHusnaRepository(this.dataSource);

  Future<List<AsmaUlHusnaModel>> getNames() async {
    if (_cachedNames != null) {
      return List<AsmaUlHusnaModel>.unmodifiable(_cachedNames!);
    }

    final records = await dataSource.loadJsonList('asma_ul_husna.json');
    _cachedNames = records.map(AsmaUlHusnaModel.fromJson).toList();
    return List<AsmaUlHusnaModel>.unmodifiable(_cachedNames!);
  }
}
