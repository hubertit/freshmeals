class Nutritionist {
  final String userId;
  final String name;
  final String email;
  final String phoneNumber;
  final String profilePicture;

  Nutritionist({
    required this.userId,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
  });

  // Factory constructor to create a Nutritionist from JSON
  factory Nutritionist.fromJson(Map<String, dynamic> json) {
    return Nutritionist(
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      profilePicture: json['profile_picture'] ?? '',
    );
  }

  // Convert Nutritionist object to JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'profile_picture': profilePicture,
    };
  }
}
