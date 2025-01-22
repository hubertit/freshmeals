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
  String activityLevel;
  List<int> dietaryPreferences;

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
    required this.activityLevel,
    required this.dietaryPreferences,
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
      "height": height,
      "weight": weight,
      "activity_level": activityLevel,
      "dietary_preferences": dietaryPreferences,
    };
  }
}


class User {
  final int userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String token;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.token,
  });

  // Factory constructor to parse from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      token: json['token'] ?? '',
    );
  }

  // Method to convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'token': token,
    };
  }
}
