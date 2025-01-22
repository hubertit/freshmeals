class HealthGoal {
  final String goalId;
  final String name;
  final String description;
  final String imageUrl;

  HealthGoal({
    required this.goalId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  // Factory constructor to parse from JSON
  factory HealthGoal.fromJson(Map<String, dynamic> json) {
    return HealthGoal(
      goalId: json['goal_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }

}
