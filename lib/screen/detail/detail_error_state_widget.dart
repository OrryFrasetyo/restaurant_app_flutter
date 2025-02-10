import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class DetailErrorStateWidget extends StatelessWidget {
  final String errorMessage;

  const DetailErrorStateWidget({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/animations/error.json',
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Failed to load detail",
            style: RestaurantTextStyles.titleLarge.copyWith(
              color: RestaurantColors.error.color,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: RestaurantTextStyles.bodyMedium.copyWith(
              color: RestaurantColors.onAlert.color,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Back to Home"),
          ),
        ],
      ),
    );
  }
}
