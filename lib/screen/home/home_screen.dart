import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/setting/local_notification_provider.dart';
import 'package:restaurant_app/screen/home/home_app_bar_widget.dart';
import 'package:restaurant_app/screen/home/home_error_state_widget.dart';
import 'package:restaurant_app/screen/home/restaurant_list_widget.dart';
import 'package:restaurant_app/screen/loading/loading_state_widget.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _fetchRestaurantList();
    _scheduleDailyElevenAMNotification();
    context.read<LocalNotificationProvider>().initialize();
  }

  void _fetchRestaurantList() {
    Future.microtask(() {
      if (!mounted) return;
      context.read<RestaurantListProvider>().fetchRestaurantList();
    });
  }

  Future<void> _scheduleDailyElevenAMNotification() async {
    context
        .read<LocalNotificationProvider>()
        .scheduleDailyElevenAMNotification();
  }

  // Future<void> _checkPendingNotificationRequests() async {
  //   final localNotificationProvider = context.read<LocalNotificationProvider>();
  //   await localNotificationProvider.checkPendingNotificationRequests();

  //   if (!mounted) {
  //     return;
  //   }

  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       final pendingData = context
  //           .watch<LocalNotificationProvider>()
  //           .pendingNotificationRequests;
  //       return AlertDialog(
  //         title: Text(
  //           '${pendingData.length} pending notification requests',
  //           style: RestaurantTextStyles.titleMedium,
  //           maxLines: 1,
  //           overflow: TextOverflow.ellipsis,
  //         ),
  //         content: SizedBox(
  //           width: 300,
  //           height: 300,
  //           child: ListView.builder(
  //             itemCount: pendingData.length,
  //             itemBuilder: (context, index) {
  //               final item = pendingData[index];
  //               return ListTile(
  //                 title: Text(
  //                   item.title ?? "",
  //                   style: RestaurantTextStyles.titleSmall,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 subtitle: Text(
  //                   item.body ?? "",
  //                   style: RestaurantTextStyles.bodySmall,
  //                   maxLines: 1,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 contentPadding: EdgeInsets.zero,
  //                 trailing: IconButton(
  //                   onPressed: () {
  //                     localNotificationProvider.cancelNotification(item.id);
  //                   },
  //                   icon: Icon(Icons.delete_outline),
  //                 ),
  //               );
  //             },
  //             shrinkWrap: true,
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text(
  //               "OK",
  //               style: RestaurantTextStyles.labelLarge,
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
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
