import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/_api_utls.dart';
import '../../../models/home/meal_model.dart';

class FavoriteMealsNotifier extends StateNotifier<FavoriteMealsState?> {
  FavoriteMealsNotifier() : super(FavoriteMealsState.initial());

  final Dio _dio = Dio();

  /// Fetch favorite meals
  Future<void> fetchFavorites(BuildContext context, String token) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.post(
        '${baseUrl}favorites/items',
        data: {"token": token},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = FavoriteMealsState(
          favoriteMeals: myList.map((json) => Meal.fromJson(json)).toList(),
          isLoading: false,
        );
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  /// Add meal to favorites
  Future<void> addFavorite(
      BuildContext context, String token, int mealId) async {
    try {
      final response = await _dio.post(
        '${baseUrl}favorites/add',
        data: {"meal_id": mealId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        fetchFavorites(context, token); // Refresh favorites
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meal added to favorites!')),
        );
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  /// Remove meal from favorites
  Future<void> removeFavorite(
      BuildContext context, String token, int mealId) async {
    try {
      final response = await _dio.delete(
        '${baseUrl}favorites/remove',
        data: {"meal_id": mealId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        fetchFavorites(context, token); // Refresh favorites
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meal removed from favorites!')),
        );
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

class FavoriteMealsState {
  final List<Meal>? favoriteMeals;
  final bool isLoading;

  FavoriteMealsState({
    this.favoriteMeals,
    required this.isLoading,
  });

  factory FavoriteMealsState.initial() => FavoriteMealsState(
        favoriteMeals: [],
        isLoading: false,
      );

  FavoriteMealsState copyWith({
    List<Meal>? favoriteMeals,
    bool? isLoading,
  }) {
    return FavoriteMealsState(
      favoriteMeals: favoriteMeals ?? this.favoriteMeals,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
