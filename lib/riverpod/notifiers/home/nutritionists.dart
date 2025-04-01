import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/nutritionist.dart';

import '../../../constants/_api_utls.dart';

class NutritionistNotifier extends StateNotifier<NutritionistState?> {
  NutritionistNotifier() : super(NutritionistState.initial());

  final Dio _dio = Dio();

  Future<void> fetchNutritionists(BuildContext context) async {
    try {
      state = state!.copyWith(isLoading: true);

      final response = await _dio.get(
        '${baseUrl}appointments/nutritionists',
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        state = NutritionistState(
          nutritionists:
              data.map((json) => Nutritionist.fromJson(json)).toList(),
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

class NutritionistState {
  final List<Nutritionist> nutritionists;
  final bool isLoading;

  NutritionistState({
    required this.nutritionists,
    required this.isLoading,
  });

  factory NutritionistState.initial() {
    return NutritionistState(
      nutritionists: [],
      isLoading: false,
    );
  }

  NutritionistState copyWith({
    List<Nutritionist>? appointments,
    bool? isLoading,
  }) {
    return NutritionistState(
      nutritionists: appointments ?? this.nutritionists,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
