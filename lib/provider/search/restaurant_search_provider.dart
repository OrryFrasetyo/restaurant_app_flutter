import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/static/restaurant_search_result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  RestaurantSearchProvider(
    this._apiServices,
  );

  RestaurantSearchResultState _resultState = RestaurantSearchNoneState();

  RestaurantSearchResultState get resultState => _resultState;

  Future<void> fetchRestaurantQuery(String query) async {
    try {
      _resultState = RestaurantSearchLoadingState();
      notifyListeners();

      await Future.delayed(Duration(seconds: 1));

      final result = await _apiServices.getRestaurantByQuery(query);

      if (result.error) {
        _resultState = RestaurantSearchErrorState(
          "Failed to load restaurant data, Please try again.",
        );
        notifyListeners();
      } else {
        _resultState = RestaurantSearchLoadedState(result.restaurants);
        notifyListeners();
      }
    } on SocketException {
      _resultState = RestaurantSearchErrorState(
        "Network issue detected. Please check your internet connection and try again.",
      );
    } on HttpException {
      _resultState = RestaurantSearchErrorState(
        "Server connection failed. Please try again in a moment.",
      );
    } on FormatException {
      _resultState = RestaurantSearchErrorState(
        "Received invalid data from the server. Please refresh or try again later.",
      );
    } on TimeoutException {
      _resultState = RestaurantSearchErrorState(
          "Request timed out. Please try again later.");
    } catch (e) {
      _resultState = RestaurantSearchErrorState(
        "Something went wrong. Please try again after some time.",
      );
    } finally {
      notifyListeners();
    }
  }
}
