import 'package:flutter/material.dart';

enum RestaurantColors {
  primary("Primary", Color.fromARGB(255, 145, 78, 2)),
  secondary("Secondary", Color.fromARGB(255, 247, 134, 28)),
  background("Background", Color(0xFFF6F6F6)),
  surface("Surface", Colors.white),
  locationIcon("LocationIcon", Colors.red),
  ratingIcon("RatingIcon", Colors.yellow),
  error("Error", Color.fromARGB(255, 202, 1, 38)),
  onAlert("OnAlert", Colors.grey),
  onPrimary("OnPrimary", Colors.white),
  onSecondary("OnSecondary", Colors.black);

  const RestaurantColors(this.name, this.color);

  final String name;
  final Color color;
}
