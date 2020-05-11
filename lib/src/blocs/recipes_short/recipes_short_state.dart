import 'package:equatable/equatable.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';

abstract class RecipesShortState extends Equatable {
  const RecipesShortState();

  @override
  List<Object> get props => [];
}

class RecipesShortLoadInProgress extends RecipesShortState {}

class RecipesShortLoadFailure extends RecipesShortState {}

class RecipesShortLoadSuccess extends RecipesShortState {
  final List<RecipeShort> recipesShort;

  const RecipesShortLoadSuccess([this.recipesShort = const []]);

  @override
  List<Object> get props => [recipesShort];

  @override
  String toString() => 'RecipesShortLoadSuccess { todos: $recipesShort }';
}