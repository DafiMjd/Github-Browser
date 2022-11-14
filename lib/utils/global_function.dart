import 'package:flutter/material.dart';

double mQueryWidth(BuildContext context, {double size = 1}) {
  if (size > 1) size = 1;
  return MediaQuery.of(context).size.width * size;
}

double mQueryHeight(BuildContext context, {double size = 1}) {
  if (size > 1) size = 1;
  return MediaQuery.of(context).size.height * size;
}

Widget verticalSpace(double height) {
  return SizedBox(
    height: height,
  );
}

Widget horizontalSpace(double width) {
  return SizedBox(
    width: width,
  );
}