import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import '../models/drug_entry.dart';

Color getDrugColor(DrugColor drugColor, ColorScheme colorScheme) {
  final color = switch (drugColor) {
    DrugColor.blue => Colors.blue,
    DrugColor.orange => Colors.orange,
    DrugColor.red => Colors.red,
    DrugColor.yellow => Colors.yellow,
    DrugColor.green => Colors.green,
    DrugColor.purple => Colors.purple,
  };

  return color.harmonizeWith(colorScheme.primary);
}

// From: https://stackoverflow.com/a/77093434
Color getTextColor(Color color) {
  switch (ThemeData.estimateBrightnessForColor(color)) {
    case Brightness.dark:
      return Colors.white;
    case Brightness.light:
      return Colors.black;
  }
}
