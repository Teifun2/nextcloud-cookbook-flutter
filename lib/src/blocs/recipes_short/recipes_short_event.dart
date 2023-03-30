part of 'recipes_short_bloc.dart';

abstract class RecipesShortEvent extends Equatable {
  const RecipesShortEvent();

  @override
  List<Object> get props => [];
}

class RecipesShortLoaded extends RecipesShortEvent {
  final String category;

  const RecipesShortLoaded({required this.category});

  @override
  List<String> get props => [category];
}

class RecipesShortLoadedAll extends RecipesShortEvent {}
