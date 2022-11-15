part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeTypingSearchBox extends HomeState {
  final bool isEmpty;

  const HomeTypingSearchBox(this.isEmpty);
  
  @override
  List<Object> get props => [isEmpty];
}

