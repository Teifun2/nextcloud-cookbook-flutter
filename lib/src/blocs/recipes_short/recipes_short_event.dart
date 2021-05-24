import 'package:equatable/equatable.dart';

abstract class RecipesShortEvent extends Equatable {
  const RecipesShortEvent();

  @override
  List<Object> get props => [];
}

class RecipesShortLoaded extends RecipesShortEvent {
  final String category;

  const RecipesShortLoaded({this.category});

  @override
  List<Object> get props => [category];
}

class RecipesShortLoadedAll extends RecipesShortEvent {}
