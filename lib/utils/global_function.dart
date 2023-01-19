import 'package:flutter/material.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
      // test commit to count LOC
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

String dateFormat(String isoDate) {
  final dateTime = DateTime.parse(isoDate);
  final format = DateFormat('y-MM-dd');
  final date = format.format(dateTime);
  return date;
}

String numberFormat(double num, int divCount) {
  String trailing = getTrailing(divCount);

  if (num < 1000) return num.toStringAsFixed(0) + trailing;

  if (divCount == 2) return '>' + num.toStringAsFixed(0) + trailing;

  return numberFormat(num / 1000, divCount + 1);
}

String getTrailing(int div) {
  switch (div) {
    case 0:
      return '';
    case 1:
      return 'K';
    case 2:
      return 'M';
    default:
      return '...';
  }
}

Widget loadingImage() {
    return Shimmer.fromColors(
      baseColor: SKELETON_COLOR,
      highlightColor: SKELETON_HIGHLIGHT_COLOR,
      child: Container(
        width: 60,
        height: 60,
        color: SKELETON_HIGHLIGHT_COLOR,
      ),
    );
  }