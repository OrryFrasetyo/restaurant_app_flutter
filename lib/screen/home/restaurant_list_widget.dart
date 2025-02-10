import 'package:flutter/widgets.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

class RestaurantListWidget extends StatelessWidget {
  final List restaurants;
  final VoidCallback onRetry;

  const RestaurantListWidget({
    super.key,
    required this.restaurants,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return RestaurantCardWidget(
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
    );
  }
}
