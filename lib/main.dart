import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_browser/data/repo/github_repository.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:github_browser/style/theme_manager.dart';
import 'package:github_browser/view/home/bloc/home_bloc.dart';
import 'package:github_browser/view/home/home_page.dart';
import 'package:github_browser/view/search/bloc/search_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
      BlocProvider<SearchBloc>(create: (context) => SearchBloc(GithubRepository())),
    ],
    child: const MyApp(),
  ));
}

ThemeManager _themeManager = ThemeManager();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _themeManager.addListener(themeListener);
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      debugShowCheckedModeBanner: false,
      home: HomePage(themeManager: _themeManager,),
    );
  }
}
