

import 'package:github_browser/data/model/index_navigation.dart';
import 'package:github_browser/data/model/user_response.dart';

class User {
  final IndexNavigation nav;
  final List<UserResponse> users;

  User({required this.nav, required this.users});

  factory User.fromJson(IndexNavigation nav, List<UserResponse> users) {
    return User(nav: nav, users: users);
  }
}
