import 'package:flutter/material.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class HomeAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Restaurantqu",
        style: RestaurantTextStyles.headlineSmall.copyWith(
          color: RestaurantColors.onPrimary.color,
        ),
      ),
      backgroundColor: RestaurantColors.primary.color,
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
          ),
          color: RestaurantColors.onPrimary.color,
          onPressed: () {
            Navigator.pushNamed(
              context,
              NavigationRoute.searchRoute.name,
            );
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(30.0),
        child: Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            "Recommendation restaurant for you!",
            style: RestaurantTextStyles.titleMedium.copyWith(
              color: RestaurantColors.secondary.color,
            ),
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12.0),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(90.0);
}
