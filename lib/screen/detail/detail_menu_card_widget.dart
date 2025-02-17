import 'package:flutter/material.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class DetailMenuCardWidget extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;

  const DetailMenuCardWidget({
    super.key,
    required this.icon,
    required this.name,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fastfood,
            color: color,
            size: 36,
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: RestaurantTextStyles.titleSmall,
          ),
        ],
      ),
    );
  }
}
