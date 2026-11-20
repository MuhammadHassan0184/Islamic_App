import 'dart:convert';
import 'package:flutter/services.dart';

class AssetDataSource {
  static final Map<String, List<Map<String, dynamic>>> _cache = {};

  Future<List<Map<String, dynamic>>> loadJsonList(String fileName) async {
    if (_cache.containsKey(fileName)) {
      return _cache[fileName]!;
    }

    final jsonString = await rootBundle.loadString('assets/data/$fileName');

    final decodedData = jsonDecode(jsonString);

    if (decodedData is! List) {
      throw FormatException('$fileName must contain a JSON list.');
    }

    final result = decodedData.map((item) {
      if (item is! Map) {
        throw FormatException('Invalid item found in $fileName.');
      }

      return Map<String, dynamic>.from(item);
    }).toList();

    _cache[fileName] = result;
    return result;
  }
}
