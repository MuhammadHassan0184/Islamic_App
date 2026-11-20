import 'package:flutter/material.dart';
import 'package:islam786/Utils/mediaquery_extension.dart';

double azkarFontSize(BuildContext context, double baseSize) {
  return context
      .scaledFont(baseSize)
      .clamp(baseSize * 0.9, baseSize * 1.2)
      .toDouble();
}
