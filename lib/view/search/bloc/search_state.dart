part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  final bool isSearchFieldEmpty;
  final SearchType type;
  const SearchState(this.isSearchFieldEmpty, this.type);

  @override
  List<Object> get props => [isSearchFieldEmpty, type];
}

class SearchInitial extends SearchState {

  const SearchInitial(super.isEmpty, super.type);


  @override
  List<Object> get props => [isSearchFieldEmpty, type];
}

class SearchTypingSearchBox extends SearchState {

  const SearchTypingSearchBox(super.isEmpty, super.type);


  @override
  List<Object> get props => [isSearchFieldEmpty, type];
}

class SearchTypeChosen extends SearchState {

  const SearchTypeChosen(super.isEmpty, super.type);

  @override
  List<Object> get props => [isSearchFieldEmpty, type];
}
