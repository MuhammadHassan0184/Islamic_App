import '../Models/library_collection_model.dart';
import '../Models/library_content_model.dart';
import '../Sources/asset_data_source.dart';

class LibraryContentRepository {
  final AssetDataSource dataSource;

  LibraryContentRepository(this.dataSource);

  Future<List<LibraryContentModel>> getItems(
    LibraryCollectionModel collection,
  ) async {
    final records = await dataSource.loadJsonList(collection.fileName);
    return List<LibraryContentModel>.unmodifiable(
      records.map(LibraryContentModel.fromJson),
    );
  }
}
