import 'package:shared_preferences/shared_preferences.dart';

// este servicio permite guardar configuraciones que cambie el usuario como el lenguaje o tema claro\oscuro
class SharedPreferencesService {
  static late dynamic prefs;
  static Future<void> getPreference() async {
    prefs = await SharedPreferences.getInstance();
  }
}
