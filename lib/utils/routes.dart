// import 'package:flutter/material.dart';
// import 'package:github_browser/style/theme_manager.dart';
// import 'package:github_browser/view/home/home_page.dart';
// import 'package:github_browser/view/search/search_page.dart';

// class ReouteGenerator {
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     // jika ingin mengirim argument
//     // final args = settings.arguments; 
//     // switch (settings.name) {
//       case '/':
//       ThemeManager themeManager
//         return MaterialPageRoute(builder: (_) => HomePage());
//       case '/search':
//         return MaterialPageRoute(builder: (_) => SearchPage());
//         // return MaterialPageRoute(builder: (_) => AboutPage(args));
//       default:
//         return _errorRoute();
//     }
//   }
//   static Route<dynamic> _errorRoute() {
//     return MaterialPageRoute(builder: (_) {
//       return Scaffold(
//         appBar: AppBar(title: Text("Error")),
//         body: Center(child: Text('Error page')),
//       );
//     });
//   }
// }