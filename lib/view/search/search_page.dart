import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:github_browser/data/model/issue_response.dart';
import 'package:github_browser/data/model/repository_response.dart';
import 'package:github_browser/data/model/user_response.dart';
import 'package:github_browser/data/search_type.dart';
import 'package:github_browser/style/theme_constant.dart';
import 'package:github_browser/utils/global_function.dart';
import 'package:github_browser/view/search/bloc/search_bloc.dart';
import 'package:github_browser/widget/custom_button.dart';
import 'package:github_browser/view/search/page_index_widget.dart';
import 'package:github_browser/widget/search_box.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sticky_headers/sticky_headers.dart';

class SearchPage extends StatefulWidget {
  final String firstKeyword;
  const SearchPage({Key? key, required this.firstKeyword}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final scrollController = ScrollController();
  late TextEditingController searchCtrl;
  bool hasReachedMax = false;
  bool isLazyLoading = true;
  late String keyword;
  late FocusNode myFocusNode; // activate textfield

  void setupScrollController(context) {
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
    keyword = widget.firstKeyword;
    setupScrollController(context);
    BlocProvider.of<SearchBloc>(context)
        .add(SearchFetchItems(widget.firstKeyword));
    searchCtrl = TextEditingController(text: widget.firstKeyword);
    myFocusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(() {});
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    bool isDark = mode.brightness == Brightness.dark;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: BlocConsumer<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is SearchFetchFailed) {
              // _showDialog(context, state.error);
              Fluttertoast.showToast(msg: state.error);
            }
          },
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
            return Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        InkWell(
                          highlightColor: FOCURS_COLOR,
                          splashColor: FOCURS_COLOR,
                          focusColor: FOCURS_COLOR,
                          onTap: () {
                            if (searchCtrl.text.isNotEmpty) {
                              context
                                  .read<SearchBloc>()
                                  .add(const SearchTypeSearchBox(false));
                            }
                            myFocusNode.requestFocus();
                          },
                          child: SearchBox(
                              submit: (value) {
                                keyword = value;
                                if (value.isNotEmpty) {
                                  context
                                      .read<SearchBloc>()
                                      .add(SearchFetchItems(searchCtrl.text));
                                }
                              },
                              onChanged: (value) {
                                keyword = value;
                                context
                                    .read<SearchBloc>()
                                    .add(SearchTypeSearchBox(value.isEmpty));
                              },
                              trailing: Visibility(
                                  visible: !state.isSearchFieldEmpty,
                                  child: IconButton(
                                    icon: const Icon(Icons.cancel),
                                    onPressed: () {
                                      searchCtrl.text = '';
                                      keyword = '';
                                      context
                                          .read<SearchBloc>()
                                          .add(const SearchTypeSearchBox(true));
                                    },
                                  )),
                              ctrl: searchCtrl,
                              enabled: enabled,
                              focusNode: myFocusNode),
                        ),
                        verticalSpace(10),
                        StickyHeader(
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
                            content:
                                // _loadingIndicator());
                                (state is SearchLoading ||
                                        state is SearchInitial ||
                                        state is SearchTypeChosen)
                                    ? _loadingIndicator()
                                    : (isItemsEmpty)
                                        ? _noData()
                                        : RepaintBoundary(
                                            child: ListView.builder(
                                                itemCount:
                                                    state.hasReachedMax ||
                                                            !state.isLazyLoading
                                                        ? items.length
                                                        : items.length + 1,
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) =>
                                                    (index < items.length)
                                                        ? _getItem(state.type,
                                                            items[index])
                                                        : _loadingCircularIndicator()),
                                          )),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Visibility(
                visible: !state.isLazyLoading &&
                    state.lazyItems.isNotEmpty &&
                    state.pagingItems.isNotEmpty,
                child: PageIndexWidget(
                  start:
                      state.nav.first.isEmpty ? 0 : int.parse(state.nav.first),
                  end: state.nav.last.isEmpty ? 0 : int.parse(state.nav.last),
                  current: state.nav.current.isEmpty
                      ? 0
                      : int.parse(state.nav.current),
                  prev: state.nav.prev.isEmpty ? 0 : int.parse(state.nav.prev),
                  next: state.nav.next.isEmpty ? 0 : int.parse(state.nav.next),
                  enabled: enabled,
                ),
              ),
            );
          },
        ));
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

  Widget _loadingCircularIndicator() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Center(child: CircularProgressIndicator()));
  }

  Widget _loadingIndicator() {
    // return const Padding(
    //     padding: EdgeInsets.all(8),
    //     child: Center(child: CircularProgressIndicator()));

    // Padding(padding: EdgeInsets.all(8), child: Shimmer(),)

    return RepaintBoundary(
      child: Shimmer.fromColors(
        baseColor: SKELETON_COLOR,
        highlightColor: SKELETON_HIGHLIGHT_COLOR,
        // enabled: _enabled,
        child: ListView.builder(
          shrinkWrap: true,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: _loadingImage(),
              title: Container(
                width: double.maxFinite,
                height: 10,
                color: SKELETON_HIGHLIGHT_COLOR,
              ),
              subtitle: Container(
                width: double.maxFinite,
                height: 10,
                color: SKELETON_HIGHLIGHT_COLOR,
              ),
            ),
          ),
          itemCount: 15,
        ),
      ),
    );
  }

  Container _loadingImage() {
    return Container(
      width: 60,
      height: 60,
      color: SKELETON_HIGHLIGHT_COLOR,
    );
  }

  Widget _noData() {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
            child: Text('No Data',
                style: Theme.of(context).textTheme.titleMedium)));
  }

  Container _typeWidget(SearchState state, bool enabled) {
    return Container(
      alignment: Alignment.centerLeft,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: RepaintBoundary(
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
      ),
    );
  }

  _getItem(SearchType type, item) {
    switch (type) {
      case SearchType.user:
        return UserWidget(
          user: item,
          tap: () {
            context
                .read<SearchBloc>()
                .add(SearchOpenUrl(item.url));
          },
        );
      case SearchType.issue:
        return IssueWidget(
          issue: item,
          tap: () {
            context
                .read<SearchBloc>()
                .add(SearchOpenUrl(item.url));
          },
        );
      case SearchType.repository:
        return RepositoryWidget(
          repo: item,
          tap: () {
            context
                .read<SearchBloc>()
                .add(SearchOpenUrl(item.url));
          },
        );
    }
  }
}

class RepositoryWidget extends StatelessWidget {
  final RepositoryResponse repo;
  final VoidCallback tap;
  const RepositoryWidget({Key? key, required this.repo, required this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(
              repo.imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return loadingImage();
              },
              // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
              //     _loadingImage(),
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/images/no_image.png'),
            ),
            // leading: Icon(Icons.abc),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                repo.name,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
              ),
            ),
            subtitle: Text(dateFormat(repo.createdAt)),
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
                      color: WATCHER_ICON_COLOR,
                    ),
                    horizontalSpace(3),
                    Text(numberFormat(repo.watcher.toDouble(), 0))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.star,
                      size: mQueryWidth(context, size: 0.04),
                      color: STAR_ICON_COLOR,
                    ),
                    horizontalSpace(3),
                    Text(numberFormat(repo.star.toDouble(), 0))
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.fork_right,
                      size: mQueryWidth(context, size: 0.04),
                      color: ALL_STATE_COLOR,
                    ),
                    horizontalSpace(3),
                    Text(numberFormat(repo.fork.toDouble(), 0))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum IssueState { open, closed, all }

class IssueWidget extends StatelessWidget {
  final IssueResponse issue;
  final VoidCallback tap;
  const IssueWidget({Key? key, required this.issue, required this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Color color;
    late String issueString;

    getState(String state) {
      switch (state) {
        case 'open':
          {
            color = OPEN_STATE_COLOR;
            issueString = 'Open';
            break;
          }
        case 'all':
          {
            color = ALL_STATE_COLOR;
            issueString = 'All';
            break;
          }
        case 'closed':
          {
            color = CLOSED_STATE_COLOR;
            issueString = 'Closed';
            break;
          }
      }
    }

    getState(issue.state);

    return InkWell(
      onTap: tap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(
              issue.imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return loadingImage();
              },
              // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
              //     _loadingImage(),
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/images/no_image.png'),
            ),
            // leading: Icon(Icons.abc),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                issue.title,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 2,
              ),
            ),
            subtitle: Text(dateFormat(issue.updatedAt)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: mQueryWidth(context, size: 0.03),
                  height: mQueryWidth(context, size: 0.03),
                  decoration:
                      BoxDecoration(color: color, shape: BoxShape.circle),
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
      ),
    );
  }
}

class UserWidget extends StatelessWidget {
  final UserResponse user;
  final VoidCallback tap;
  const UserWidget({Key? key, required this.user, required this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Image.network(
              user.imageUrl,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return loadingImage();
              },
              // frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
              //     _loadingImage(),
              errorBuilder: (context, error, stackTrace) =>
                  Image.asset('assets/images/no_image.png'),
            ),
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
