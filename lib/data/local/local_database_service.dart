import 'dart:convert';

import 'package:restaurant_app/data/model/restaurant_detail.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabaseService {
  static const String _databaseName = 'restaurant-app.db';
  static const String _tableName = 'restaurant';
  static const int _version = 1;

  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  static Database? _database;

  Future<void> createTables(Database database) async {
    await database.execute(
      """CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        city TEXT,
        address TEXT,
        pictureId TEXT,
        categories TEXT,
        menus TEXT,
        rating REAL,
        customerReviews TEXT
        )
        """,
    );
  }

  Future<Database> _initializeDb() async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      _databaseName,
      version: _version,
      onCreate: (Database database, int version) async {
        await createTables(database);
      },
    );
    return _database!;
  }

  Future<int> insertItem(RestaurantDetail restaurant) async {
    try {
      final db = await _initializeDb();
      final data = {
        "id": restaurant.id,
        "name": restaurant.name,
        "description": restaurant.description,
        "city": restaurant.city,
        "address": restaurant.address,
        "pictureId": restaurant.pictureId,
        "categories": jsonEncode(restaurant.categories
            .map((category) => category.toJson())
            .toList()),
        "menus": jsonEncode(restaurant.menus.toJson()),
        "rating": restaurant.rating,
        "customerReviews": jsonEncode(restaurant.customerReviews
            .map((review) => review.toJson())
            .toList()),
      };
      return await db.insert(
        _tableName,
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception("Failed to insert item: $e");
    }
  }

  Future<List<RestaurantDetail>> getAllItems() async {
    try {
      final db = await _initializeDb();
      final results = await db.query(_tableName);
      return results.map((result) {
        return RestaurantDetail(
          id: result["id"] as String,
          name: result["name"] as String,
          description: result["description"] as String,
          city: result["city"] as String,
          address: result["address"] as String,
          pictureId: result["pictureId"] as String,
          categories: (jsonDecode(result["categories"] as String) as List)
              .map((x) => Category.fromJson(x))
              .toList(),
          menus: Menus.fromJson(jsonDecode(result["menus"] as String)),
          rating: result["rating"] as double,
          customerReviews:
              (jsonDecode(result["customerReviews"] as String) as List)
                  .map((x) => CustomerReview.fromJson(x))
                  .toList(),
        );
      }).toList();
    } catch (e) {
      throw Exception("Failed to fetch items: $e");
    }
  }

  Future<RestaurantDetail> getItemsById(String id) async {
    try {
      final db = await _initializeDb();
      final result = await db.query(_tableName,
          where: "id = ?", whereArgs: [id], limit: 1);
      if (result.isNotEmpty) {
        final item = result.first;
        return RestaurantDetail(
          id: item["id"] as String,
          name: item["name"] as String,
          description: item["description"] as String,
          city: item["city"] as String,
          address: item["address"] as String,
          pictureId: item["pictureId"] as String,
          categories: (jsonDecode(item["categories"] as String) as List)
              .map((x) => Category.fromJson(x))
              .toList(),
          menus: Menus.fromJson(jsonDecode(item["menus"] as String)),
          rating: item["rating"] as double,
          customerReviews:
              (jsonDecode(item["customerReviews"] as String) as List)
                  .map((x) => CustomerReview.fromJson(x))
                  .toList(),
        );
      } else {
        throw Exception("Item not found");
      }
    } catch (e) {
      throw Exception("Failed to fetch item by id: $e");
    }
  }

  Future<String> removeItem(String id) async {
    try {
      final db = await _initializeDb();
      final result = await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
      return result.toString();
    } catch (e) {
      throw Exception("Failed to remove item: $e");
    }
  }
}
