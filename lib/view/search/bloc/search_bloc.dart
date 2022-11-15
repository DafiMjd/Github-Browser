import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:github_browser/data/model/issue.dart';
import 'package:github_browser/data/model/issue_response.dart';
import 'package:github_browser/data/model/repository.dart';
import 'package:github_browser/data/model/repository_response.dart';
import 'package:github_browser/data/model/user.dart';
import 'package:github_browser/data/model/user_response.dart';
import 'package:github_browser/data/repo/github_repository.dart';
import 'package:github_browser/data/search_type.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GithubRepository _postRepo;
  final bool initSearchFieldValue = true,
      initIsLazyLoading = true,
      initHasReachedMax = false;
  final List initList = [];
  final SearchType initSearchType = SearchType.user;

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

  SearchBloc(this._postRepo)
      : super(const SearchInitial(true, SearchType.user, true, [], [], false)) {
    CancelableOperation? _myCancelableFuture;
    int page = 1;
    on<SearchTypeSearchBox>((event, emit) {
      emit(SearchTypingSearchBox(
          event.isSearchFieldEmpty,
          state.type,
          state.isLazyLoading,
          state.lazyItems,
          state.pagingItems,
          state.hasReachedMax));
    });

    on<SearchChooseType>((event, emit) {
      emit(SearchTypeChosen(
          state.isSearchFieldEmpty,
          event.type,
          state.isLazyLoading,
          state.lazyItems,
          state.pagingItems,
          state.hasReachedMax));
    });

    on<SearchChangePagingOption>((event, emit) {
      emit(SearchPagingOptionChanged(
          state.isSearchFieldEmpty,
          state.type,
          event.isLazyLoading,
          state.lazyItems,
          state.pagingItems,
          state.hasReachedMax));
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

    Future<dynamic> _getData(String keyword) async {
      var result = await _postRepo.fetchGithub(
          _getType(state.type), keyword, page.toString());

      return result;
    }

    Future<void> _cancelFuture() async {
      await _myCancelableFuture?.cancel();
          print('fdsa');
    }

    on<SearchFetchItems>((event, emit) async {
      try {
        _myCancelableFuture =
            CancelableOperation.fromFuture(_getData(event.keyword));
        var item = await _myCancelableFuture?.value;

        List items = _getItems(item);

        if (state is SearchInitial) {
          emit(SearchLoaded(state.isSearchFieldEmpty, state.type,
              state.isLazyLoading, items, items, item.nav.next.isEmpty));
        } else {
          emit(SearchLoading(state.isSearchFieldEmpty, state.type,
              state.isLazyLoading, state.lazyItems, state.pagingItems, false));
          // emit(MainLoadingState(posts, isFirstFetch: page == 1));
          // MainLoadedState postLoaded = state as MainLoadedState;
          emit(SearchLoaded(
              state.isSearchFieldEmpty,
              state.type,
              state.isLazyLoading,
              state.lazyItems + items,
              items,
              item.nav.next.isEmpty));
          print('fdsa');
        }

        page++;
      } catch (e) {
        rethrow;
      }
    });

    on<SearchCancelFuture>((event, emit) async {
      _cancelFuture();
      emit(const SearchInitial(true, SearchType.user, true, [], [], false));
    });
  }
}
