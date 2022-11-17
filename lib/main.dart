import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_browser/data/repo/github_repository.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:github_browser/style/theme_manager.dart';
import 'package:github_browser/view/home/bloc/home_bloc.dart';
import 'package:github_browser/view/home/home_page.dart';
import 'package:github_browser/view/search/bloc/search_bloc.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
      BlocProvider<SearchBloc>(
          create: (context) => SearchBloc(GithubRepository())),
    ],
    child: DevicePreview(
      builder: (context) => const MyApp(),
      enabled: !kReleaseMode,
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
