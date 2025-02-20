import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/local/local_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationProvider extends ChangeNotifier {
  final LocalNotificationService flutterNotificationService;

  LocalNotificationProvider(this.flutterNotificationService);

  int _notificationId = 0;
  bool _isNotificationEnabled = false;

  bool get isNotificationEnabled => _isNotificationEnabled;

  bool? _permission;

  bool? get permission => _permission;

  List<PendingNotificationRequest> pendingNotificationRequests = [];

  Future<void> initialize() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    _isNotificationEnabled =
        sharedPrefs.getBool('isNotificationEnabled') ?? false;

    _permission = await flutterNotificationService.requestPermission();

    if (_permission == true) {
      await flutterNotificationService.configureLocalTimeZone();

      if (_isNotificationEnabled) {
        _notificationId = 1;
        debugPrint(
            "Scheduling notification during initialize"); // TODO: nanti hapus debug
        await flutterNotificationService.scheduleDailyElevenAMNotification(
          id: _notificationId,
        );
      } else {
        debugPrint(
            "Canceling notification during initialize"); // TODO: nanti hapus debug
        await flutterNotificationService.cancelNotification(_notificationId);
      }
    }

    await checkPendingNotificationRequests();
    notifyListeners();
  }

  Future<void> toggleNotification(bool value) async {
    _isNotificationEnabled = value;
    notifyListeners();

    final sharedPrefs = await SharedPreferences.getInstance();
    sharedPrefs.setBool('isNotificationEnabled', _isNotificationEnabled);

    if (_isNotificationEnabled) {
      _notificationId = 1;
      debugPrint("Scheduling notification with ID $_notificationId"); //TODO
      await flutterNotificationService.scheduleDailyElevenAMNotification(
        id: _notificationId,
      );
    } else {
      debugPrint("Canceling notification with ID $_notificationId"); //TODO
      await flutterNotificationService.cancelNotification(_notificationId);

      final pendingNotifications = 
      await flutterNotificationService.pendingNotificationRequests();

      for (var notification in pendingNotifications) {
        await flutterNotificationService.cancelNotification(notification.id);
        debugPrint("Canceled notification with ID ${notification.id}"); //TODO
      } 
    }

    await checkPendingNotificationRequests();
  }

  Future<void> scheduleDailyElevenAMNotification() async {
    _notificationId = 1;
    await flutterNotificationService.scheduleDailyElevenAMNotification(
      id: _notificationId,
    );
  }

  Future<void> checkPendingNotificationRequests() async {
    pendingNotificationRequests =
        await flutterNotificationService.pendingNotificationRequests();
    debugPrint(
        "Pending notifications: ${pendingNotificationRequests.map((e) => e.id).toList()}"); //TODO : nanti hapus debug
    notifyListeners();
  }

  Future<void> cancelNotification(int id) async {
    debugPrint("Attempting to cancel notification with ID $id");
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
