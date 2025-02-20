import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class FavoriteCardWidget extends StatelessWidget {
  static const String _baseUrl =
      "https://restaurant-api.dicoding.dev/images/medium/";
  final RestaurantDetail restaurant;
  final Function() onTap;

  const FavoriteCardWidget({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 16.0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 80,
                maxWidth: 120,
              ),
              child: Hero(
                tag: restaurant.id,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    _baseUrl + restaurant.pictureId,
                    loadingBuilder: (context, value, loadingStatus) {
                      if (loadingStatus == null) return value;
                      return Center(
                        child: Lottie.asset(
                          'assets/animations/loading.json',
                          width: 150,
                          height: 150,
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
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: RestaurantTextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_sharp,
                        color: RestaurantColors.locationIcon.color,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Expanded(
                        child: Text(
                          restaurant.city,
                          style: RestaurantTextStyles.titleSmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 6.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: RestaurantColors.ratingIcon.color,
                        size: 16.0,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text(
                        restaurant.rating.toString(),
                        style: RestaurantTextStyles.titleSmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
