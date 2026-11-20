
import 'dart:convert';
import 'package:flutter/services.dart';

class AssetDataSource {
  Future<List<Map<String, dynamic>>> loadJsonList(
    String fileName,
  ) async {
    final jsonString = await rootBundle.loadString(
      'assets/data/$fileName',
    );

    final decodedData = jsonDecode(jsonString);

    if (decodedData is! List) {
      throw FormatException(
        '$fileName must contain a JSON list.',
      );
    }

    return decodedData.map((item) {
      if (item is! Map) {
        throw FormatException(
          'Invalid item found in $fileName.',
        );
      }

      return Map<String, dynamic>.from(item);
    }).toList();
  }
}
