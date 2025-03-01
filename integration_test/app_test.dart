import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/data/api/shared_preferences_service.dart';
import 'package:restaurant_app/data/local/local_database_service.dart';
import 'package:restaurant_app/data/local/local_notification_service.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app/provider/home/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/provider/review/restaurant_add_review_provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/setting/local_notification_provider.dart';
import 'package:restaurant_app/provider/setting/payload_provider.dart';
import 'package:restaurant_app/provider/setting/theme_provider.dart';
import 'package:restaurant_app/screen/main/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets("main screen load done", (WidgetTester tester) async {
    final notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    String? payload;

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      final notificationResponse =
          notificationAppLaunchDetails!.notificationResponse;
      payload = notificationResponse?.payload;
    }
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => IndexNavProvider(),
          ),
          Provider(
            create: (context) => ApiServices(),
          ),
          Provider(
            create: (context) => SharedPreferencesService(prefs),
          ),
          Provider(
            create: (context) => LocalDatabaseService(),
          ),
          Provider(
            create: (context) => LocalNotificationService(),
          ),
          ChangeNotifierProvider(
            create: (context) => RestaurantListProvider(
              context.read<ApiServices>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => RestaurantDetailProvider(
              context.read<ApiServices>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => RestaurantSearchProvider(
              context.read<ApiServices>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => RestaurantAddReviewProvider(
              context.read<ApiServices>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => LocalDatabaseProvider(
              context.read<LocalDatabaseService>(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => ThemeProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => PayloadProvider(payload: payload),
          ),
          ChangeNotifierProvider(
            create: (context) => LocalNotificationProvider(
              context.read<SharedPreferencesService>(),
              context.read<LocalNotificationService>(),
            ),
          ),
        ],
        child: MaterialApp(
          home: MainScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Restaurantqu'), findsOneWidget);
  });
}
