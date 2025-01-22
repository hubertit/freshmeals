class PreferenceModel {
  final String preferenceId;
  final String name;
  final String description;
  final String imageUrl;

  PreferenceModel({
    required this.preferenceId,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  // Factory constructor to parse from JSON
  factory PreferenceModel.fromJson(Map<String, dynamic> json) {
    return PreferenceModel(
      preferenceId: json['preference_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
    );
  }
}

// Utility function to parse a list of preferences from JSON
List<PreferenceModel> parsePreferences(List<dynamic> jsonList) {
  return jsonList.map((json) => PreferenceModel.fromJson(json)).toList();
}
