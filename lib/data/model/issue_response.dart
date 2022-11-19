class IssueResponse {
  final int id;
  final String title, updatedAt, state, imageUrl, url;

  IssueResponse(
      {required this.id,
      required this.title,
      required this.updatedAt,
      required this.state,
      required this.imageUrl,
      required this.url});

  factory IssueResponse.fromJson(Map<String, dynamic> json) {
    return IssueResponse(
        id: json['id'] ?? 0,
        title: json['title'] ?? '',
        updatedAt: json['updated_at'] ?? '',
        state: json['state'] ?? '',
        imageUrl: json['user']['avatar_url'] ?? '',
        url: json['html_url'] ?? '');
  }
}
