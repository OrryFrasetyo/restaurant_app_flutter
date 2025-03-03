import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/screen/detail/detail_menu_card_widget.dart';
import 'package:restaurant_app/screen/detail/favorite_icon_widget.dart';
import 'package:restaurant_app/screen/detail/restaurant_description_widget.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class BodyOfDetailScreenWidget extends StatelessWidget {
  static const String _baseUrl =
      "https://restaurant-api.dicoding.dev/images/large/";

  final RestaurantDetail restaurant;

  const BodyOfDetailScreenWidget({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: restaurant.id,
                child: Image.network(
                  _baseUrl + restaurant.pictureId,
                  loadingBuilder: (context, value, loadingStatus) {
                    if (loadingStatus == null) return value;
                    return Center(
                      child: Lottie.asset(
                        'assets/animations/loading.json',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.broken_image,
                      size: 50,
                      color: RestaurantColors.primary.color,
                    );
                  },
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    restaurant.name,
                    style: RestaurantTextStyles.headlineLarge,
                  ),
                ),
                ChangeNotifierProvider(
                  create: (context) => FavoriteIconProvider(),
                  child: Consumer<RestaurantDetailProvider>(
                    builder: (context, value, child) {
                      return switch (value.resultState) {
                        RestaurantDetailLoadedState(data: var restaurant) =>
                          FavoriteIconWidget(restaurant: restaurant),
                        _ => SizedBox(),
                      };
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: RestaurantColors.locationIcon.color,
                  size: 24,
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  "${restaurant.city}, ${restaurant.address}",
                  style: RestaurantTextStyles.bodyMedium,
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: RestaurantColors.ratingIcon.color,
                  size: 24,
                ),
                SizedBox(
                  width: 4.0,
                ),
                Text(
                  restaurant.rating.toString(),
                  style: RestaurantTextStyles.bodyMedium,
                ),
              ],
            ),
            SizedBox(
              height: 16.0,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: RestaurantDescriptionWidget(
                  description: restaurant.description,
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Categories: ",
              style: RestaurantTextStyles.titleMedium,
            ),
            SizedBox(
              height: 8.0,
            ),
            Wrap(
              spacing: 8.0,
              children: restaurant.categories.map((category) {
                return Chip(
                  backgroundColor: RestaurantColors.primary.color,
                  label: Text(
                    category.name,
                    style: RestaurantTextStyles.titleMedium.copyWith(
                      color: RestaurantColors.surface.color,
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Menus: ",
              style: RestaurantTextStyles.titleMedium,
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "Foods: ",
              style: RestaurantTextStyles.titleSmall,
            ),
            SizedBox(
              height: 8.0,
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3 / 2,
              ),
              itemCount: restaurant.menus.foods.length,
              itemBuilder: (context, index) {
                final food = restaurant.menus.foods[index];
                return DetailMenuCardWidget(
                  icon: Icons.fastfood,
                  name: food.name,
                  color: RestaurantColors.primary.color,
                );
              },
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "Drinks: ",
              style: RestaurantTextStyles.titleSmall,
            ),
            SizedBox(
              height: 8.0,
            ),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 3 / 2,
              ),
              itemCount: restaurant.menus.drinks.length,
              itemBuilder: (context, index) {
                final drink = restaurant.menus.drinks[index];
                return DetailMenuCardWidget(
                  icon: Icons.local_drink,
                  name: drink.name,
                  color: RestaurantColors.primary.color,
                );
              },
            ),
            SizedBox(
              height: 16.0,
            ),
            Text(
              "Customer Reviews: ",
              style: RestaurantTextStyles.titleMedium,
            ),
            SizedBox(
              height: 8.0,
            ),
            ...restaurant.customerReviews.map(
              (review) {
                return Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: RestaurantColors.primary.color,
                        radius: 24,
                        child: Icon(
                          Icons.person,
                          color: RestaurantColors.onPrimary.color,
                          size: 24,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.name,
                              style: RestaurantTextStyles.titleMedium,
                            ),
                            SizedBox(
                              height: 6.0,
                            ),
                            Text(
                              review.date,
                              style: RestaurantTextStyles.labelSmall,
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              review.review,
                              style: RestaurantTextStyles.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
