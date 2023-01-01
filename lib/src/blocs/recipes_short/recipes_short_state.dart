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

  const RecipesShortLoadSuccess(this.recipesShort);

  @override
  List<RecipeShort> get props => recipesShort;

  @override
  String toString() => 'RecipesShortLoadSuccess { recipes: $recipesShort }';
}

class RecipesShortLoadAllSuccess extends RecipesShortState {
  final List<RecipeShort> recipesShort;

  const RecipesShortLoadAllSuccess(this.recipesShort);

  @override
  List<RecipeShort> get props => recipesShort;

  @override
  String toString() => 'RecipesShortLoadAllSuccess { recipes: $recipesShort }';
}

class RecipesShortLoadAllFailure extends RecipesShortState {
  final String errorMsg;

  const RecipesShortLoadAllFailure(this.errorMsg);

  @override
  List<String> get props => [errorMsg];
}

class RecipesShortLoadAllInProgress extends RecipesShortState {}
