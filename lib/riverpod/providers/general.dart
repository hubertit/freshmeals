import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/riverpod/notifiers/general/health_goals.dart';
import 'package:freshmeals/riverpod/notifiers/general/prefferances.dart';
import 'package:freshmeals/riverpod/notifiers/general/subscription.dart';
import 'package:freshmeals/riverpod/notifiers/home/meal_type.dart';
import 'package:freshmeals/riverpod/notifiers/home/meals_category.dart';


final healthGoalsProvider =
StateNotifierProvider<HealthGoalsNotifier, HealthGoalState?>((ref) {
  return HealthGoalsNotifier();
});
final subscriptionsProvider =
StateNotifierProvider<SubscriptionNotifier, SubscriptionState?>((ref) {
  return SubscriptionNotifier();
});
final preferencesProvider =
StateNotifierProvider<PreferencesNotifier, PreferencesState?>((ref) {
  return PreferencesNotifier();
});
final mealCategoriesProvider =
StateNotifierProvider<MealsCategoryNotifier, MealsCategoryState?>((ref) {
  return MealsCategoryNotifier();
});
final mealTypesProvider =
StateNotifierProvider<MealsTypeNotifier, MealsTypeState?>((ref) {
  return MealsTypeNotifier();
});

final firstTimeProvider = StateProvider<bool>((ref) => false);
