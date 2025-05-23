import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_browser/data/model/index_navigation.dart';
import 'package:github_browser/data/model/issue_response.dart';
import 'package:github_browser/data/model/repository_response.dart';
import 'package:github_browser/data/model/user_response.dart';
import 'package:github_browser/data/repo/github_repository.dart';
import 'package:github_browser/data/search_type.dart';
import 'package:url_launcher/url_launcher.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GithubRepository _postRepo;

  SearchBloc(this._postRepo)
      : super(SearchInitial(true, SearchType.user, true, const [], const [],
            false, '', IndexNavigation('', '', '', '', ''))) {
    int page = 1;
    on<SearchTypeSearchBox>((event, emit) {
      emit(SearchTypingSearchBox(
        event.isSearchFieldEmpty,
        state.type,
        state.isLazyLoading,
        state.lazyItems,
        state.pagingItems,
        state.hasReachedMax,
        state.keyword,
        state.nav,
      ));
    });

    on<SearchChooseType>((event, emit) {
      page = 1;
      emit(SearchTypeChosen(
          state.isSearchFieldEmpty,
          event.type,
          state.isLazyLoading,
          const [],
          const [],
          state.hasReachedMax,
          state.keyword,
          state.nav));

      add(SearchFetchItems(state.keyword));
    });

    on<SearchChangePagingOption>((event, emit) {
      emit(SearchPagingOptionChanged(
          state.isSearchFieldEmpty,
          state.type,
          event.isLazyLoading,
          state.lazyItems,
          state.pagingItems,
          state.hasReachedMax,
          state.keyword,
          state.nav));
    });

    List<dynamic> _getItems(item) {
      switch (state.type) {
        case SearchType.user:
          return item.users as List<UserResponse>;
        case SearchType.issue:
          return item.issues as List<IssueResponse>;
        case SearchType.repository:
          return item.repositories as List<RepositoryResponse>;
      }
    }

    String _getType(SearchType type) {
      switch (type) {
        case SearchType.user:
          return 'users';
        case SearchType.issue:
          return 'issues';
        case SearchType.repository:
          return 'repositories';
      }
    }

    Future<dynamic> _getData(
      String keyword,
      SearchType type,
    ) async {
      try {
        var result = await _postRepo.fetchGithub(
            _getType(type), keyword, page.toString());

        return result;
      } catch (e) {
        if (e == 'limit-excedeed') {
          add(const SearchFetchFail('API limit call has been exceeded'));
        } else if (e == 'offline') {
          add(const SearchFetchFail('You are offline, check your connection'));
        }
        // rethrow;
      }
    }

    on<SearchFetchItems>((event, emit) async {
      // if keyword, page, type, exist in cache
      // return cache
      // else do below
      try {
        if (state is SearchInitial) {
          emit(SearchLoading(
              state.isSearchFieldEmpty,
              state.type,
              state.isLazyLoading,
              state.lazyItems,
              state.pagingItems,
              false,
              event.keyword,
              state.nav));
          var item = await _getData(event.keyword, state.type)
              .onError((error, stackTrace) {
            return;
          });

          List items = _getItems(item);
          emit(SearchLoaded(
              state.isSearchFieldEmpty,
              state.type,
              state.isLazyLoading,
              items,
              items,
              item.nav.next.isEmpty,
              state.keyword,
              item.nav));
        } else {
          bool isSameKeyword = true;
          if (event.keyword != state.keyword) {
            page = 1;
            isSameKeyword = false;
          }

          var item = await _getData(event.keyword, state.type)
              .onError((error, stackTrace) {
            // return;
          });
          List items = _getItems(item);
          late List lazyItems;
          late String keyword;

          if (!isSameKeyword) {
            page = 1;
            lazyItems = items;
            keyword = event.keyword;
          } else {
            lazyItems = state.lazyItems + items;
            keyword = state.keyword;
          }

          emit(SearchLoading(
              state.isSearchFieldEmpty,
              state.type,
              state.isLazyLoading,
              state.lazyItems,
              state.pagingItems,
              false,
              keyword,
              item.nav));

          emit(SearchLoaded(
              state.isSearchFieldEmpty,
              state.type,
              state.isLazyLoading,
              lazyItems,
              items,
              item.nav.next.isEmpty,
              keyword,
              item.nav));
        }

        page++;
      } catch (e) {
        rethrow;
      }
    });

    on<SearchGoToPage>((event, emit) {
      page = event.page;
      emit(SearchLoading(
          state.isSearchFieldEmpty,
          state.type,
          state.isLazyLoading,
          state.lazyItems,
          state.pagingItems,
          false,
          state.keyword,
          state.nav));
      add(SearchFetchItems(state.keyword));
    });

    on<SearchFetchFail>((event, emit) {
      emit(SearchFetchFailed(
          state.isSearchFieldEmpty,
          state.type,
          state.isLazyLoading,
          state.lazyItems,
          state.pagingItems,
          state.hasReachedMax,
          state.keyword,
          state.nav,
          event.error));
    });

    on<SearchOpenUrl>((event, emit) async {
      try {
        await launchUrl(Uri.parse(event.url));
      } catch (e) {
        emit(SearchFetchFailed(
            state.isSearchFieldEmpty,
            state.type,
            state.isLazyLoading,
            state.lazyItems,
            state.pagingItems,
            state.hasReachedMax,
            state.keyword,
            state.nav,
            'Could not open URL'));
      }
    });
  }
}
