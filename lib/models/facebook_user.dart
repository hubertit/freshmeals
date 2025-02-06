class FacebookUser {
  final String email;
  // final String id;
  final String name;
  // final ProfilePicture picture;

  FacebookUser({
    required this.email,
    // required this.id,
    required this.name,
    // required this.picture,
  });

  factory FacebookUser.fromJson(Map<String, dynamic> json) {
    return FacebookUser(
      email: json['email'] ?? '',
      // id: json['id'] ?? '',
      name: json['name'] ?? '',
      // picture: ProfilePicture.fromJson(json['picture']['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      // 'id': id,
      'name': name,
      // 'picture': picture.toJson(),
    };
  }
}

class ProfilePicture {
  final bool isSilhouette;
  final int height;
  final int width;
  final String url;

  ProfilePicture({
    required this.isSilhouette,
    required this.height,
    required this.width,
    required this.url,
  });

  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      isSilhouette: json['is_silhouette'] ?? true,
      height: json['height'] ?? 0,
      width: json['width'] ?? 0,
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_silhouette': isSilhouette,
      'height': height,
      'width': width,
      'url': url,
    };
  }
}
