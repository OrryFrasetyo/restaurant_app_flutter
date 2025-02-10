import 'package:flutter/material.dart'; 

class RestaurantDescriptionProvider extends ChangeNotifier {
  bool _isExpanded = true;

  bool get isExpanded => _isExpanded;

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }
}