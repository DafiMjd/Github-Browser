part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final bool isSearchFieldEmpty;
  final SearchType type;
  final bool isLazyLoading;
  final List<dynamic> lazyItems;
  final List<dynamic> pagingItems;
  final bool hasReachedMax;
  const SearchState(this.isSearchFieldEmpty, this.type, this.isLazyLoading,
      this.lazyItems, this.pagingItems, this.hasReachedMax);

  @override
  List<Object> get props =>
      [isSearchFieldEmpty, type, isLazyLoading, lazyItems, pagingItems, hasReachedMax];
}

class SearchInitial extends SearchState {
  const SearchInitial(super.isEmpty, super.type, super.isLazyLoading,
      super.items, super.pagingItems, super.hasReachedMax);

  @override
  List<Object> get props =>
      [isSearchFieldEmpty, type, isLazyLoading, lazyItems, pagingItems, hasReachedMax];
}

class SearchTypingSearchBox extends SearchState {
  const SearchTypingSearchBox(super.isEmpty, super.type, super.isLazyLoading,
      super.items, super.pagingItems, super.hasReachedMax);

  @override
  List<Object> get props =>
      [isSearchFieldEmpty, type, isLazyLoading, lazyItems, pagingItems, hasReachedMax];
}

class SearchTypeChosen extends SearchState {
  const SearchTypeChosen(super.isEmpty, super.type, super.isLazyLoading,
      super.items, super.pagingItems, super.hasReachedMax);

  @override
  List<Object> get props =>
      [isSearchFieldEmpty, type, isLazyLoading, lazyItems, pagingItems, hasReachedMax];
}

class SearchPagingOptionChanged extends SearchState {
  const SearchPagingOptionChanged(super.isEmpty, super.type,
      super.isLazyLoading, super.items, super.pagingItems, super.hasReachedMax);

  @override
  List<Object> get props =>
      [isSearchFieldEmpty, type, isLazyLoading, lazyItems, pagingItems, hasReachedMax];
}

class SearchLoading extends SearchState {
  const SearchLoading(super.isEmpty, super.type, super.isLazyLoading,
      super.items, super.pagingItems, super.hasReachedMax);

  @override
  List<Object> get props =>
      [isSearchFieldEmpty, type, isLazyLoading, lazyItems, pagingItems, hasReachedMax];
}

class SearchLoaded extends SearchState {
  const SearchLoaded(super.isEmpty, super.type, super.isLazyLoading,
      super.items, super.pagingItems, super.hasReachedMax);

  @override
  List<Object> get props =>
      [isSearchFieldEmpty, type, isLazyLoading, lazyItems, pagingItems, hasReachedMax];

  // SearchLoaded copywith({List<dynamic>? items, bool? hasReachedMax}) {
  //   return SearchLoaded(isSearchFieldEmpty, type, isLazyLoading,
  //       items ?? this.lazyItems, hasReachedMax ?? this.hasReachedMax);
  // }
}
