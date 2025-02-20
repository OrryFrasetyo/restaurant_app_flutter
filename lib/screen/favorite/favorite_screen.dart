import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app/screen/favorite/favorite_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    _loadAllRestaurant();
    super.initState();
  }

  void _loadAllRestaurant() {
    Future.microtask(() {
      if (!mounted) return;
      context.read<LocalDatabaseProvider>().loadAllRestaurant();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorite",
          style: RestaurantTextStyles.headlineSmall.copyWith(
            color: RestaurantColors.onPrimary.color,
          ),
        ),
        backgroundColor: RestaurantColors.primary.color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(12.0),
          ),
        ),
      ),
      body: Consumer<LocalDatabaseProvider>(
        builder: (context, value, child) {
          final favoriteList = value.restaurantList;
          return switch (favoriteList.isNotEmpty) {
            true => ListView.builder(
                itemCount: favoriteList.length,
                itemBuilder: (context, index) {
                  final restaurant = favoriteList[index];
                  return FavoriteCardWidget(
                    restaurant: restaurant,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.detailRoute.name,
                        arguments: restaurant.id,
                      );
                    },
                  );
                },
              ),
            _ => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/empty.json',
                      width: 70,
                      height: 70,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "No Favorite.",
                      style: RestaurantTextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}
