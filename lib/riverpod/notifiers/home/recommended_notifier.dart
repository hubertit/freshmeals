import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/meal_model.dart';
import '../../../constants/_api_utls.dart';

class RecomendedNotifier extends StateNotifier<RecommendedState> {
  RecomendedNotifier() : super(RecommendedState.initial());

  final Dio _dio = Dio();

  /// Fetch instant recommended meals
  Future<void> fetchInstantRecommended(BuildContext context, String token) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}meals/recommended?token=$token&category=instant',
      );

      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = state.copyWith(
          instantRecommendations: myList.map((json) => Meal.fromJson(json)).toList(),
          isLoading: false,
        );
        print("_________ Instant Recommended _________");
        print(state.instantRecommendations);
      } else {
        throw Exception('Failed to fetch instant meals: ${response.statusMessage}');
      }
    } catch (e) {
      print("Error fetching instant meals: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Fetch non-instant recommended meals
  Future<void> fetchNonInstantRecommended(BuildContext context, String token) async {
    try {
      state = state.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}meals/recommended?token=$token&category=non-instant',
      );

      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = state.copyWith(
          nonInstantRecommendations: myList.map((json) => Meal.fromJson(json)).toList(),
          isLoading: false,
        );
        print("_________ Non-Instant Recommended _________");
        print(state.nonInstantRecommendations);
      } else {
        throw Exception('Failed to fetch non-instant meals: ${response.statusMessage}');
      }
    } catch (e) {
      print("Error fetching non-instant meals: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class RecommendedState {
  final List<Meal> instantRecommendations;
  final List<Meal> nonInstantRecommendations;
  final bool isLoading;

  RecommendedState({
    required this.instantRecommendations,
    required this.nonInstantRecommendations,
    required this.isLoading,
  });

  factory RecommendedState.initial() => RecommendedState(
    instantRecommendations: [],
    nonInstantRecommendations: [],
    isLoading: false,
  );

  RecommendedState copyWith({
    List<Meal>? instantRecommendations,
    List<Meal>? nonInstantRecommendations,
    bool? isLoading,
  }) {
    return RecommendedState(
      instantRecommendations: instantRecommendations ?? this.instantRecommendations,
      nonInstantRecommendations: nonInstantRecommendations ?? this.nonInstantRecommendations,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
