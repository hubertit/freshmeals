import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/meal_model.dart';
import 'package:freshmeals/riverpod/notifiers/count.dart';
import 'package:freshmeals/riverpod/notifiers/home/apointments.dart';
import 'package:freshmeals/riverpod/notifiers/home/meal_details.dart';
import 'package:freshmeals/riverpod/notifiers/home/my_appointment.dart';

import '../notifiers/cart_notifier.dart';
import '../notifiers/home/meal.dart';
import '../notifiers/home/search_notifier.dart';

final homeMealsDataProvider =
StateNotifierProvider<MealsNotifier, MealsState?>((ref) {
  return MealsNotifier();
});

final mealDetailsDataProvider =
StateNotifierProvider<MealDetailsNotifier, MealDetailsState?>((ref) {
  return MealDetailsNotifier();
});

final searchedProductsProvider =
StateNotifierProvider<SearchedProductsNotifier, List<Meal>>((ref) {
  return SearchedProductsNotifier();
});

final cartProvider =
StateNotifierProvider<CartNotifier, CartState?>((ref) {
  return CartNotifier();
});

final appointmentsProvider =
StateNotifierProvider<SlotsNotifier, SlotsState?>((ref) {
  return SlotsNotifier();
});
final myAppointmentsProvider =
StateNotifierProvider<AppointmentNotifier, AppointmentState?>((ref) {
  return AppointmentNotifier();
});
final countProvider =
StateNotifierProvider<CountNotifier, CountState?>((ref) {
  return CountNotifier();
});