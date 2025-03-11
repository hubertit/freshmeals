class UserModel {
  String names;
  String phone;
  String email;
  String password;
  int age;
  String gender;
  String healthStatus;
  double height;
  double weight;
  double? targetWeight;
  int? calLimit;
  String activityLevel;
  List<String> dietaryPreferences;
  List<String> preExistingConditions;
  List<String> foodAllergies;
  List<String> healthyGoals;

  UserModel({
    required this.names,
    required this.phone,
    required this.email,
    required this.password,
    required this.age,
    required this.gender,
    required this.healthStatus,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.calLimit,
    required this.activityLevel,
    required this.dietaryPreferences,
    required this.preExistingConditions,
    required this.foodAllergies,
    required this.healthyGoals
  });

  Map<String, dynamic> toJson() {
    return {
      "name": names,
      "phone": phone,
      "email": email,
      "password": password,
      "age": age,
      "gender": gender,
      "health_status": healthStatus,
      "health_goal": healthyGoals,
      "height": height,
      "weight": weight,
      "target_weight": targetWeight,
      "cal_limit": calLimit,
      "activity_level": activityLevel,
      "dietary_preferences": dietaryPreferences,
      "pre_existing_conditions": preExistingConditions,
      "health_conditions": [],
      "food_allergies": foodAllergies,
    };
  }
}


class User {
  final int userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String token;
  final String? status;
  final String? role;
  final int? age;
  final String? gender;
  final String? healthStatus;
  final double? height;
  final double? weight;
  final double? bmi;
  final String? activityLevel;
  final List<String>? dietaryPreferences;
  final List<dynamic>? healthConditions;
  final List<dynamic>? healthGoal;
  final String? profilePicture;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.token,
    this.status,
    this.role,
    this.age,
    this.gender,
    this.healthStatus,
    this.height,
    this.weight,
    this.bmi,
    this.activityLevel,
    this.dietaryPreferences,
    this.healthConditions,
    this.healthGoal,
    this.profilePicture,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor to parse from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: int.tryParse(json['user_id'].toString()) ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      token: json['token'] ?? '',
      status: json['status'],
      role: json['role'],
      age: int.tryParse(json['age']?.toString() ?? ''),
      gender: json['gender'],
      healthStatus: json['health_status'],
      height: double.tryParse(json['height']?.toString() ?? ''),
      weight: double.tryParse(json['weight']?.toString() ?? ''),
      bmi: double.tryParse(json['bmi']?.toString() ?? ''),
      activityLevel: json['activity_level'],
      dietaryPreferences: (json['dietary_preferences'] as List<dynamic>?)
          ?.map((e) => e.toString() ?? '')
          .toList(),
      healthConditions: json['health_conditions'],
      healthGoal: json['health_goal'],
      profilePicture: json['profile_picture'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  /// Method to convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'token': token,
      'status': status,
      'role': role,
      'age': age,
      'gender': gender,
      'health_status': healthStatus,
      'height': height,
      'weight': weight,
      'bmi': bmi,
      'activity_level': activityLevel,
      'dietary_preferences': dietaryPreferences,
      'health_conditions': healthConditions,
      'health_goal': healthGoal,
      'profile_picture': profilePicture,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}