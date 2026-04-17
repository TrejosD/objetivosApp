import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppTheme {
  final Brightness brightness;
  final String? brighnessOveride;
  AppTheme({required this.brightness, this.brighnessOveride});

  // necesito, una lista de Strings para cada stylo.. Asi busque si contiene ese String la lista
  final List<String> light = ['styleList.2'.tr()];
  final List<String> dark = ['styleList.3'.tr()];

  Brightness overrideTheme(String? brighnessOveride) {
    Brightness newStyle = brightness;
    if (brighnessOveride != null) {
      if (light.contains(brighnessOveride)) {
        return newStyle = Brightness.light;
      } else if (dark.contains(brighnessOveride)) {
        return newStyle = Brightness.dark;
      }
      return newStyle = brightness;
    }
    return newStyle;
  }

  ThemeData theme() {
    return ThemeData(
      brightness: brighnessOveride != null
          ? overrideTheme(brighnessOveride)
          : brightness,
    );
  }
}
