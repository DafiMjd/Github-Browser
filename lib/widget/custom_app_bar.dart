import 'package:flutter/material.dart';
import 'package:github_browser/style/theme_manager.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeManager themeManager = ThemeManager();
    return AppBar(
      actions: [
        Switch(
            value: themeManager.themeMode == ThemeMode.dark,
            onChanged: (value) {
              themeManager.toggleTheme(value);
            })
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}
