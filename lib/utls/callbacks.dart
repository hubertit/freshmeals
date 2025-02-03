import 'package:easy_localization/easy_localization.dart';

import '../models/home/meal_model.dart';

typedef OnButtonClick = Function();

typedef OnIntButtonClick = Function(int);
typedef OnFormValidate = String? Function(String?);
typedef OnStringButtonClick = Function(String);
typedef OnItemButtonClick = Function(dynamic, dynamic);
typedef OnMultipleItemButtonClick = Function(List<dynamic>, List<dynamic>);
typedef OnFutureRefresh = Future Function();

String formatMoney(String value) {
  double? number = double.tryParse(value);
  if (number == null) return value; // Return as-is if not a valid number

  // Format number with thousands separator and remove trailing zeros
  NumberFormat formatter = NumberFormat("#,##0.##");
  return formatter.format(number);
}

bool isFavorite(String mealId, List<Meal>? favoriteMeals) {
  return favoriteMeals!.any((meal) => meal.mealId == mealId);
}
