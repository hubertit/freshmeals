import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../constants/_api_utls.dart';
import '../../../models/home/meal_model.dart';

class MealByTypeNotifier extends StateNotifier<MealsByTypeState?> {
  MealByTypeNotifier() : super(MealsByTypeState.initial());

  final Dio _dio = Dio();

  Future<void> mealByTypes(BuildContext context, type, token) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        type == "0"
            ? '${baseUrl}meals/recommended?token=$token'
            : type == "13"
                ? "${baseUrl}meals/specials"
                : '${baseUrl}meals/type?type=$type&limit=1',
      );
      print(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];
        print(myList);
        state = MealsByTypeState(
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

class MealsByTypeState {
  final List<Meal> mealCategories;
  final bool isLoading;

  MealsByTypeState({required this.mealCategories, required this.isLoading});

  factory MealsByTypeState.initial() =>
      MealsByTypeState(mealCategories: [], isLoading: false);

  MealsByTypeState copyWith({List<Meal>? mealCategories, bool? isLoading}) {
    return MealsByTypeState(
      mealCategories: mealCategories ?? this.mealCategories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
