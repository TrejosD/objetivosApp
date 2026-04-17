import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static late dynamic prefs;
  static Future<void> getPreference() async {
    prefs = await SharedPreferences.getInstance();
  }
}
