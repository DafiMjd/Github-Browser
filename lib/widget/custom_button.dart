import 'package:flutter/material.dart';
import 'package:github_browser/style/custom_style.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:github_browser/style/theme_manager.dart';
import 'package:github_browser/utils/global_function.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.text,
    required this.isPrimary,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeManager _themeManager = ThemeManager();
    bool isDark = _themeManager.themeMode == ThemeMode.dark;

    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
          width: mQueryWidth(context, size: 0.3),
          child: Center(
              child: Text(
            text,
            style: isPrimary
                ? Theme.of(context).textTheme.button
                : isDark
                    ? Theme.of(context).textTheme.button
                    : Theme.of(context)
                        .textTheme
                        .button!
                        .copyWith(color: PRIMARY_COLOR),
          ))),
      style: CustomStyle.button(isPrimary, isDark),
    );
  }
}
