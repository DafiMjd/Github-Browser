import 'package:github_browser/utils/connectivity_service.dart';
import 'package:http/http.dart' as http;

class GithubProvider {
  Future<Map<String, String?>> fetchGithub(
      String type, String keyword, String page) async {
    try {
      if (!await ConnectivityService.internetConnectivity()) throw 'offline';
      
      String url =
          'https://api.github.com/search/$type?q=$keyword&per_page=7&page=$page';

      final response = await http.get(Uri.parse(url));

      var responseReturn = {
        'link': response.headers['link'],
        'body': response.body,
        'limit': response.headers['x-ratelimit-remaining'] ?? '0'
      };

      return responseReturn;
    } catch (e) {
      rethrow;
    }
  }
}
