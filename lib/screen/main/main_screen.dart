import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/main/index_nav_provider.dart';
import 'package:restaurant_app/screen/favorite/favorite_screen.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/screen/setting/setting_screen.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<IndexNavProvider>(
        builder: (context, value, child) {
          return switch (value.indexBottomNavBar) {
            0 => HomeScreen(),
            1 => FavoriteScreen(), //perbaiki
            _ => SettingScreen(),
          };
        },
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        child: BottomNavigationBar(
          backgroundColor: RestaurantColors.primary.color,
          selectedItemColor: RestaurantColors.secondary.color,
          unselectedItemColor: RestaurantColors.surface.color,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          elevation: 0,
          currentIndex: context.watch<IndexNavProvider>().indexBottomNavBar,
          onTap: (index) {
            context.read<IndexNavProvider>().setIndexBottomNavBar = index;
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
              tooltip: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favorite",
              tooltip: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Setting",
              tooltip: "Setting",
            ),
          ],
        ),
      ),
    );
  }
}
