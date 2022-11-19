class RepositoryResponse {
  final int id;
  final String name, fullname, createdAt, url, imageUrl;
  final int watcher, star, fork;

  RepositoryResponse({
      required this.id,
      required this.name,
      required this.fullname,
      required this.createdAt,
      required this.url,
      required this.imageUrl,
      required this.watcher,
      required this.star,
      required this.fork});

  factory RepositoryResponse.fromJson(Map<String, dynamic> json) {
    return RepositoryResponse(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        fullname: json['full_name'] ?? '',
        createdAt: json['created_at'] ?? '',
        url: json['html_url'] ?? '',
        imageUrl: json['owner']['avatar_url'] ?? '',
        watcher: json['watchers_count'] ?? 0,
        star: json['stargazers_count'] ?? 0,
        fork: json['forks_count'] ?? 0);
  }
}
