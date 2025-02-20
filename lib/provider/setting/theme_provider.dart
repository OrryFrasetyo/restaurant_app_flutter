import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeProvider() {
    _loadThemePreference();
  }

  Future<void> _loadThemePreference() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    _isDarkTheme = sharedPrefs.getBool("isDarkTheme") ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();

    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool("isDarkTheme", _isDarkTheme);
  }
}