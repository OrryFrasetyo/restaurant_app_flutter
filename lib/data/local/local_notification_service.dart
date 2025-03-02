import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:restaurant_app/data/model/received_notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

class LocalNotificationService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev/list";
  static const String _workTask = "daily_restaurant_notification";

  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      'app_icon',
    );
    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        final payload = notificationResponse.payload;
        if (payload != null && payload.isNotEmpty) {
          selectNotificationStream.add(payload);
        }
      },
    );
  }

  Future<bool> _isAndroidPermissionGranted() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.areNotificationsEnabled() ??
        false;
  }

  Future<bool?> requestPermissions() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final iOSImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();
      return await iOSImplementation?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      final androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      final requestNotificationsPermission =
          await androidImplementation?.requestNotificationsPermission();
      final notificationEnabled = await _isAndroidPermissionGranted();
      final requestAlarmEnabled = await _requestExactAlarmsPermission();

      return (requestNotificationsPermission ?? false) &&
          notificationEnabled &&
          requestAlarmEnabled;
    } else {
      return false;
    }
  }

  Future<void> configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Duration nextInstanceOfElevenAM() {
    final DateTime now = DateTime.now();
    DateTime scheduledDate = DateTime(now.year, now.month, now.day, 7, 33);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    final initialDelay = scheduledDate.difference(now);
    return initialDelay;
  }

  Future<bool> _requestExactAlarmsPermission() async {
    return await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestExactAlarmsPermission() ??
        false;
  }

  static Future<void> sendRestaurantNotification() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List restaurants = data['restaurants'];
        if (restaurants.isNotEmpty) {
          final random = Random();
          final selectedRestaurant =
              restaurants[random.nextInt(restaurants.length)];

          FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
              FlutterLocalNotificationsPlugin();
          const AndroidNotificationDetails androidDetails =
              AndroidNotificationDetails(
            'daily_restaurant_channel',
            'Daily Restaurant Reminder',
            importance: Importance.high,
            priority: Priority.high,
          );

          const NotificationDetails details = NotificationDetails(
            android: androidDetails,
          );

          await flutterLocalNotificationsPlugin.show(
            0,
            "Try a New Rastaurant!",
            "Today recommendation: ${selectedRestaurant['name']}",
            details,
          );
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    await Workmanager().cancelByTag(_workTask);
  }
}
