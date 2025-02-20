import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/setting/local_notification_provider.dart';
import 'package:restaurant_app/provider/setting/theme_provider.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final notificationProvider =
        Provider.of<LocalNotificationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              "Setting",
              style: RestaurantTextStyles.headlineSmall.copyWith(
                color: RestaurantColors.onPrimary.color,
              ),
            ),
          ],
        ),
        backgroundColor: RestaurantColors.primary.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.0),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Notification",
              style: RestaurantTextStyles.titleMedium,
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Enable Notification"),
                Switch(
                  value: notificationProvider.isNotificationEnabled,
                  onChanged: (value) {
                    notificationProvider.toggleNotification(value);
                  },
                )
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Theme Mode",
              style: RestaurantTextStyles.titleMedium,
            ),
            SizedBox(
              height: 8.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Dark Theme",
                  style: RestaurantTextStyles.titleSmall,
                ),
                Switch(
                  value: themeProvider.isDarkTheme,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
