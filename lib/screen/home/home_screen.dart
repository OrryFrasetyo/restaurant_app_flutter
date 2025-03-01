import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/local/local_notification_service.dart';
import 'package:restaurant_app/data/model/received_notification.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/setting/local_notification_provider.dart';
import 'package:restaurant_app/provider/setting/payload_provider.dart';
import 'package:restaurant_app/screen/home/home_app_bar_widget.dart';
import 'package:restaurant_app/screen/home/home_error_state_widget.dart';
import 'package:restaurant_app/screen/home/restaurant_list_widget.dart';
import 'package:restaurant_app/screen/loading/loading_state_widget.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    _configureSelectNotificationSubject();
    _configureDidReceiveLocalNotificationSubject();
    super.initState();
    _fetchRestaurantList();
    // _scheduleDailyElevenAMNotification();
    // context.read<LocalNotificationProvider;
    
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) {
      context.read<PayloadProvider>().payload = payload;
    });
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) {
      final payload = receivedNotification.payload;
      context.read<PayloadProvider>().payload = payload;
    });
  }

  void _fetchRestaurantList() {
    Future.microtask(() {
      if (!mounted) return;
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  @override
  void dispose() {
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  // Future<void> _scheduleDailyElevenAMNotification() async {
  //   context
  //       .read<LocalNotificationProvider>()
  //       .scheduleDailyElevenAMNotification();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBarWidget(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Consumer<RestaurantListProvider>(
          builder: (context, provider, child) {
            switch (provider.resultState) {
              case RestaurantListLoadingState():
                return LoadingStateWidget();
              case RestaurantListLoadedState(data: var restaurantList):
                return RestaurantListWidget(
                  restaurants: restaurantList,
                  onRetry: _fetchRestaurantList,
                );
              case RestaurantListErrorState(error: var message):
                return HomeErrorStateWidget(
                  errorMessage: message,
                  onRetry: _fetchRestaurantList,
                );
              default:
                return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
