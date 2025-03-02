import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  final SharedPreferences _sharedPreferences;

  SharedPreferencesService(this._sharedPreferences);

  Future<void> saveSettingDailyReminder(bool daily) async {
    try {
      await _sharedPreferences.setBool('dailyBool', daily);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  bool getSettingDailyReminder() {
    return _sharedPreferences.getBool('dailyBool') ?? false;
  }
}