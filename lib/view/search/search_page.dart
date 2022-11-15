import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_browser/data/search_type.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:github_browser/utils/global_function.dart';
import 'package:github_browser/view/search/bloc/search_bloc.dart';
import 'package:github_browser/widget/custom_button.dart';
import 'package:github_browser/widget/page_index_widget.dart';
import 'package:github_browser/widget/search_box.dart';
import 'package:number_pagination/number_pagination.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    bool isDark = mode.brightness == Brightness.dark;
    var searchCtrl = TextEditingController();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SearchBox(
                  submit: (value) {
                    if (value.isNotEmpty) print(value);
                  },
                  onChanged: (value) {
                    context
                        .read<SearchBloc>()
                        .add(SearchTypeSearchBox(value.isEmpty));
                  },
                  trailing: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      return Visibility(
                          visible: !state.isSearchFieldEmpty,
                          child: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              searchCtrl.text = '';
                            },
                          ));
                    },
                  ),
                  ctrl: searchCtrl,
                ),
                verticalSpace(10),
                StickyHeader(
                    header: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        return Container(
                          color: isDark
                              ? darkTheme.canvasColor
                              : lightTheme.canvasColor,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SearchTypeWidget(
                                          text: 'Users',
                                          groupValue: state.type,
                                          value: SearchType.user,
                                        ),
                                        SearchTypeWidget(
                                          text: 'Issues',
                                          groupValue: state.type,
                                          value: SearchType.issue,
                                        ),
                                        SearchTypeWidget(
                                          text: 'Repositories',
                                          groupValue: state.type,
                                          value: SearchType.repository,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                BlocBuilder<SearchBloc, SearchState>(
                                  builder: (context, state) {
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      // mainAxisSize: MainAxisSize.min,
                                      // mainAxisAlignment:
                                      //     MainAxisAlignment.spaceB,
                                      children: [
                                        CustomButton(
                                            text: 'Lazy Loading',
                                            isPrimary: state.isLazyLoading,
                                            onPressed: () {
                                              if (!state.isLazyLoading) {
                                                context.read<SearchBloc>().add(
                                                    const SearchChangePagingOption(
                                                        true));
                                              }
                                            }),
                                        CustomButton(
                                            text: 'With Index',
                                            isPrimary: !state.isLazyLoading,
                                            onPressed: () {
                                              if (state.isLazyLoading) {
                                                context.read<SearchBloc>().add(
                                                    const SearchChangePagingOption(
                                                        false));
                                              }
                                            }),
                                      ],
                                    );
                                  },
                                ),
                              ]),
                        );

                        // return Container();
                      },
                    ),
                    content:
                        // Container())

                        ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        UserWidget(),
                        IssueWidget(
                          issueState: IssueState.open,
                          imageUrl:
                              'https://avatars.githubusercontent.com/u/150416?v=4',
                        ),
                        IssueWidget(
                            issueState: IssueState.closed,
                            imageUrl:
                                'https://avatars.githubusercontent.com/u/150416?v=4'),
                        IssueWidget(
                            issueState: IssueState.all,
                            imageUrl:
                                'https://avatars.githubusercontent.com/u/150416?v=4'),
                        RepositoryWidget(),
                        // PageIndexWidget(),
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: PageIndexWidget(
        start: 1,
        end: 50,
        current: 48,
      ),
    );
  }
}

class RepositoryWidget extends StatelessWidget {
  const RepositoryWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(
              'https://avatars.githubusercontent.com/u/150416?v=4'),
          // leading: Icon(Icons.abc),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Web based game on Doraemon theme',
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
            ),
          ),
          subtitle: Text('2022-02-28'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_red_eye,
                    size: mQueryWidth(context, size: 0.045),
                    color: Colors.green,
                  ),
                  horizontalSpace(3),
                  Text('80')
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: mQueryWidth(context, size: 0.045),
                    color: Colors.yellow,
                  ),
                  horizontalSpace(3),
                  Text('80K')
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fork_right,
                    size: mQueryWidth(context, size: 0.045),
                    color: Colors.grey,
                  ),
                  horizontalSpace(3),
                  Text('999K')
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum IssueState { open, closed, all }

class IssueWidget extends StatelessWidget {
  final IssueState issueState;
  final String imageUrl;
  const IssueWidget(
      {Key? key, required this.issueState, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String issueString;

    getState(IssueState issue) {
      switch (issue) {
        case IssueState.open:
          {
            color = Colors.green;
            issueString = 'Open';
            break;
          }
        case IssueState.all:
          {
            color = Colors.grey;
            issueString = 'All';
            break;
          }
        case IssueState.closed:
          {
            color = Colors.red;
            issueString = 'Closed';
            break;
          }
      }
    }

    getState(issueState);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(imageUrl),
          // leading: Icon(Icons.abc),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              'Web based game on Doraemon theme',
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
            ),
          ),
          subtitle: Text('2022-02-28'),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: mQueryWidth(context, size: 0.03),
                height: mQueryWidth(context, size: 0.03),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              verticalSpace(5),
              Text(
                issueString,
                textAlign: TextAlign.start,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UserWidget extends StatelessWidget {
  const UserWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(
              'https://avatars.githubusercontent.com/u/150416?v=4'),
          // leading: Icon(Icons.abc),
          title: Text(
            'DafiMjd',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontStyle: FontStyle.normal, fontSize: 30),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}

class SearchTypeWidget extends StatelessWidget {
  final String text;
  final SearchType groupValue;
  final SearchType value;
  const SearchTypeWidget(
      {Key? key,
      required this.text,
      required this.groupValue,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<SearchType>(
          fillColor: MaterialStateProperty.resolveWith((states) {
            // If the button is pressed, return size 40, otherwise 20
            return RADIO_COLOR_DARK;
          }),
          value: value,
          groupValue: groupValue,
          onChanged: (SearchType? value) {
            context
                .read<SearchBloc>()
                .add(SearchChooseType(value ?? this.value));
          },
        ),
        Text(text),
      ],
    );
  }
}
