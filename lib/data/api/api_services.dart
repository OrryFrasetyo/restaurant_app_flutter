import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/data/model/restaurant_review_response.dart';
import 'package:restaurant_app/data/model/restaurant_search_response.dart';

  class ApiServices {
    static const String _baseUrl = "https://restaurant-api.dicoding.dev/";

    Future<RestaurantListResponse> getRestaurantList() async {
      final response = await http.get(Uri.parse("$_baseUrl/list"));

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load list of restaurant");
      }
    }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse("$_baseUrl/detail/$id"));

    if (response.statusCode == 200) {
      return RestaurantDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load detail of restaurant");
    }
  }

  Future<RestaurantSearchResponse> getRestaurantByQuery(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?q=$query"));

    if (response.statusCode == 200) {
      return RestaurantSearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load search of restaurant");
    }
  }

  Future<RestaurantReviewResponse> postRestaurantReview(
    String id,
    String name,
    String review,
  ) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/review"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "id": id,
        "name": name,
        "review": review,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return RestaurantReviewResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to add new review");
    }
  }
}
