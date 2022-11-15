

import 'package:github_browser/data/model/index_navigation.dart';
import 'package:github_browser/data/model/issue_response.dart';

class Issue {
  final IndexNavigation nav;
  final List<IssueResponse> issues;

  Issue({required this.nav, required this.issues});

  factory Issue.fromJson(IndexNavigation nav, List<IssueResponse> issues) {
    return Issue(nav: nav, issues: issues);
  }
}
