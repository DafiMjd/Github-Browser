part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeTypeSearchBox extends HomeEvent {
  final bool isEmpty;

  const HomeTypeSearchBox(this.isEmpty);
  
  @override
  List<Object> get props => [isEmpty];
}
