import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_browser/data/search_type.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial(true,SearchType.repository,true)) {
    on<SearchTypeSearchBox>((event, emit) {
      emit(SearchTypingSearchBox(event.isSearchFieldEmpty, state.type, state.isLazyLoading));
    });

    on<SearchChooseType>((event, emit) {
      emit(SearchTypeChosen(state.isSearchFieldEmpty, event.type, state.isLazyLoading));

    });

    on<SearchChangePagingOption>((event, emit) {
      emit(SearchPagingOptionChanged(state.isSearchFieldEmpty, state.type, event.isLazyLoading));

    });
  }
}
