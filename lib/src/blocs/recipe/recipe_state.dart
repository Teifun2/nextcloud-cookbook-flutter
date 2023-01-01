import 'package:equatable/equatable.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object?> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeFailure extends RecipeState {
  final String errorMsg;

  const RecipeFailure(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}

class RecipeSuccess extends RecipeState {
  final Recipe recipe;

  const RecipeSuccess(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RecipeLoadSuccess extends RecipeSuccess {
  const RecipeLoadSuccess(super.recipe);
}

class RecipeLoadFailure extends RecipeFailure {
  const RecipeLoadFailure(super.errorMsg);
}

class RecipeLoadInProgress extends RecipeState {}

class RecipeUpdateFailure extends RecipeFailure {
  const RecipeUpdateFailure(super.errorMsg);
}

class RecipeUpdateSuccess extends RecipeState {
  final int recipeId;

  const RecipeUpdateSuccess(this.recipeId);

  @override
  List<int> get props => [recipeId];
}

class RecipeUpdateInProgress extends RecipeState {}

class RecipeCreateFailure extends RecipeFailure {
  const RecipeCreateFailure(super.errorMsg);
}

class RecipeCreateSuccess extends RecipeState {
  final int recipeId;

  const RecipeCreateSuccess(this.recipeId);

  @override
  List<Object> get props => [recipeId];
}

class RecipeCreateInProgress extends RecipeState {}

class RecipeImportSuccess extends RecipeState {
  final int recipeId;

  const RecipeImportSuccess(this.recipeId);

  @override
  List<int> get props => [recipeId];
}

class RecipeImportFailure extends RecipeFailure {
  const RecipeImportFailure(super.errorMsg);
}

class RecipeImportInProgress extends RecipeState {}
