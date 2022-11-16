part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final bool isSearchFieldEmpty;
  final SearchType type;
  final bool isLazyLoading;
  final List<dynamic> lazyItems;
  final List<dynamic> pagingItems;
  final bool hasReachedMax;
  final String keyword;
  final IndexNavigation nav;
  const SearchState(
      this.isSearchFieldEmpty,
      this.type,
      this.isLazyLoading,
      this.lazyItems,
      this.pagingItems,
      this.hasReachedMax,
      this.keyword,
      this.nav,
      );

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword,
        nav,
        
      ];
}

class SearchInitial extends SearchState {
  const SearchInitial(
      super.isSearchFieldEmpty,
      super.type,
      super.isLazyLoading,
      super.lazyItems,
      super.pagingItems,
      super.hasReachedMax,
      super.keyword,
      super.nav,
      );

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword,
        nav,
        
      ];
}

class SearchTypingSearchBox extends SearchState {
  const SearchTypingSearchBox(
      super.isSearchFieldEmpty,
      super.type,
      super.isLazyLoading,
      super.lazyItems,
      super.pagingItems,
      super.hasReachedMax,
      super.keyword,
      super.nav,
      );

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword,
        nav,
        
      ];
}

class SearchTypeChosen extends SearchState {
  const SearchTypeChosen(
      super.isSearchFieldEmpty,
      super.type,
      super.isLazyLoading,
      super.lazyItems,
      super.pagingItems,
      super.hasReachedMax,
      super.keyword,
      super.nav,
      );

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword,
        nav,
        
      ];
}

class SearchPagingOptionChanged extends SearchState {
  const SearchPagingOptionChanged(
      super.isSearchFieldEmpty,
      super.type,
      super.isLazyLoading,
      super.lazyItems,
      super.pagingItems,
      super.hasReachedMax,
      super.keyword,
      super.nav,
      );

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword,
        nav,
        
      ];
}

class SearchLoading extends SearchState {
  const SearchLoading(
    super.isSearchFieldEmpty,
    super.type,
    super.isLazyLoading,
    super.lazyItems,
    super.pagingItems,
    super.hasReachedMax,
    super.keyword,
    super.nav,
  
  );

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword,
        nav,
        
      ];
}

class SearchLoaded extends SearchState {
  const SearchLoaded(
      super.isSearchFieldEmpty,
      super.type,
      super.isLazyLoading,
      super.lazyItems,
      super.pagingItems,
      super.hasReachedMax,
      super.keyword,
      super.nav,
      );

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword,
        nav,
        
      ];
}


class SearchFetchFailed extends SearchState {
  final String error;
  const SearchFetchFailed(
    super.isSearchFieldEmpty,
    super.type,
    super.isLazyLoading,
    super.lazyItems,
    super.pagingItems,
    super.hasReachedMax,
    super.keyword,
    super.nav,
    this.error,
  );

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword,
        nav,
        error,
        
      ];
}
