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

final List<HealthGoal> dummyHealthGoals = [
  HealthGoal(
    goalId: '1',
    name: 'Weight Loss',
    description: 'Focus on reducing body fat and achieving a healthier weight.',
    imageUrl: 'https://example.com/images/weight_loss.png',
  ),
  HealthGoal(
    goalId: '2',
    name: 'Weight Gain',
    description:
        'Aim to increase body weight in a healthy and sustainable way.',
    imageUrl: 'https://example.com/images/weight_gain.png',
  ),
  HealthGoal(
    goalId: '3',
    name: 'Muscle Building',
    description:
        'Strengthen and build muscle mass through proper training and nutrition.',
    imageUrl: 'https://example.com/images/muscle_building.png',
  ),
  HealthGoal(
    goalId: '4',
    name: 'Improving Overall Health',
    description: 'Focus on enhancing general health, fitness, and well-being.',
    imageUrl: 'https://example.com/images/overall_health.png',
  ),
  HealthGoal(
    goalId: '5',
    name: 'Managing a Medical Condition',
    description:
        'Support health goals related to managing a specific medical condition.',
    imageUrl: 'https://example.com/images/medical_condition.png',
  ),
  HealthGoal(
    goalId: '6',
    name: 'Improving Athletic Performance',
    description:
        'Boost physical performance and endurance for athletic activities.',
    imageUrl: 'https://example.com/images/athletic_performance.png',
  ),
  HealthGoal(
    goalId: '7',
    name: 'Other',
    description: 'Customize your health goal based on your unique needs.',
    imageUrl: 'https://example.com/images/other_goal.png',
  ),
];
