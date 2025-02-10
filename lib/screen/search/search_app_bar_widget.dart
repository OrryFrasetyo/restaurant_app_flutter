import 'package:flutter/material.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class SearchAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Search Restaurant",
        style: RestaurantTextStyles.headlineSmall.copyWith(
          color: RestaurantColors.onPrimary.color,
        ),
      ),
      backgroundColor: RestaurantColors.primary.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(12),
        ),
      ),
    );
  }
  
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}