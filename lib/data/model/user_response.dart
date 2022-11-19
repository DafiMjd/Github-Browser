class UserResponse {
  final int id;
  final String username, url, imageUrl;

  UserResponse(
      {required this.id,
      required this.username,
      required this.url,
      required this.imageUrl});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
        id: json['id'] ?? 0,
        username: json['login'] ?? '',
        url: json['html_url'] ?? '',
        imageUrl: json['avatar_url'] ?? '');
  }
}
