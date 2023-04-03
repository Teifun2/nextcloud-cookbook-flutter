part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class RecipeLoaded extends RecipeEvent {
  final String recipeId;

  const RecipeLoaded(this.recipeId);

  @override
  List<String> get props => [recipeId];
}

class RecipeUpdated extends RecipeEvent {
  final Recipe recipe;

  const RecipeUpdated(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RecipeCreated extends RecipeEvent {
  final Recipe recipe;

  const RecipeCreated(this.recipe);

  @override
  List<Object> get props => [recipe];
}

class RecipeImported extends RecipeEvent {
  final String url;

  const RecipeImported(this.url);

  @override
  List<Object> get props => [url];
}
