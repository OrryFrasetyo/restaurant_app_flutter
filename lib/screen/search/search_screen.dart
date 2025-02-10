import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/search/restaurant_search_provider.dart';
import 'package:restaurant_app/screen/search/search_app_bar_widget.dart';
import 'package:restaurant_app/screen/search/search_bar_widget.dart';
import 'package:restaurant_app/screen/search/search_result_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBarWidget(),
      body: Column(
        children: [
          SearchBarWidget(
            searchController: _searchController,
            onSearch: (query) {
              if (query.isNotEmpty) {
                context
                    .read<RestaurantSearchProvider>()
                    .fetchRestaurantQuery(query);
              }
            },
          ),
          Expanded(child: SearchResultWidget()),
        ],
      ),
    );
  }
}
