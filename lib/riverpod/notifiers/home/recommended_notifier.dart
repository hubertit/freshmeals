import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/meal_model.dart';
import '../../../constants/_api_utls.dart';
import '../../../models/general/active_subscription.dart';
class RecomendedNotifier extends StateNotifier<RecommendedState> {
  RecomendedNotifier() : super(RecommendedState.initial());

  final Dio _dio = Dio();

  /// Fetch subscription plans from the server.
  Future<void> subscriptions(BuildContext context, String token) async {
    try {
      state = state!.copyWith(isLoading: true);
      final response = await _dio.get(
        '${baseUrl}meals/recommended?token=$token',
      );
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = RecommendedState(
          recomendations:
          myList.map((json) => Meal.fromJson(json)).toList(),
          isLoading: false,
        );
        print("_________ Recommended_________");
        print(state);
      } else {
        throw Exception(
            'Failed to fetch subscription plans: ${response.statusMessage}');
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

class RecommendedState {
  final List<Meal> recomendations;
  final bool isLoading;

  RecommendedState({
    required this.recomendations,
    required this.isLoading,
  });

  factory RecommendedState.initial() => RecommendedState(
      recomendations: [], isLoading: false);

  RecommendedState copyWith({
    List<Meal>? subscriptions,
    ActiveSubscription? activeSubscription,
    bool? isLoading,
  }) {
    return RecommendedState(
      recomendations: recomendations ?? this.recomendations,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
