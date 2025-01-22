class MealsCategory {
  final int categoryId;
  final String name;
  final String description;
  final String imageUrl;

  MealsCategory({
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  // JSON constructor
  factory MealsCategory.fromJson(Map<String, dynamic> json) {
    return MealsCategory(
      categoryId: int.parse(json['category_id'] as String),
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
    );
  }
}
