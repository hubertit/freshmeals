import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/home/calories.dart';

class CalorieNotifier extends StateNotifier<CalorieState> {
  CalorieNotifier() : super(CalorieState.initial());

  final Dio _dio = Dio();

  Future<void> fetchCalorieData(BuildContext context, String token) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.post('${baseUrl}tracker/calories',
        data: {"token": token},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),);

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);

        final calorieData = CalorieData.fromJson(data);
        print(calorieData);

        state = state.copyWith(calorieData: calorieData, isLoading: false);
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

class CalorieState {
  final CalorieData? calorieData;
  final bool isLoading;

  CalorieState({this.calorieData, required this.isLoading});

  factory CalorieState.initial() =>
      CalorieState(calorieData: null, isLoading: false);

  CalorieState copyWith({
    CalorieData? calorieData,
    bool? isLoading,
  }) {
    return CalorieState(
      calorieData: calorieData ?? this.calorieData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
