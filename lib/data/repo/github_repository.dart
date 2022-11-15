import 'dart:convert';

import 'package:github_browser/data/model/index_navigation.dart';
import 'package:github_browser/data/model/issue.dart';
import 'package:github_browser/data/model/issue_response.dart';
import 'package:github_browser/data/model/repository.dart';
import 'package:github_browser/data/model/repository_response.dart';
import 'package:github_browser/data/model/user.dart';
import 'package:github_browser/data/model/user_response.dart';
import 'package:github_browser/data/repository/github_provider.dart';

class GithubRepository {
  final GithubProvider _githubProvider = GithubProvider();

  Future<dynamic> fetchGithub(String type, String keyword, String page) async {
    try {
      var response = await _githubProvider.fetchGithub(type, keyword, page);

      if (response == null) throw 'error';

      late IndexNavigation indexNav;

      if (response['link'] == null) {
        indexNav = IndexNavigation('', '', '', '');
      } else {
        indexNav = getIndexNav(response['link']!);
      }

      var data = jsonDecode(response['body']!);
      var json = data['items'] as List<dynamic>;

      switch (type) {
        case 'repositories':
          return parseRepos(indexNav, json);
        case 'users':
          return parseUsers(indexNav, json);
        case 'issues':
          return parseIssues(indexNav, json);

        default:
      }
    } catch (e) {
      rethrow;
    }
  }

  IndexNavigation getIndexNav(String headerLinkString) {
    // split header links by rel
    List<String> headerLinks = headerLinkString.split(
      ', ',
    );

    // variable for IndexNavigation
    String prev = '', next = '', last = '', first = '';

    for (int i = 0; i < headerLinks.length; i++) {
      // delete all chars before ? to lessen the link
      headerLinks[i] = headerLinks[i]
          .substring(headerLinks[i].indexOf('?'), headerLinks[i].length);

      // split the link by & so that in can be identified by rel
      List<String> splitTemp = headerLinks[i].split('&');

      // fill variable for IndexNavigation
      for (final link in splitTemp) {
        if (link.contains(
          // identifying rel
          'prev',
        )) {
          // chose only number to get page
          prev = link.replaceAll(RegExp(r'[^0-9]'), '');
        } else if (link.contains(
          'next',
        )) {
          next = link.replaceAll(RegExp(r'[^0-9]'), '');
        } else if (link.contains(
          'last',
        )) {
          last = link.replaceAll(RegExp(r'[^0-9]'), '');
        } else if (link.contains(
          'first',
        )) {
          first = link.replaceAll(RegExp(r'[^0-9]'), '');
        }
      }
    }

    IndexNavigation nav = IndexNavigation(prev, next, last, first);
    return nav;
  }

  Repository parseRepos(IndexNavigation nav, List<dynamic> json) {
    List<RepositoryResponse> repos = json
        .map<RepositoryResponse>((json) => RepositoryResponse.fromJson(json))
        .toList();
    return Repository(nav: nav, repositories: repos);
  }

  User parseUsers(IndexNavigation nav, List<dynamic> json) {
    List<UserResponse> users =
        json.map<UserResponse>((json) => UserResponse.fromJson(json)).toList();
    return User(nav: nav, users: users);
  }

  Issue parseIssues(IndexNavigation nav, List<dynamic> json) {
    List<IssueResponse> issues = json
        .map<IssueResponse>((json) => IssueResponse.fromJson(json))
        .toList();
    return Issue(nav: nav, issues: issues);
  }
}
