import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/meal_model.dart';
import '../../../constants/_api_utls.dart';

class PreOrderNotifier extends StateNotifier<PreOrderState> {
  PreOrderNotifier() : super(PreOrderState.initial());

  final Dio _dio = Dio();

  /// Fetch pre-ordered meals
  Future<void> fetchPreOrderMeals(BuildContext context, String token) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}meals/preOrder?token=$token',
      );

      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = state.copyWith(
          preOrderMeals: myList.map((json) => Meal.fromJson(json)).toList(),
          isLoading: false,
        );
        print("_________ Pre-Ordered Meals _________");
        print(state.preOrderMeals);
      } else {
        throw Exception('Failed to fetch pre-ordered meals: ${response.statusMessage}');
      }
    } catch (e) {
      print("Error fetching pre-ordered meals: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class PreOrderState {
  final List<Meal> preOrderMeals;
  final bool isLoading;

  PreOrderState({
    required this.preOrderMeals,
    required this.isLoading,
  });

  factory PreOrderState.initial() => PreOrderState(
    preOrderMeals: [],
    isLoading: false,
  );

  PreOrderState copyWith({
    List<Meal>? preOrderMeals,
    bool? isLoading,
  }) {
    return PreOrderState(
      preOrderMeals: preOrderMeals ?? this.preOrderMeals,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
