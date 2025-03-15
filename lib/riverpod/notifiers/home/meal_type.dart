import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/general/preferances_model.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/home/meal_type.dart';
import '../../../models/home/meals_category.dart';


class MealsTypeNotifier extends StateNotifier<MealsTypeState?> {
  MealsTypeNotifier() : super(MealsTypeState.initial());

  final Dio _dio = Dio();

  Future<void> mealTypes(BuildContext context, String type) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}general/meal_types?category=$type',
      );
      // print(response.data['data']);
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = MealsTypeState(
          mealCategories: myList.map((json) => MealType.fromJson(json)).toList(),
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

class MealsTypeState {
  final List<MealType> mealCategories;
  final bool isLoading;

  MealsTypeState({required this.mealCategories, required this.isLoading});

  factory MealsTypeState.initial() =>
      MealsTypeState(mealCategories: [], isLoading: false);

  MealsTypeState copyWith({List<MealType>? mealCategories, bool? isLoading}) {
    return MealsTypeState(
      mealCategories: mealCategories ?? this.mealCategories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
