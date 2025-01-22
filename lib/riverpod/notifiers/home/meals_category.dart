import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/general/preferances_model.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/home/meals_category.dart';


class MealsCategoryNotifier extends StateNotifier<MealsCategoryState?> {
  MealsCategoryNotifier() : super(MealsCategoryState.initial());

  final Dio _dio = Dio();

  Future<void> mealCategories(BuildContext context) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}general/meal_categories',
      );
      // print(response.data['data']);
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = MealsCategoryState(
          mealCategories: myList.map((json) => MealsCategory.fromJson(json)).toList(),
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

}

class MealsCategoryState {
  final List<MealsCategory> mealCategories;
  final bool isLoading;

  MealsCategoryState({required this.mealCategories, required this.isLoading});

  factory MealsCategoryState.initial() =>
      MealsCategoryState(mealCategories: [], isLoading: false);

  MealsCategoryState copyWith({List<MealsCategory>? mealCategories, bool? isLoading}) {
    return MealsCategoryState(
      mealCategories: mealCategories ?? this.mealCategories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
