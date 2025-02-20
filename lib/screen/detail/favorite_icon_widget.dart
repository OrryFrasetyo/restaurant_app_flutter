import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:restaurant_app/provider/detail/favorite_icon_provider.dart';
import 'package:restaurant_app/provider/favorite/local_database_provider.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';

class FavoriteIconWidget extends StatefulWidget {
  final RestaurantDetail restaurant;

  const FavoriteIconWidget({
    super.key,
    required this.restaurant,
  });

  @override
  State<FavoriteIconWidget> createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  @override
  void initState() {
    final localDatabaseProvider = context.read<LocalDatabaseProvider>();
    final favoriteIconProvider = context.read<FavoriteIconProvider>();

    Future.microtask(() async {
      await localDatabaseProvider.loadRestaurantById(widget.restaurant.id);
      final value =
          localDatabaseProvider.checkItemFavorite(widget.restaurant.id);

      favoriteIconProvider.isFavorited = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final localDatabaseProvider = context.read<LocalDatabaseProvider>();
        final favoriteIconProvider = context.read<FavoriteIconProvider>();
        final isFavorited = favoriteIconProvider.isFavorited;

        if (!isFavorited) {
          await localDatabaseProvider.saveRestaurant(widget.restaurant);
        } else {
          await localDatabaseProvider
              .removeRestaurantById(widget.restaurant.id);
        }
        favoriteIconProvider.isFavorited = !isFavorited;
        localDatabaseProvider.loadAllRestaurant();
      },
      icon: Icon(
        context.watch<FavoriteIconProvider>().isFavorited
            ? Icons.favorite
            : Icons.favorite_outline,
        color: RestaurantColors.locationIcon.color,
        size: 28,
      ),
    );
  }
}
