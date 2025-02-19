import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/home/meal_details.dart';
import '../../../models/home/meal_model.dart';

class MealDetailsNotifier extends StateNotifier<MealDetailsState> {
  MealDetailsNotifier() : super(MealDetailsState.initial());

  final Dio _dio = Dio();

  Future<void> fetchMealDetails(BuildContext context, int mealId) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio
          .get('${baseUrl}meals/details?meal_id=$mealId');
      // print(response);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        print(data);
        final mealsData = MealDetailsModel.fromJson(data);
        state = state.copyWith(mealsData: mealsData, isLoading: false);
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error: $e')),
      // );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class MealDetailsState {
  final MealDetailsModel? mealsData;
  final bool isLoading;

  MealDetailsState({this.mealsData, required this.isLoading});

  factory MealDetailsState.initial() =>
      MealDetailsState(mealsData: null, isLoading: false);

  MealDetailsState copyWith({MealDetailsModel? mealsData, bool? isLoading}) {
    return MealDetailsState(
      mealsData: mealsData ?? this.mealsData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
