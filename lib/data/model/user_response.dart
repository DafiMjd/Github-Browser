class UserResponse {
  final int id;
  final String username, userUrl, imageUrl;

  UserResponse(
      {required this.id,
      required this.username,
      required this.userUrl,
      required this.imageUrl});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
        id: json['id'] ?? 0,
        username: json['login'] ?? '',
        userUrl: json['url'] ?? '',
        imageUrl: json['avatar_url'] ?? '');
  }
}
