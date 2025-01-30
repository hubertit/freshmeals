import 'package:easy_localization/easy_localization.dart';

class Meal {
  final String mealId;
  final String name;
  final String description;
  final String price;
  final String imageUrl;

  Meal({
    required this.mealId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealId: json['meal_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '0',
      imageUrl: json['image_url'] ?? '',
    );
  }
}

class MealsData {
  final List<Meal> yourPick;
  final List<Meal> breakfast;
  final List<Meal> lunch;
  final List<Meal> dinner;

  MealsData({
    required this.yourPick,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  factory MealsData.fromJson(Map<String, dynamic> json) {
    return MealsData(
      yourPick: (json['Your Pick'] as List<dynamic>)
          .map((mealJson) => Meal.fromJson(mealJson))
          .toList(),
      breakfast: (json['Breakfast'] as List<dynamic>)
          .map((mealJson) => Meal.fromJson(mealJson))
          .toList(),
      lunch: (json['Lunch'] as List<dynamic>)
          .map((mealJson) => Meal.fromJson(mealJson))
          .toList(),
      dinner: (json['Dinner'] as List<dynamic>)
          .map((mealJson) => Meal.fromJson(mealJson))
          .toList(),
    );
  }
}
