part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final bool isSearchFieldEmpty;
  final SearchType type;
  final bool isLazyLoading;
  const SearchState(this.isSearchFieldEmpty, this.type, this.isLazyLoading);

  @override
  List<Object> get props => [isSearchFieldEmpty, type, isLazyLoading];
}

class SearchInitial extends SearchState {
  const SearchInitial(super.isEmpty, super.type, super.isLazyLoading);

  @override
  List<Object> get props => [isSearchFieldEmpty, type, isLazyLoading];
}

class SearchTypingSearchBox extends SearchState {
  const SearchTypingSearchBox(super.isEmpty, super.type, super.isLazyLoading);

  @override
  List<Object> get props => [isSearchFieldEmpty, type, isLazyLoading];
}

class SearchTypeChosen extends SearchState {
  const SearchTypeChosen(super.isEmpty, super.type, super.isLazyLoading);

  @override
  List<Object> get props => [isSearchFieldEmpty, type, isLazyLoading];
}

class SearchPagingOptionChanged extends SearchState {
  const SearchPagingOptionChanged(
      super.isEmpty, super.type, super.isLazyLoading);

  @override
  List<Object> get props => [isSearchFieldEmpty, type, isLazyLoading];
}
