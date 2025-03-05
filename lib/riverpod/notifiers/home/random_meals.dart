import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/_api_utls.dart';
import '../../../models/home/meal_model.dart';

class RandomMealsNotifier extends StateNotifier<RandomMealsState?> {
  RandomMealsNotifier() : super(RandomMealsState.initial());

  final Dio _dio = Dio();

  Future<void> fetchMeals(BuildContext context) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}meals/random?limit=5',
      );
      // print(response.data['data']);
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = RandomMealsState(
          mealCategories: myList.map((json) => Meal.fromJson(json)).toList(),
          isLoading: false,
        );
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }
  Future<void> mealByTypes(BuildContext context, type) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}meals/type?type=${type}&limit=1',
      );
      // print(response.data['data']);
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = RandomMealsState(
          mealCategories: myList.map((json) => Meal.fromJson(json)).toList(),
          isLoading: false,
        );
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }
}

class RandomMealsState {
  final List<Meal> mealCategories;
  final bool isLoading;

  RandomMealsState({required this.mealCategories, required this.isLoading});

  factory RandomMealsState.initial() =>
      RandomMealsState(mealCategories: [], isLoading: false);

  RandomMealsState copyWith({List<Meal>? mealCategories, bool? isLoading}) {
    return RandomMealsState(
      mealCategories: mealCategories ?? this.mealCategories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
