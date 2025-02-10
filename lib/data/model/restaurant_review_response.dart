import "package:restaurant_app/data/model/restaurant_review.dart";

class RestaurantReviewResponse {
  final bool error;
  final String message;
  List<RestaurantReview> customerReviews;

  RestaurantReviewResponse({
    required this.error,
    required this.message,
    required this.customerReviews,
  });

  factory RestaurantReviewResponse.fromJson(Map<String, dynamic> json) =>
      RestaurantReviewResponse(
          error: json["error"],
          message: json["message"],
          customerReviews: json["customerReviews"] != null
              ? List<RestaurantReview>.from(json["customerReviews"]!
                  .map((x) => RestaurantReview.fromJson(x)))
              : <RestaurantReview>[]);
}
