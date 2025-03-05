class MealDetailsModel {
  final String mealId;
  final String name;
  final String description;
  final String calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final int sugar;
  final String sodium;
  final String minerals;
  final List<String> ingredients;
  final String imageUrl;
  final String price;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> allergens;
  final Map<String, ContentDetails> contents;

  MealDetailsModel({
    required this.mealId,
    required this.name,
    required this.description,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
    required this.minerals,
    required this.ingredients,
    required this.imageUrl,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    required this.allergens,
    required this.contents,
  });

  factory MealDetailsModel.fromJson(Map<String, dynamic> json) {
    return MealDetailsModel(
      mealId: json['meal_id'].toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      calories: json['calories'] ?? '0',
      protein: json['protein'] ?? 0,
      carbs: json['carbs'] ?? 0,
      fat: json['fat'] ?? 0,
      fiber: json['fiber'] ?? 0,
      sugar: json['sugar'] ?? 0,
      sodium: json['sodium'] ?? '',
      minerals: json['minerals'] ?? '',
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      imageUrl: json['image_url'] ?? '',
      price: json['price'] ?? '0',
      allergens: (json['allergens'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime(1970),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime(1970),
      contents: (json['contents'] as Map<String, dynamic>?)
          ?.map((key, value) => MapEntry(
        key,
        ContentDetails.fromJson(value),
      )) ??
          {},
    );
  }
}

class ContentDetails {
  final String amount;
  final double percentage;

  ContentDetails({
    required this.amount,
    required this.percentage,
  });

  factory ContentDetails.fromJson(Map<String, dynamic> json) {
    return ContentDetails(
      amount: json['amount'] ?? '0g',
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'percentage': percentage,
    };
  }
}
