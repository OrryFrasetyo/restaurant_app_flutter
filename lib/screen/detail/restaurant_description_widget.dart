import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_description_provider.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class RestaurantDescriptionWidget extends StatelessWidget {
  final String description;

  const RestaurantDescriptionWidget({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RestaurantDescriptionProvider(),
      child: Consumer<RestaurantDescriptionProvider>(
        builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                description,
                style: RestaurantTextStyles.bodyMedium,
                maxLines: value.isExpanded ? 2 : 1000,
                overflow: TextOverflow.ellipsis,
              ),
              if (description.length > 100)
                GestureDetector(
                  onTap: value.toggleExpanded,
                  child: Text(
                    value.isExpanded ? 'Read More' : 'Read Less',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
