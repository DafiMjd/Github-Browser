part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchTypeSearchBox extends SearchEvent {
  final bool isSearchFieldEmpty;

  const SearchTypeSearchBox(this.isSearchFieldEmpty);

  @override
  List<Object> get props => [isSearchFieldEmpty];
}

class SearchChooseType extends SearchEvent {
  final SearchType type;

  const SearchChooseType(this.type);

  @override
  List<Object> get props => [type];
}

class SearchChangePagingOption extends SearchEvent {
  final bool isLazyLoading;

  const SearchChangePagingOption(this.isLazyLoading);

  @override
  List<Object> get props => [isLazyLoading];
}

class SearchFetchItems extends SearchEvent {
  final String keyword;

  const SearchFetchItems(this.keyword);
}

class SearchCancelFuture extends SearchEvent {}

class SearchGoToPage extends SearchEvent {
  final int page;

  const SearchGoToPage(this.page);
}


class SearchFetchFail extends SearchEvent {
  final String error;


  const SearchFetchFail(this.error);
}
