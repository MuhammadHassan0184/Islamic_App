import '../Models/adaab_model.dart';
import '../Sources/asset_data_source.dart';

class AdaabRepository {
  final AssetDataSource dataSource;
  List<AdaabModel>? _cachedAdaab;

  AdaabRepository(this.dataSource);

  Future<List<AdaabModel>> getAdaab() async {
    if (_cachedAdaab != null) {
      return List<AdaabModel>.unmodifiable(_cachedAdaab!);
    }

    final records = await dataSource.loadJsonList('adaab.json');
    _cachedAdaab = records.map(AdaabModel.fromJson).toList();
    return List<AdaabModel>.unmodifiable(_cachedAdaab!);
  }
}
