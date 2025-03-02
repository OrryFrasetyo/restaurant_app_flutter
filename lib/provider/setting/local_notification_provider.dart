import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/shared_preferences_service.dart';
import 'package:restaurant_app/data/local/local_notification_service.dart';
import 'package:restaurant_app/data/local/workmanager_service.dart';
import 'package:workmanager/workmanager.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final SharedPreferencesService _sharedPreferencesService;
  bool _isNotificationEnabled = false;
  final LocalNotificationService flutterNotificationService;

  bool? _permission = true;
  bool? get permission => _permission;

  LocalNotificationProvider(
    this._sharedPreferencesService,
    this.flutterNotificationService,
  ) {
    _loadDailyNotif();
  }
  bool get isNotificationEnabled => _isNotificationEnabled;

  Future<void> requestPermissions() async {
    _permission = await flutterNotificationService.requestPermissions();
    notifyListeners();
  }

  Future<void> _loadDailyNotif() async {
    _isNotificationEnabled =
        await _sharedPreferencesService.getSettingDailyReminder();

    if (_isNotificationEnabled) {
      print("Status notifikasi dari SharedPreferences: $_isNotificationEnabled");
      notifyListeners();
    } else {
      await Workmanager().cancelAll();
      notifyListeners();
    }
  }

  Future<void> toggleDailyNotif(bool value) async {
    _isNotificationEnabled = value;

    print("toggleDailyNotif dipanggil dengan nilai: $value");

    // Add permission check
    if (value && _permission != true) {
      print("Requesting permissions first...");
      await requestPermissions();
      if (_permission != true) {
        print("Permission denied!");
        _isNotificationEnabled = false;
        notifyListeners();
        return;
      }
    }

    await _sharedPreferencesService.saveSettingDailyReminder(
      _isNotificationEnabled,
    );

    if (_isNotificationEnabled) {
      // menjadwalkan reminder di jam 11
      WorkmanagerService().scheduleDailyElevenAMNotification();
      notifyListeners();
    } else {
      notifyListeners();
      await Workmanager().cancelAll();
      print('data dihapus');
    }
  }
}