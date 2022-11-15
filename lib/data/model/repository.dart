

import 'package:github_browser/data/model/index_navigation.dart';
import 'package:github_browser/data/model/repository_response.dart';

class Repository {
  final IndexNavigation nav;
  final List<RepositoryResponse> repositories;

  Repository({required this.nav, required this.repositories});

  factory Repository.fromJson(
      IndexNavigation nav, List<RepositoryResponse> repositories) {
    return Repository(nav: nav, repositories: repositories);
  }
}
