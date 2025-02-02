// class AccountInfo {
//   final String userId;
//   final String name;
//   final String email;
//   final String phoneNumber;
//   final String age;
//   final String gender;
//   final String healthStatus;
//   final double height;
//   final double weight;
//   final String? activityLevel;
//   final List<String> dietaryPreferences;
//
//   AccountInfo({
//     required this.userId,
//     required this.name,
//     required this.email,
//     required this.phoneNumber,
//     required this.age,
//     required this.gender,
//     required this.healthStatus,
//     required this.height,
//     required this.weight,
//     this.activityLevel,
//     required this.dietaryPreferences,
//   });
//
//   factory AccountInfo.fromJson(Map<String, dynamic> json) {
//     return AccountInfo(
//       userId: json['user_id'],
//       name: json['name'],
//       email: json['email'],
//       phoneNumber: json['phone_number'],
//       // age: int.tryParse(json['age'] ?? '0') ?? '0',
//       age: json['age'] ?? '0',
//       gender: json['gender'],
//       healthStatus: json['health_status'],
//       height: double.tryParse(json['height'] ?? '0.0') ?? 0.0,
//       weight: double.tryParse(json['weight'] ?? '0.0') ?? 0.0,
//       activityLevel: json['activity_level'].toString().isEmpty ? null : json['activity_level'],
//       dietaryPreferences: List<String>.from(json['dietary_preferences'] ?? []),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'user_id': userId,
//       'name': name,
//       'email': email,
//       'phone_number': phoneNumber,
//       'age': age.toString(),
//       'gender': gender,
//       'health_status': healthStatus,
//       'height': height.toString(),
//       'weight': weight.toString(),
//       'activity_level': activityLevel ?? "",
//       'dietary_preferences': dietaryPreferences,
//     };
//   }
// }
