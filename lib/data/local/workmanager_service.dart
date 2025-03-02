import 'dart:developer';

import 'package:restaurant_app/data/local/local_notification_service.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  log("Menjadwalkan notifikasi pada: ");

  Workmanager().executeTask((task, inputData) async {
    if (task == "daily_restaurant_notification") {
      log("load...");
      await LocalNotificationService.sendRestaurantNotification();
      log("Notifikasi berhasil dijadwalkan!");
    }
    return Future.value(true);
  });
}

class WorkmanagerService {
  final Workmanager _workmanager;

  WorkmanagerService([Workmanager? workmanager])
    : _workmanager = workmanager ??= Workmanager();

  void initialize() async {
    log("Initializing WorkManager...");
    await _workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  }

  void scheduleDailyElevenAMNotification() async {
    final datetimeSchedule =
        LocalNotificationService().nextInstanceOfElevenAM();

    log("Current time: ${DateTime.now()}");
    log("Scheduling notification with delay: $datetimeSchedule");

    await _workmanager.registerPeriodicTask(
      "daily_restaurant_notification",
      "daily_restaurant_notification",
      frequency: Duration(days: 1),
      initialDelay: datetimeSchedule,
    );
  }
}