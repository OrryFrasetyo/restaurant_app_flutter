import 'package:flutter/material.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearch;

  const SearchBarWidget({
    super.key,
    required this.searchController,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 10.0,
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        elevation: 3,
        child: TextField(
          style: RestaurantTextStyles.titleSmall,
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search restaurants...",
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(
                color: RestaurantColors.primary.color,
                width: 2.0, 
              ),
            ),
            filled: true,
            suffixIcon: InkWell(
              borderRadius: BorderRadius.circular(10.0),
              onTap: () => onSearch(searchController.text),
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.search,
                  color: RestaurantColors.primary.color,
                  size: 24.0,
                ),
              ),
            ),
          ),
          onSubmitted: onSearch,
        ),
      ),
    );
  }
}
