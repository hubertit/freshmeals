import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/meal_model.dart';
import '../../../constants/_api_utls.dart';

class PreOrderNotifier extends StateNotifier<PreOrderState> {
  PreOrderNotifier() : super(PreOrderState.initial());

  final Dio _dio = Dio();

  /// Fetch all pre-ordered meals (no category filtering)
  Future<void> fetchPreOrderMeals(BuildContext context, String token) async {
    await _fetchMealsByCategory(context, token, null, isPreOrder: true);
  }

  Future<void> fetchBreakfastMeals(BuildContext context, String token) async {
    await _fetchMealsByCategory(context, token, "16");
  }

  Future<void> fetchLunchDinnerMeals(BuildContext context, String token) async {
    await _fetchMealsByCategory(context, token, "17");
  }

  Future<void> fetchSnackMeals(BuildContext context, String token) async {
    await _fetchMealsByCategory(context, token, "18");
  }

  Future<void> fetchDessertMeals(BuildContext context, String token) async {
    await _fetchMealsByCategory(context, token, "19");
  }

  Future<void> _fetchMealsByCategory(
      BuildContext context,
      String token,
      String? typeId, {
        bool isPreOrder = false,
      }) async {
    try {
      state = state.copyWith(isLoading: true);

      final queryParameters = {
        'token': token,
        // if (isPreOrder)
          'category': 'non-instant',
        if (typeId != null) 'type_id': typeId,
      };

      final response = await _dio.get(
        '${baseUrl}meals/preOrder',
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];
        final mealsList = myList.map((json) => Meal.fromJson(json)).toList();

        if (isPreOrder && typeId == null) {
          state = state.copyWith(preOrderMeals: mealsList);
        } else if (typeId == "16") {
          state = state.copyWith(breakfast: mealsList);
        } else if (typeId == "17") {
          state = state.copyWith(lunchDinner: mealsList);
        } else if (typeId == "18") {
          state = state.copyWith(snacks: mealsList);
        } else if (typeId == "19") {
          state = state.copyWith(dessert: mealsList);
        } else {
          state = state.copyWith(meals: mealsList);
        }

        print("Fetched meals for typeId=$typeId: ${mealsList.length}");
      } else {
        throw Exception('Failed to fetch meals: ${response.statusMessage}');
      }
    } catch (e) {
      print("Error fetching meals: $e");
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

class PreOrderState {
  final List<Meal> preOrderMeals;
  final List<Meal> meals;
  final List<Meal> breakfast;
  final List<Meal> lunchDinner;
  final List<Meal> snacks;
  final List<Meal> dessert;
  final bool isLoading;

  PreOrderState({
    required this.preOrderMeals,
    required this.meals,
    required this.breakfast,
    required this.lunchDinner,
    required this.snacks,
    required this.dessert,
    required this.isLoading,
  });

  factory PreOrderState.initial() => PreOrderState(
    preOrderMeals: [],
    meals: [],
    breakfast: [],
    lunchDinner: [],
    snacks: [],
    dessert: [],
    isLoading: false,
  );

  PreOrderState copyWith({
    List<Meal>? preOrderMeals,
    List<Meal>? meals,
    List<Meal>? breakfast,
    List<Meal>? lunchDinner,
    List<Meal>? snacks,
    List<Meal>? dessert,
    bool? isLoading,
  }) {
    return PreOrderState(
      preOrderMeals: preOrderMeals ?? this.preOrderMeals,
      meals: meals ?? this.meals,
      breakfast: breakfast ?? this.breakfast,
      lunchDinner: lunchDinner ?? this.lunchDinner,
      snacks: snacks ?? this.snacks,
      dessert: dessert ?? this.dessert,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
