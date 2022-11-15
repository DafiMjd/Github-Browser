import 'package:flutter/material.dart';
import 'package:github_browser/style/custom_style.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:github_browser/utils/global_function.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;
  final bool enabled;
  const CustomButton(
      {Key? key,
      required this.text,
      required this.isPrimary,
      required this.onPressed,
      required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    bool isDark = mode.brightness == Brightness.dark;

    return ElevatedButton(
      onPressed: enabled ? onPressed : () {},
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
