import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freshmeals/models/home/meal_model.dart';
import 'package:freshmeals/riverpod/notifiers/accoint_info_notifier.dart';
import 'package:freshmeals/riverpod/notifiers/count.dart';
import 'package:freshmeals/riverpod/notifiers/home/address_notifier.dart';
import 'package:freshmeals/riverpod/notifiers/home/apointments.dart';
import 'package:freshmeals/riverpod/notifiers/home/defaul_address.dart';
import 'package:freshmeals/riverpod/notifiers/home/favorite_meals.dart';
import 'package:freshmeals/riverpod/notifiers/home/meal_details.dart';
import 'package:freshmeals/riverpod/notifiers/home/my_appointment.dart';
import 'package:freshmeals/riverpod/notifiers/home/order_details_notifier.dart';
import 'package:freshmeals/riverpod/notifiers/home/random_meals.dart';

import '../notifiers/cart_notifier.dart';
import '../notifiers/home/meal.dart';
import '../notifiers/home/order_notifier.dart';
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

final cartProvider = StateNotifierProvider<CartNotifier, CartState?>((ref) {
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
final countProvider = StateNotifierProvider<CountNotifier, CountState?>((ref) {
  return CountNotifier();
});

final randomMealsProvider =
    StateNotifierProvider<RandomMealsNotifier, RandomMealsState?>((ref) {
  return RandomMealsNotifier();
});
final addressesProvider =
    StateNotifierProvider<AdressesNotifier, AddressState?>((ref) {
  return AdressesNotifier();
});

final defaultAddressProvider =
    StateNotifierProvider<DefaultAddressNotifier, DefaultAddressState?>((ref) {
  return DefaultAddressNotifier();
});

final orderProvider = StateNotifierProvider<OderNotifier, OrderState?>((ref) {
  return OderNotifier();
});

final orderDetailsProvider =
    StateNotifierProvider<OrderDetailsNotifier, OrderDetailsState?>((ref) {
  return OrderDetailsNotifier();
});

final accountInfoProvider =
StateNotifierProvider<AccountInfoNotifier, AccountInfoState?>((ref) {
  return AccountInfoNotifier();
});
final favoritesProvider =
StateNotifierProvider<FavoriteMealsNotifier, FavoriteMealsState?>((ref) {
  return FavoriteMealsNotifier();
});