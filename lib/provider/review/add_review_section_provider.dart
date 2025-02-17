import 'package:flutter/material.dart';

class AddReviewSectionProvider extends ChangeNotifier {
  String? successMessage;
  bool isDetailUpdated = false;

  void setSuccessMessage(String message) {
    successMessage = message;
    notifyListeners();
  }

  void markDetailUpdated() {
    isDetailUpdated = true;
    notifyListeners();
  }

  void resetState() {
    successMessage = null;
    isDetailUpdated = false;
    notifyListeners();
  }
}
