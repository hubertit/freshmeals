import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/home/calories.dart';

class CalorieNotifier extends StateNotifier<CalorieState> {
  CalorieNotifier() : super(CalorieState.initial());

  final Dio _dio = Dio();

  Future<void> fetchCalorieData(BuildContext context, String token) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}tracker/calories',
        data: {"token": token},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final calorieData = CalorieData.fromJson(data);
        state = state.copyWith(calorieData: calorieData, isLoading: false);
      } else {
        throw Exception('Failed: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to track calories ')),
      );
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setCalorieTarget(
      BuildContext context, String token, double target) async {
    try {
      state = state.copyWith(isLoading: true);

      final response = await _dio.post(
        '${baseUrl}tracker/set_target',
        data: {
          "token": token,
          "calorie_target": target,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Calorie target updated successfully.')),
        );

        // Call fetchCalorieData() to update the state after setting the target
        await fetchCalorieData(context, token);
      } else {
        throw Exception('Failed to set target: ${response.statusMessage}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed')),
      );
    } finally {
      state = state.copyWith(isLoading: false);
      context.pop();
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
