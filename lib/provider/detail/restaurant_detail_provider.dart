import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/api/api_services.dart';
import 'package:restaurant_app/static/restaurant_detail_result_state.dart';

class RestaurantDetailProvider extends ChangeNotifier {
  final ApiServices _apiServices;

  RestaurantDetailProvider(
    this._apiServices,
  );

  RestaurantDetailResultState _resultState = RestaurantDetailNoneState();

  RestaurantDetailResultState get resultState => _resultState;

  Future<void> fetchRestaurantDetail(String id) async {
    try {
      _resultState = RestaurantDetailLoadingState();
      notifyListeners();

      await Future.delayed(const Duration(seconds: 1));

      final result = await _apiServices.getRestaurantDetail(id);

      if (result.error) {
        _resultState = RestaurantDetailErrorState(
          "Failed to load detail data, Please try again.",
        );
        notifyListeners();
      } else {
        _resultState = RestaurantDetailLoadedState(result.restaurant);
        notifyListeners();
      }
    } on SocketException {
      _resultState = RestaurantDetailErrorState(
        "Network issue detected. Please check your internet connection and try again.",
      );
    } on HttpException {
      _resultState = RestaurantDetailErrorState(
        "Server connection failed. Please try again in a moment.",
      );
    } on FormatException {
      _resultState = RestaurantDetailErrorState(
        "Received invalid data from the server. Please refresh or try again later.",
      );
    } on TimeoutException {
      _resultState = RestaurantDetailErrorState(
          "Request timed out. Please try again later.");
    } catch (e) {
      _resultState = RestaurantDetailErrorState(
        "Something went wrong. Please try again after some time.",
      );
    } finally {
      notifyListeners();
    }
  }
}
