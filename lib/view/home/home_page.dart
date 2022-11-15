// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_browser/style/theme_manager.dart';
import 'package:github_browser/utils/global_function.dart';
import 'package:github_browser/view/home/bloc/home_bloc.dart';
import 'package:github_browser/view/search/search_page.dart';
import 'package:github_browser/widget/search_box.dart';

class HomePage extends StatefulWidget {
  final ThemeManager themeManager;
  const HomePage({Key? key, required this.themeManager}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String mode;
  @override
  void initState() {
    super.initState();
    mode = widget.themeManager.themeMode == ThemeMode.dark ? 'dark' : 'light';
  }

  @override
  Widget build(BuildContext context) {
    var searchCtrl = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        actions: [
          Switch(
              value: widget.themeManager.themeMode == ThemeMode.dark,
              // value: false,
              onChanged: (value) {
                widget.themeManager.toggleTheme(value);
              })
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/github_icon_$mode.png',
                      width: mQueryHeight(context, size: 0.3),
                      height: mQueryWidth(context, size: 0.3),
                    ),
                    verticalSpace(20),
                    const Text('Github Browser'),
                    verticalSpace(30),
                    SearchBox(
                      submit: (value) {
                        if (value.isNotEmpty)
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchPage(
                                  keyword: searchCtrl.text,
                                ),
                              ));
                      },
                      onChanged: (value) {
                        context
                            .read<HomeBloc>()
                            .add(HomeTypeSearchBox(value.isEmpty));
                      },
                      trailing: BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state is HomeInitial)
                            return const Visibility(
                                visible: false, child: Icon(Icons.cancel));
                          else {
                            HomeTypingSearchBox homeTyping =
                                state as HomeTypingSearchBox;
                            return Visibility(
                                visible: !state.isEmpty,
                                child: IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    searchCtrl.text = '';
                                    context
                                        .read<HomeBloc>()
                                        .add(HomeTypeSearchBox(true));
                                  },
                                ));
                          }
                        },
                      ),
                      ctrl: searchCtrl,
                      enabled: true,
                    ),
                  ]),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(
                  keyword: 'doraemon',
                ),
              ));
        },
      ),
    );
  }
}
