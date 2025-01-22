class SubscriptionPlan {
  final String planId;
  final String name;
  final String description;
  final String price;
  final String duration;
  final String mealCount;
  final String imageUrl;

  SubscriptionPlan({
    required this.planId,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.mealCount,
    required this.imageUrl,
  });

  // Factory constructor to parse from JSON
  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      planId: json['plan_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      duration: json['duration'] ?? '',
      mealCount: json['meal_count'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}
