import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// configuracion del tema del app
class AppTheme {
  final Brightness brightness;
  final String? brighnessOveride;
  AppTheme({required this.brightness, this.brighnessOveride});

  // necesito, una lista de Strings para cada stylo.. Asi busque si contiene ese String la lista
  final List<String> light = ['styleList.2'.tr()];
  final List<String> dark = ['styleList.3'.tr()];
  // metodo logra que el usuario cambie el tema del app
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

  // metodo que llama el app para mostrar el tema
  ThemeData theme() {
    return ThemeData(
      brightness: brighnessOveride != null
          ? overrideTheme(brighnessOveride)
          : brightness,
    );
  }
}
