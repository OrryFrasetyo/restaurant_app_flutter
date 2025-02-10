import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/static/restaurant_list_result_state.dart';

class RestaurantListProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  RestaurantListProvider(
    this._apiServices,
  );

  RestaurantListResultState _resultState = RestaurantListNoneState();

  RestaurantListResultState get resultState => _resultState;

  Future<void> fetchRestaurantList() async {
    try {
      _resultState = RestaurantListLoadingState();
      notifyListeners();

      final result = await _apiServices.getRestaurantList();

      if (result.error) {
        _resultState = RestaurantListErrorState(
          "Failed to load restaurant data, Please try again.",
        );
      } else {
        _resultState = RestaurantListLoadedState(result.restaurants);
      }
    } on SocketException {
      _resultState = RestaurantListErrorState(
        "Network issue detected. Please check your internet connection and try again.",
      );
    } on HttpException {
      _resultState = RestaurantListErrorState(
        "Server connection failed. Please try again in a moment.",
      );
    } on FormatException {
      _resultState = RestaurantListErrorState(
        "Received invalid data from the server. Please refresh or try again later.",
      );
    } on TimeoutException {
      _resultState = RestaurantListErrorState(
          "Request timed out. Please try again later.");
    } catch (e) {
      _resultState = RestaurantListErrorState(
        "Something went wrong. Please try again after some time.",
      );
    } finally {
      notifyListeners();
    }
  }
}
