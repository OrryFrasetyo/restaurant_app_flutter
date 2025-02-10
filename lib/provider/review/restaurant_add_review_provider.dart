import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/static/restaurant_review_result_state.dart';

class RestaurantAddReviewProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  RestaurantAddReviewProvider(
    this._apiServices,
  );

  RestaurantReviewResultState _resultState = RestaurantReviewNoneState();

  RestaurantReviewResultState get resultState => _resultState;

  Future<void> addRestaurantReview(
    String id,
    String name,
    String review,
  ) async {
    try {
      _resultState = RestaurantReviewLoadingState();
      notifyListeners();

      await Future.delayed(Duration(seconds: 1)); 

      final result = await _apiServices.postRestaurantReview(id, name, review);

      if (result.error) {
        _resultState = RestaurantReviewErrorState(
          "Failed to add review restaurant, Please try again.",
        );
        notifyListeners();
      } else {
        _resultState = RestaurantReviewLoadedState(result.customerReviews);
      }
    } on SocketException {
      _resultState = RestaurantReviewErrorState(
        "Network issue detected. Please check your internet connection and try again.",
      );
    } on HttpException {
      _resultState = RestaurantReviewErrorState(
        "Server connection failed. Please try again in a moment.",
      );
    } on FormatException {
      _resultState = RestaurantReviewErrorState(
        "Received invalid data from the server. Please refresh or try again later.",
      );
    } on TimeoutException {
      _resultState = RestaurantReviewErrorState(
        "Request timed out. Please try again later."
      );
    } catch (e) {
      _resultState = RestaurantReviewErrorState(
        "Something went wrong. Please try again after some time.",
      );
    } finally {
      notifyListeners();
    }
  }
}
