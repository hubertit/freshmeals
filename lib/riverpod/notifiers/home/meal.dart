import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/home/meal_model.dart';

class MealsNotifier extends StateNotifier<MealsState> {
  MealsNotifier() : super(MealsState.initial());

  final Dio _dio = Dio();

  Future<void> fetchMeals(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.get('${baseUrl}home/');

      if (response.statusCode == 200) {
        final data = response.data['data'];
        print(data);
        final mealsData = MealsData.fromJson(data);

        state = state.copyWith(mealsData: mealsData, isLoading: false);
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class MealsState {
  final MealsData? mealsData;
  final bool isLoading;

  MealsState({this.mealsData, required this.isLoading});

  factory MealsState.initial() => MealsState(mealsData: null, isLoading: false);

  MealsState copyWith({MealsData? mealsData, bool? isLoading}) {
    return MealsState(
      mealsData: mealsData ?? this.mealsData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
