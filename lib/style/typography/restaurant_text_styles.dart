import 'package:flutter/widgets.dart';

class RestaurantTextStyles {
  static const TextStyle _commonStyle = TextStyle(
    fontFamily: "Quicksand",
  );

  static TextStyle displayLarge = _commonStyle.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    height: 1.11,
    letterSpacing: -2,
  );

  static TextStyle displayMedium = _commonStyle.copyWith(
    fontSize: 45,
    fontWeight: FontWeight.w600,
    height: 1.17,
    letterSpacing: -1,
  );

  static TextStyle displaySmall = _commonStyle.copyWith(
    fontSize: 36,
    fontWeight: FontWeight.w500,
    height: 1.25,
    letterSpacing: -1,
  );

  static TextStyle headlineLarge = _commonStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.31,
    letterSpacing: -0.5,
  );

  static TextStyle headlineMedium = _commonStyle.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.29,
    letterSpacing: -0.25,
  );

  static TextStyle headlineSmall = _commonStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 1.33,
  );

  static TextStyle titleLarge = _commonStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.27,
  );

  static TextStyle titleMedium = _commonStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
  );

  static TextStyle titleSmall = _commonStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.43,
  );

  static TextStyle bodyLarge = _commonStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle bodyMedium = _commonStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.43,
  );

  static TextStyle bodySmall = _commonStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.33,
  );

  static TextStyle labelLarge = _commonStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 1.43,
  );

  static TextStyle labelMedium = _commonStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.33,
  );

  static TextStyle labelSmall = _commonStyle.copyWith(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.27,
  );

  
}