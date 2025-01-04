class UserModel {
  final String userId;
  final String lname;
  final String fname;
  final String phone;
  final String email;
  final String password;
  final String token;
  final String role;
  final String createdAt;
  final String status;

  UserModel({
    required this.userId,
    required this.lname,
    required this.fname,
    required this.phone,
    required this.email,
    required this.password,
    required this.token,
    required this.role,
    required this.createdAt,
    required this.status,
  });

  // Factory method to create a User from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      lname: json['lname'],
      fname: json['fname'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      token: json['token'],
      role: json['role'],
      createdAt: json['created_at'],
      status: json['status'],
    );
  }

  // Method to convert a User object to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'lname': lname,
      'fname': fname,
      'phone': phone,
      'email': email,
      'password': password,
      'token': token,
      'role': role,
      'created_at': createdAt,
      'status': status,
    };
  }
}
