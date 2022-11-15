import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_browser/data/model/issue_response.dart';
import 'package:github_browser/data/model/repository_response.dart';
import 'package:github_browser/data/model/user.dart';
import 'package:github_browser/data/model/user_response.dart';
import 'package:github_browser/data/search_type.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:github_browser/utils/global_function.dart';
import 'package:github_browser/view/search/bloc/search_bloc.dart';
import 'package:github_browser/widget/custom_button.dart';
import 'package:github_browser/view/search/page_index_widget.dart';
import 'package:github_browser/widget/search_box.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SearchPage extends StatefulWidget {
  String keyword;
  SearchPage({Key? key, required this.keyword}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final scrollController = ScrollController();
  late TextEditingController searchCtrl;
  bool hasReachedMax = false;
  bool isLazyLoading = true;

  void setupScrollController(context, keyword) {
    scrollController.addListener(() {
      var maxScroll = scrollController.position.maxScrollExtent;
      var position = scrollController.position.pixels;
      if (maxScroll == position && !hasReachedMax && isLazyLoading) {
        BlocProvider.of<SearchBloc>(context).add(SearchFetchItems(keyword));
      }
    });
  }

  void _scrollTop() {
    try {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    } catch (e) {
      return;
    }
  }

  @override
  void initState() {
    setupScrollController(context, widget.keyword);
    BlocProvider.of<SearchBloc>(context).add(SearchFetchItems(widget.keyword));
    searchCtrl = TextEditingController(text: widget.keyword);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    bool isDark = mode.brightness == Brightness.dark;
    return WillPopScope(
      onWillPop: () async {
        context.read<SearchBloc>().add(SearchCancelFuture());
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      return Visibility(
                          visible: !state.isSearchFieldEmpty,
                          child: IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () {
                              searchCtrl.text = '';
                              context
                                  .read<SearchBloc>()
                                  .add(SearchTypeSearchBox(true));
                            },
                          ));
                    },
                  ),
                  verticalSpace(10),
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      late bool enabled;
                      if (state is SearchLoading) {
                        enabled = false;
                      } else {
                        enabled = true;
                      }
                      if (state.hasReachedMax) hasReachedMax = true;
                      late List items;
                      if (state.isLazyLoading) {
                        items = state.lazyItems;
                        isLazyLoading = true;
                      } else {
                        _scrollTop();
                        items = state.pagingItems;
                        isLazyLoading = false;
                      }
                      bool isItemsEmpty = items.isEmpty;

                      return StickyHeader(
                          header: Container(
                            color: isDark
                                ? darkTheme.canvasColor
                                : lightTheme.canvasColor,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  _typeWidget(state, enabled),
                                  _paginType(state, context, enabled)
                                ]),
                          ),
                          content: (state is SearchLoading ||
                                  state is SearchInitial)
                              ? _loadingIndicator()
                              : (isItemsEmpty)
                                  ? Text('No Data')
                                  : ListView.builder(
                                      itemCount: state.hasReachedMax ||
                                              !state.isLazyLoading
                                          ? items.length
                                          : items.length + 1,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) => (index <
                                              items.length)
                                          ? _getItem(state.type, items[index])
                                          : _loadingIndicator()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: const PageIndexWidget(
          start: 1,
          end: 50,
          current: 41,
        ),
      ),
    );
  }

  Row _paginType(SearchState state, BuildContext context, bool enabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      // mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment:
      //     MainAxisAlignment.spaceB,
      children: [
        CustomButton(
          text: 'Lazy Loading',
          isPrimary: state.isLazyLoading,
          onPressed: () {
            if (!state.isLazyLoading) {
              context
                  .read<SearchBloc>()
                  .add(const SearchChangePagingOption(true));
            }
          },
          enabled: enabled,
        ),
        CustomButton(
          text: 'With Index',
          isPrimary: !state.isLazyLoading,
          onPressed: () {
            if (state.isLazyLoading) {
              context
                  .read<SearchBloc>()
                  .add(const SearchChangePagingOption(false));
            }
          },
          enabled: enabled,
        ),
      ],
    );
  }

  Widget _loadingIndicator() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Center(child: CircularProgressIndicator()));
  }

  Container _typeWidget(SearchState state, bool enabled) {
    return Container(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchTypeWidget(
              text: 'Users',
              groupValue: state.type,
              enabled: enabled,
              value: SearchType.user,
            ),
            SearchTypeWidget(
              text: 'Issues',
              groupValue: state.type,
              enabled: enabled,
              value: SearchType.issue,
            ),
            SearchTypeWidget(
              text: 'Repositories',
              groupValue: state.type,
              enabled: enabled,
              value: SearchType.repository,
            ),
          ],
        ),
      ),
    );
  }

  _getItem(SearchType type, item) {
    switch (type) {
      case SearchType.user:
        return UserWidget(
          user: item,
        );
      case SearchType.issue:
        return IssueWidget(issue: item);
      case SearchType.repository:
        return RepositoryWidget(repo: item);
    }
  }
}

class RepositoryWidget extends StatelessWidget {
  final RepositoryResponse repo;
  const RepositoryWidget({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(repo.imageUrl),
          // leading: Icon(Icons.abc),
          title: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              repo.name,
              style: Theme.of(context).textTheme.titleSmall,
              maxLines: 2,
            ),
          ),
          subtitle: Text(repo.createdAt),
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
                    size: mQueryWidth(context, size: 0.04),
                    color: Colors.green,
                  ),
                  horizontalSpace(3),
                  Text(repo.watcher.toString())
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star,
                    size: mQueryWidth(context, size: 0.04),
                    color: Colors.yellow,
                  ),
                  horizontalSpace(3),
                  Text(repo.star.toString())
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fork_right,
                    size: mQueryWidth(context, size: 0.04),
                    color: Colors.grey,
                  ),
                  horizontalSpace(3),
                  Text(repo.fork.toString())
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
  final IssueResponse issue;
  const IssueWidget({Key? key, required this.issue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String issueString;

    getState(String state) {
      switch (state) {
        case 'open':
          {
            color = Colors.green;
            issueString = 'Open';
            break;
          }
        case 'all':
          {
            color = Colors.grey;
            issueString = 'All';
            break;
          }
        case 'closed':
          {
            color = Colors.red;
            issueString = 'Closed';
            break;
          }
      }
    }

    getState(issue.state);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(issue.imageUrl),
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
  final UserResponse user;
  const UserWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: Image.network(user.imageUrl),
          // leading: Icon(Icons.abc),
          title: Text(
            user.username,
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
  final bool enabled;
  const SearchTypeWidget(
      {Key? key,
      required this.text,
      required this.groupValue,
      required this.value,
      required this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<SearchType>(
          value: value,
          groupValue: groupValue,
          onChanged: enabled
              ? (SearchType? value) {
                  context
                      .read<SearchBloc>()
                      .add(SearchChooseType(value ?? this.value));
                }
              : null,
        ),
        Text(text),
      ],
    );
  }
}
