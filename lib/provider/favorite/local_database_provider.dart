import 'package:flutter/widgets.dart';
import 'package:restaurant_app/data/local/local_database_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';

class LocalDatabaseProvider extends ChangeNotifier {
  final LocalDatabaseService _service;

  LocalDatabaseProvider(this._service);

  String _message = "";
  String get message => _message;

  List<RestaurantDetail> _restaurantList = [];  //TODO ini ada null kah?
  List<RestaurantDetail> get restaurantList => _restaurantList; //TODO ini ada null kah?

  RestaurantDetail? _restaurant;
  RestaurantDetail? get restaurant => _restaurant;

  Future<void> saveRestaurant(RestaurantDetail? value) async {
    if (value == null) {
      _message = "Invalid restaurant data";
      notifyListeners();
      return;
    }

    try {
      await _service.insertItem(value);
      await loadAllRestaurant();
      _message = "Restaurant saved successfully";
    } catch (e) {
      _message = "Error saving restaurant: $e";
    }
    notifyListeners();
    //hapus debugnya setelah production
    debugPrint(
        "Current restaurant list: ${_restaurantList.map((e) => e.id).toList()}");
  }

  Future<void> loadAllRestaurant() async {
    try {
      _restaurantList = await _service.getAllItems();
      _message = "All restaurant data has been successfully retrieved";
    } catch (e) {
      _message = "An error occurred while retrieving all restaurant data: $e";
    }
    notifyListeners();
  }

  Future<void> loadRestaurantById(String id) async {
    try {
      _restaurant = await _service.getItemsById(id);
      _message = "Restaurant data has been successfully retrieved";
    } catch (e) {
      _message = "Error retrieving restaurant data: $e";
    }
    notifyListeners();
  }

  Future<void> removeRestaurantById(String id) async {
    try {
      await _service.removeItem(id);
      await loadAllRestaurant();
      _message = "Restaurant data has been successfully removed";
    } catch (e) {
      _message = "Error removing restaurant data: $e";
    }
    notifyListeners();
    debugPrint(
        "Current restaurant list: ${_restaurantList.map((e) => e.id).toList()}");
  }

  bool checkItemFavorite(String id) {
    try {
      return _restaurantList.any((restaurant) => restaurant.id == id);
    } catch (e) {
      debugPrint("Error checking favorite status: $e");
      return false;
    }
  }
}