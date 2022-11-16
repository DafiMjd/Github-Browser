part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final bool isSearchFieldEmpty;
  final SearchType type;
  final bool isLazyLoading;
  final List<dynamic> lazyItems;
  final List<dynamic> pagingItems;
  final bool hasReachedMax;
  final String keyword;
  const SearchState(this.isSearchFieldEmpty, this.type, this.isLazyLoading,
      this.lazyItems, this.pagingItems, this.hasReachedMax, this.keyword);

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword
      ];
}

class SearchInitial extends SearchState {
  const SearchInitial(super.isSearchFieldEmpty, super.type, super.isLazyLoading,
      super.lazyItems, super.pagingItems, super.hasReachedMax, super.keyword);

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword
      ];
}

class SearchTypingSearchBox extends SearchState {
  const SearchTypingSearchBox(
      super.isSearchFieldEmpty,
      super.type,
      super.isLazyLoading,
      super.lazyItems,
      super.pagingItems,
      super.hasReachedMax, super.keyword);

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword
      ];
}

class SearchTypeChosen extends SearchState {
  const SearchTypeChosen(
      super.isSearchFieldEmpty,
      super.type,
      super.isLazyLoading,
      super.lazyItems,
      super.pagingItems,
      super.hasReachedMax, super.keyword);

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword
      ];
}

class SearchPagingOptionChanged extends SearchState {
  const SearchPagingOptionChanged(
      super.isSearchFieldEmpty,
      super.type,
      super.isLazyLoading,
      super.lazyItems,
      super.pagingItems,
      super.hasReachedMax, super.keyword);

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword
      ];
}

class SearchLoading extends SearchState {
  const SearchLoading(
    super.isSearchFieldEmpty,
    super.type,
    super.isLazyLoading,
    super.lazyItems,
    super.pagingItems,
    super.hasReachedMax, super.keyword,
  );

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword
      ];
}

class SearchLoaded extends SearchState {
  const SearchLoaded(super.isSearchFieldEmpty, super.type, super.isLazyLoading,
      super.lazyItems, super.pagingItems, super.hasReachedMax, super.keyword);

  @override
  List<Object> get props => [
        isSearchFieldEmpty,
        type,
        isLazyLoading,
        lazyItems,
        pagingItems,
        hasReachedMax,
        keyword
      ];

  // SearchLoaded copywith({List<dynamic>? items, bool? hasReachedMax}) {
  //   return SearchLoaded(isSearchFieldEmpty, type, isLazyLoading,
  //       items ?? this.lazyItems, hasReachedMax ?? this.hasReachedMax);
  // }
}
