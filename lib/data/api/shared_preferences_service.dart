import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(this._sharedPreferences);

  Future<void> saveSettingLunchReminder(bool lunch) async {
    try {
      await _sharedPreferences.setBool('lunchBool', lunch);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  bool getSettingLunchReminder() {
    return _sharedPreferences.getBool('lunchBool') ?? false;
  }
}