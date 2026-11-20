import '../Models/zikr_model.dart';
import '../Sources/asset_data_source.dart';

class AzkarRepository {
  final AssetDataSource dataSource;
  List<ZikrModel>? _cachedAzkar;

  AzkarRepository(this.dataSource);

  Future<List<ZikrModel>> getAzkar() async {
    if (_cachedAzkar != null) {
      return List<ZikrModel>.unmodifiable(_cachedAzkar!);
    }

    final records = await dataSource.loadJsonList('azkar.json');
    _cachedAzkar = records.map(ZikrModel.fromJson).toList();
    return List<ZikrModel>.unmodifiable(_cachedAzkar!);
  }
}
