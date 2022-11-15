class IssueResponse {
  final int id;
  final String title, updatedAt, state, imageUrl;

  IssueResponse(
      {required this.id,
      required this.title,
      required this.updatedAt,
      required this.state,
      required this.imageUrl});

  factory IssueResponse.fromJson(Map<String, dynamic> json) {
    return IssueResponse(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      state: json['state'] ?? '',
      imageUrl: json['user']['avatar_url'] ?? '',
    );
  }
}
