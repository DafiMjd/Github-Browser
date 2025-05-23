import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:github_browser/utils/global_function.dart';
import 'package:github_browser/view/search/bloc/search_bloc.dart';

class PageIndexWidget extends StatelessWidget {
  final int start, end, current, next, prev;
  final bool enabled;
  // final VoidCallback nextPage, prevPage, goToPage;
  const PageIndexWidget({
    Key? key,
    required this.start,
    required this.end,
    required this.current,
    required this.next,
    required this.prev,
    required this.enabled,
    // required this.nextPage, required this.prevPage, required this.goToPage
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<int> listPage = getPagination(current, end);
    return SafeArea(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: prev != 0,
                child: InkWell(
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                  onTap: () {
                    context.read<SearchBloc>().add(SearchGoToPage(current - 1));
                  },
                ),
              ),
              // TextButton(
              //     onPressed: () {},
              //     child: Text(
              //       '1',
              //       style: Theme.of(context)
              //           .textTheme
              //           .headlineSmall,
              //     )),

              for (int i = 0; i < listPage.length; i++)
                if (listPage[i] != -1)
                  IndexWidget(
                    number: listPage[i].toString(),
                    isSelected: listPage[i] == current,
                    onTap: () {
                      context
                          .read<SearchBloc>()
                          .add(SearchGoToPage(listPage[i]));
                    },
                  )
                else
                  const IndexSkipWidget(),

              // BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
              //   for (int i = 0; i < listPage.length; i++) {
              //     if (listPage[i] != -1) {
              //       return IndexWidget(
              //         number: listPage[i].toString(),
              //         isSelected: listPage[i] == current,
              //         onTap: (() {}),
              //       );
              //     } else {
              //       return const IndexSkipWidget();
              //     }
              //   }
              //   return Container();
              // }),

              Visibility(
                visible: next != 0,
                child: InkWell(
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                  onTap: () {
                    context.read<SearchBloc>().add(SearchGoToPage(current + 1));
                  },
                ),
              ),
            ],
          ),
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
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              fontSize: 18,
              color: (isSelected)
                  ? Colors.white
                  : Theme.of(context).textTheme.headlineSmall!.color),
        ),
        decoration: BoxDecoration(
            color: (isSelected) ? RADIO_COLOR_LIGHT : Colors.transparent,
            border: Border.all(color: RADIO_COLOR_LIGHT, width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
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
        '...',
        style:
            Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 18),
      ),
    );
  }
}
