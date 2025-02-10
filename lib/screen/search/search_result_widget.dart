import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/screen/loading/loading_state_widget.dart';
import 'package:restaurant_app/screen/search/search_error_state_widget.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class SearchResultWidget extends StatelessWidget {
  const SearchResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RestaurantSearchProvider>(
      builder: (context, value, child) {
        final state = value.resultState;

        if (state is RestaurantSearchNoneState) {
          return Center(
            child: Text('Enter a keyword to search for restaurants.'),
          );
        } else if (state is RestaurantSearchLoadingState) {
          return Center(child: LoadingStateWidget());
        } else if (state is RestaurantSearchErrorState) {
          return Center(
            child: SearchErrorStateWidget(errorMessage: state.error),
          );
        } else if (state is RestaurantSearchLoadedState) {
          final restaurants = state.data;

          if (restaurants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/not_found.json',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    "Restaurants not found.",
                    style: RestaurantTextStyles.bodySmall,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              final restaurant = restaurants[index];
              return RestaurantCardWidget(
                restaurant: restaurant,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/detail",
                    arguments: restaurant.id,
                  );
                },
              );
            },
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
