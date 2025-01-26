import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/meal_model.dart';
import 'package:freshmeals/riverpod/providers/home.dart';

import '../../../constants/_api_utls.dart';

class SearchedProductsNotifier extends StateNotifier<List<Meal>> {
  SearchedProductsNotifier() : super([]);
  final Dio _dio = Dio();
  // final String baseUrl = 'http://app.ihuzo.rw/api';

  Future<List<Meal>>? searchProducts(
       String query) async {
    // ref.read(isLoadingProvider.notifier).state = true;
    try {
      // var store = ref.watch(homeMealsDataProvider)!.mealsData!.dinner;
      final response = await _dio.get('${baseUrl}meals/search?q=${query.isEmpty?'a':query}');
      // print("For tech");
      if (response.statusCode == 200) {
        final List<dynamic> myList = response.data['data'];

        state = myList.map((json) => Meal.fromJson(json)).toList();
        return state;
      } else {
        throw Exception('Failed to Search meals ');
      }
    } catch (e) {
      return [];
    } finally {}
  }
}
