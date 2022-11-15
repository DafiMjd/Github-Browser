import 'package:flutter/material.dart';
import 'package:github_browser/style/theme_constant.dart';

class CustomStyle {
  static ButtonStyle button(bool isPrimary, bool isDark) {
    var bgColor = (isDark) ? darkTheme.canvasColor : Colors.white;
    return ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(isPrimary ? PRIMARY_COLOR : bgColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: const BorderSide(color: PRIMARY_COLOR, width: 2))));
  }
}
