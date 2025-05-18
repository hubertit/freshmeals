class SettingsAddress {
  final String companyName;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String twitter;
  final String instagram;
  final String facebook;
  final String youtube;
  final String linkedin;

  SettingsAddress({
    required this.companyName,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.twitter,
    required this.instagram,
    required this.facebook,
    required this.youtube,
    required this.linkedin,
  });

  factory SettingsAddress.fromJson(Map<String, dynamic> json) {
    return SettingsAddress(
      companyName: json['company_name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      twitter: json['twitter'],
      instagram: json['instagram'],
      facebook: json['facebook'],
      youtube: json['youtube'],
      linkedin: json['linkedin'],
    );
  }
}
