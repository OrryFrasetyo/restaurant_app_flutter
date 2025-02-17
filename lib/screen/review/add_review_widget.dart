import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/review/add_review_section_provider.dart';
import 'package:restaurant_app/provider/review/restaurant_add_review_provider.dart';
import 'package:restaurant_app/screen/review/custom_text_field.dart';
import 'package:restaurant_app/screen/loading/loading_state_widget.dart';
import 'package:restaurant_app/static/restaurant_review_result_state.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

class AddReviewWidget extends StatefulWidget {
  final String restaurantId;

  const AddReviewWidget({
    super.key,
    required this.restaurantId,
  });

  @override
  State<AddReviewWidget> createState() => _AddReviewWidgetState();
}

class _AddReviewWidgetState extends State<AddReviewWidget> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _sendReview(BuildContext context) {
    final name = _nameController.text.trim();
    final review = _reviewController.text.trim();

    if (name.isEmpty || review.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Name and Review can't be empty")));
      return;
    }

    final reviewProvider = context.read<RestaurantAddReviewProvider>();
    final sectionProvider = context.read<AddReviewSectionProvider>();

    sectionProvider.resetState();
    reviewProvider.addRestaurantReview(widget.restaurantId, name, review);
  }

  void _onSuccess(BuildContext context) {
    final sectionProvider = context.read<AddReviewSectionProvider>();

    if (!sectionProvider.isDetailUpdated) {
      sectionProvider.setSuccessMessage("Successfully added a review");
      _nameController.clear();
      _reviewController.clear();

      context
          .read<RestaurantDetailProvider>()
          .fetchRestaurantDetail(widget.restaurantId);
      sectionProvider.markDetailUpdated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AddReviewSectionProvider(),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Consumer<AddReviewSectionProvider>(
            builder: (context, value, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Send Review",
                    style: RestaurantTextStyles.titleMedium,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              if (value.successMessage != null)
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Text(
                    value.successMessage!,
                    style: RestaurantTextStyles.titleSmall
                        .copyWith(color: RestaurantColors.primary.color),
                  ),
                ),
              CustomTextField(
                controller: _nameController,
                labelText: "Name",
              ),
              SizedBox(
                height: 12.0,
              ),
              CustomTextField(
                controller: _reviewController,
                labelText: "Review",
                maxLines: 3,
              ),
              SizedBox(
                height: 16.0,
              ),
              Consumer<RestaurantAddReviewProvider>(
                builder: (context, provider, child) {
                  if (provider.resultState is RestaurantReviewLoadingState) {
                    return Center(
                      child: LoadingStateWidget(),
                    );
                  }

                  if (provider.resultState is RestaurantReviewErrorState) {
                    final error =
                        (provider.resultState as RestaurantReviewErrorState)
                            .error;
                    return Text(
                      error,
                      style: RestaurantTextStyles.titleSmall
                          .copyWith(color: RestaurantColors.error.color),
                    );
                  }

                  if (provider.resultState is RestaurantReviewLoadedState &&
                      !value.isDetailUpdated) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        _onSuccess(context);
                      }
                    });
                  }

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () => _sendReview(context),
                    child: Text("Send Review"),
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
