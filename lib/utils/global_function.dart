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

List<int> getPagination(current, max) {
  int delta = 1, left = current - delta, right = current + delta + 1;
  List range = [];
  List<int> rangeWithDots = <int>[];
  int? l;

  for (int i = 1; i <= max; i++) {
    if (i == 1 || i == max || i >= left && i < right) {
      range.add(i);
    }
  }

  for (int i in range) {
    if (l != null) {
      if (i - l == 2) {
        rangeWithDots.add(l + 1);
      } else if (i - l != 1) {
        rangeWithDots.add(-1);
      }
    }
    rangeWithDots.add(i);
    l = i;
  }

  return rangeWithDots;
}
