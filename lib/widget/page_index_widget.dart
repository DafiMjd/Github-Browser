import 'package:flutter/material.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:github_browser/style/theme_manager.dart';
import 'package:github_browser/utils/global_function.dart';

class PageIndexWidget extends StatelessWidget {
  final int start, end, current;
  const PageIndexWidget(
      {Key? key, required this.start, required this.end, required this.current})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int pageCount = (end > 7) ? 7 : end;
    List<int> listPage = getPagination(current, end);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),
            // TextButton(
            //     onPressed: () {},
            //     child: Text(
            //       '1',
            //       style: Theme.of(context)
            //           .textTheme
            //           .headlineSmall,
            //     )),

            for (int i = 1; i <= listPage.length; i++)
              if (listPage[i - 1] != -1)
                IndexWidget(
                  number: listPage[i - 1].toString(),
                  isSelected: listPage[i - 1] == current,
                  onTap: (() {}),
                )
              else
                IndexSkipWidget(),

            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class IndexWidget extends StatelessWidget {
  final String number;
  final bool isSelected;
  final VoidCallback onTap;
  const IndexWidget(
      {Key? key,
      required this.number,
      required this.isSelected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      overlayColor: MaterialStateProperty.resolveWith((states) {
        // If the button is pressed, return size 40, otherwise 20
        return RADIO_COLOR_DARK;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          number,
          style:
              Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18),
        ),
        decoration: BoxDecoration(
            color: (isSelected) ? RADIO_COLOR_LIGHT : Colors.transparent,
            border: Border.all(color: RADIO_COLOR_LIGHT, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(8))),
      ),
    );
  }
}

class IndexSkipWidget extends StatelessWidget {
  const IndexSkipWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Text(
        '..',
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18),
      ),
    );
  }
}
