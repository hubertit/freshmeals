import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../constants/_api_utls.dart';
import '../../../models/general/health_goals.dart';


class HealthGoalsNotifier extends StateNotifier<HealthGoalState?> {
  HealthGoalsNotifier() : super(HealthGoalState.initial());

  final Dio _dio = Dio();

  Future<void> goals(BuildContext context) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}general/health_goals',
        // options: Options(
        //   headers: {
        //     'Content-Type': 'application/json',
        //   },
        // ),
      );
      print(response.data['data']);
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = HealthGoalState(
          goals: myList.map((json) => HealthGoal.fromJson(json)).toList(),
          isLoading: false,
        );

        // Do not throw an exception here, as it disrupts the normal flow
        // throw Exception('Failed to get: ${response.statusMessage}');
      } else {
        throw Exception('Failed to fetch districts: ${response.statusMessage}');
      }
    } catch (e) {
      // Handle error appropriately, e.g., show a snackbar or log the error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      state = state!.copyWith(isLoading: false);
    }
  }

  Future<void> clearSchedules() async {
    state = HealthGoalState(
      goals: [],
      isLoading: false,
    );
  }
}

class HealthGoalState {
  final List<HealthGoal> goals;
  final bool isLoading;

  HealthGoalState({required this.goals, required this.isLoading});

  factory HealthGoalState.initial() =>
      HealthGoalState(goals: [], isLoading: false);

  HealthGoalState copyWith({List<HealthGoal>? orders, bool? isLoading}) {
    return HealthGoalState(
      goals: orders ?? this.goals,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
