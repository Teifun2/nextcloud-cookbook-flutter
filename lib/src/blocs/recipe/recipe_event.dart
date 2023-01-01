import 'package:equatable/equatable.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object?> get props => [];
}

class RecipeLoaded extends RecipeEvent {
  final int recipeId;

  const RecipeLoaded(this.recipeId);

  @override
  List<int> get props => [recipeId];
}

class RecipeUpdated extends RecipeEvent {
  final Recipe recipe;

  const RecipeUpdated(this.recipe);

  @override
  List<Recipe> get props => [recipe];
}

class RecipeCreated extends RecipeEvent {
  final Recipe recipe;

  const RecipeCreated(this.recipe);

  @override
  List<Recipe> get props => [recipe];
}

class RecipeImported extends RecipeEvent {
  final String url;

  const RecipeImported(this.url);

  @override
  List<String> get props => [url];
}
