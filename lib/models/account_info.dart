class AccountInformationModel {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String? passwordHash;
  final String token;
  final String? tokenExpiry;
  final String status;
  final String role;
  final int age;
  final String gender;
  final String healthStatus;
  final double height;
  final double weight;
  final double targetWeight;
  final double bmi;
  final String activityLevel;
  final List<String> dietaryPreferences;
  final List<String> healthConditions;
  final List<String> healthGoal;
  final int calLimit;
  final List<String> preExistingConditions;
  final List<String> foodAllergies;
  final double walletBalance;
  final String profilePicture;
  final DateTime createdAt;
  final DateTime updatedAt;

  AccountInformationModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.passwordHash,
    required this.token,
    this.tokenExpiry,
    required this.status,
    required this.role,
    required this.age,
    required this.gender,
    required this.healthStatus,
    required this.height,
    required this.weight,
    required this.targetWeight,
    required this.bmi,
    required this.activityLevel,
    required this.dietaryPreferences,
    required this.healthConditions,
    required this.healthGoal,
    required this.calLimit,
    required this.preExistingConditions,
    required this.foodAllergies,
    required this.walletBalance,
    required this.profilePicture,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AccountInformationModel.fromJson(Map<String, dynamic> json) {
    return AccountInformationModel(
      userId: json["user_id"] ?? '',
      name: json["name"] ?? '',
      email: json["email"] ?? '',
      phoneNumber: json["phone_number"] ?? '',
      passwordHash: json["password_hash"],
      token: json["token"] ?? '',
      tokenExpiry: json["token_expiry"],
      status: json["status"] ?? '',
      role: json["role"] ?? '',
      age: int.tryParse(json["age"]?.toString() ?? '') ?? 0,
      gender: json["gender"] ?? '',
      healthStatus: json["health_status"] ?? '',
      height: double.tryParse(json["height"]?.toString() ?? '') ?? 0.0,
      weight: double.tryParse(json["weight"]?.toString() ?? '') ?? 0.0,
      targetWeight: double.tryParse(json["target_weight"]?.toString() ?? '') ?? 0.0,
      bmi: double.tryParse(json["bmi"]?.toString() ?? '') ?? 0.0,
      activityLevel: json["activity_level"] ?? '',
      dietaryPreferences: List<String>.from(json["dietary_preferences"] ?? []),
      healthConditions: List<String>.from(json["health_conditions"] ?? []),
      healthGoal: List<String>.from(json["health_goal"] ?? []),
      calLimit: int.tryParse(json["cal_limit"]?.toString() ?? '') ?? 0,
      preExistingConditions: List<String>.from(json["pre_existing_conditions"] ?? []),
      foodAllergies: List<String>.from(json["food_allergies"] ?? []),
      walletBalance: double.tryParse(json["wallet_balance"]?.toString() ?? '') ?? 0.0,
      profilePicture: json["profile_picture"] ?? '',
      createdAt: DateTime.tryParse(json["created_at"] ?? '') ?? DateTime(1970),
      updatedAt: DateTime.tryParse(json["updated_at"] ?? '') ?? DateTime(1970),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user_id": userId,
      "name": name,
      "email": email,
      "phone_number": phoneNumber,
      "password_hash": passwordHash,
      "token": token,
      "token_expiry": tokenExpiry,
      "status": status,
      "role": role,
      "age": age.toString(),
      "gender": gender,
      "health_status": healthStatus,
      "height": height.toString(),
      "weight": weight.toString(),
      "target_weight": targetWeight.toString(),
      "bmi": bmi.toString(),
      "activity_level": activityLevel,
      "dietary_preferences": dietaryPreferences,
      "health_conditions": healthConditions,
      "health_goal": healthGoal,
      "cal_limit": calLimit.toString(),
      "pre_existing_conditions": preExistingConditions,
      "food_allergies": foodAllergies,
      "wallet_balance": walletBalance.toString(),
      "profile_picture": profilePicture,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
    };
  }
}
