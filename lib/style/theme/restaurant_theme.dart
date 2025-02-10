import 'package:flutter/material.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';

class RestaurantTheme {
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: RestaurantTextStyles.displayLarge,
      displayMedium: RestaurantTextStyles.displayMedium,
      displaySmall: RestaurantTextStyles.displaySmall,
      headlineLarge: RestaurantTextStyles.headlineLarge,
      headlineMedium: RestaurantTextStyles.headlineMedium,
      headlineSmall: RestaurantTextStyles.headlineSmall,
      titleLarge: RestaurantTextStyles.titleLarge,
      titleMedium: RestaurantTextStyles.titleMedium,
      titleSmall: RestaurantTextStyles.titleSmall,
      labelLarge: RestaurantTextStyles.labelLarge,
      labelMedium: RestaurantTextStyles.labelMedium,
      labelSmall: RestaurantTextStyles.labelSmall,
    );
  }

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      titleTextStyle: _textTheme.titleLarge?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
      backgroundColor: RestaurantColors.primary.color,
      foregroundColor: RestaurantColors.onPrimary.color,
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: RestaurantColors.primary.color,
        onPrimary: RestaurantColors.onPrimary.color,
        surface: RestaurantColors.surface.color,
        onSurface: RestaurantColors.onSecondary.color,
      ),
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        primary: RestaurantColors.primary.color,
        onPrimary: RestaurantColors.onPrimary.color,
        surface: Colors.grey[850]!,
        onSurface: Colors.white,
        onSecondary: Colors.white,
      ),
      brightness: Brightness.dark,
      textTheme: _textTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      useMaterial3: true,
      appBarTheme: _appBarTheme.copyWith(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
    );
  }
}
