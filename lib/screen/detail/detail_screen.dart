import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/screen/detail/body_of_detail_screen_widget.dart';
import 'package:restaurant_app/screen/detail/detail_app_bar_widget.dart';
import 'package:restaurant_app/screen/detail/detail_error_state_widget.dart';
import 'package:restaurant_app/screen/loading/loading_state_widget.dart';
import 'package:restaurant_app/screen/review/add_review_widget.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class DetailScreen extends StatefulWidget {
  final String restaurantId;

  const DetailScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  void initState() {
    super.initState();
    _fetchRestaurantDetail();
  }

  void _fetchRestaurantDetail() {
    Future.microtask(() {
      context
          .read<RestaurantDetailProvider>()
          .fetchRestaurantDetail(widget.restaurantId);
    });
  }

  void _showAddReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 16.0,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                  right: 16.0,
                  left: 16.0),
              child: AddReviewWidget(restaurantId: widget.restaurantId),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DetailAppBarWidget(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<RestaurantDetailProvider>(
              builder: (context, value, child) {
                return switch (value.resultState) {
                  RestaurantDetailLoadingState() => LoadingStateWidget(),
                  RestaurantDetailLoadedState(data: var restaurant) =>
                    BodyOfDetailScreenWidget(restaurant: restaurant),
                  RestaurantDetailErrorState(error: var message) =>
                    DetailErrorStateWidget(errorMessage: message),
                  _ => SizedBox(),
                };
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: ElevatedButton(
              onPressed: () => _showAddReviewDialog(context),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                backgroundColor: RestaurantColors.primary.color,
                foregroundColor: RestaurantColors.surface.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4.0,
              ),
              child: Text(
                "Add Review",
                style: RestaurantTextStyles.titleSmall,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
