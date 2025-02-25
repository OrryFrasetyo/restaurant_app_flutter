import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/static/my_workmanager.dart';
import 'package:workmanager/workmanager.dart';

// @pragma('vm:entry-point')
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     final apiServices = ApiServices();
//     final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//     if (task == MyWorkmanager.oneOff.taskName ||
//         task == MyWorkmanager.oneOff.uniqueName ||
//         task == Workmanager.iOSBackgroundTask) {
//       print("inputData: $inputData");
//     } else if (task == MyWorkmanager.periodic.taskName) {
//       final restaurantListResponse = await apiServices.getRestaurantList();
//       if (restaurantListResponse.error) {
//         print("Failed to fetch restaurant list");
//         return Future.value(false);
//       }

//       final restaurants = restaurantListResponse.restaurants;
//       if (restaurants.isEmpty) {
//         print("No restaurants found");
//         return Future.value(false);
//       }

//       final randomIndex = Random().nextInt(restaurants.length);
//       final restaurantId = restaurants[randomIndex].id;

//       final restaurantDetailResponse = await apiServices.getRestaurantDetail(restaurantId);
//       if (restaurantDetailResponse.error) {
//         print("Failed to fetch restaurant detail");
//         return Future.value(false);
//       }

//       final restaurant = restaurantDetailResponse.restaurant;

//       var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'daily_reminder_channel_id',
//         'Daily Reminder Channel',
//         channelDescription: 'Channel for daily reminders',
//         importance: Importance.max,
//         priority: Priority.high,
//         showWhen: false,
//       );

//       var platformChannelSpecifics =
//           NotificationDetails(android: androidPlatformChannelSpecifics);

//       await flutterLocalNotificationsPlugin.show(
//         0,
//         'Daily Restaurant Recommendation',
//         'Restaurant Name: ${restaurant.name}\nDescription: ${restaurant.description}',
//         platformChannelSpecifics,
//         payload: 'item x',
//       );
//     }

//     return Future.value(true);
//   });
// }

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final apiServices = ApiServices();
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    if (task == MyWorkmanager.oneOff.taskName ||
        task == MyWorkmanager.oneOff.uniqueName ||
        task == Workmanager.iOSBackgroundTask) {
      print("inputData: $inputData");
    } else if (task == MyWorkmanager.periodic.taskName) {
      final restaurantListResponse = await apiServices.getRestaurantList();
      if (restaurantListResponse.restaurants.isNotEmpty) {
        int randomNumber =
            Random().nextInt(restaurantListResponse.restaurants.length);
        final restaurant = restaurantListResponse.restaurants[randomNumber];

        var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'daily_reminder_channel_id',
          'Daily Reminder Channel',
          channelDescription: 'Channel for daily reminders',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        );

        var platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        await flutterLocalNotificationsPlugin.show(
          0,
          'Daily Restaurant Recommendation',
          'Restaurant Name: ${restaurant.name}\nDescription: ${restaurant.description}',
          platformChannelSpecifics,
          payload: 'item x',
        );
      }
    }

    return Future.value(true);
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager])
      : _workmanager = workmanager ??= Workmanager();

  Future<void> init() async {
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await runPeriodicTask();
    print("Periodic task scheduled");
  }

  Future<void> runOneOffTask() async {
    await _workmanager.registerOneOffTask(
      MyWorkmanager.oneOff.uniqueName,
      MyWorkmanager.oneOff.taskName,
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
      initialDelay: const Duration(seconds: 5),
      inputData: {
        "data": "This is a valid payload from oneoff task workmanager",
      },
    );
  }

  Future<void> runPeriodicTask() async {
    await _workmanager.registerPeriodicTask(
      MyWorkmanager.periodic.uniqueName,
      MyWorkmanager.periodic.taskName,
      frequency: const Duration(days: 1),
      initialDelay: Duration.zero,
      inputData: {
        "data": "This is a valid payload from periodic task workmanager",
      },
    );
  }

  Future<void> cancelAllTask() async {
    await _workmanager.cancelAll();
  }
}
