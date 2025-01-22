class MealType {
  final int typeId;
  final String name;
  final String description;
  final String imageUrl;

  MealType({
    required this.typeId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  // JSON constructor
  factory MealType.fromJson(Map<String, dynamic> json) {
    return MealType(
      typeId: int.parse(json['type_id'] as String),
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['image_url'] as String,
    );
  }
}
