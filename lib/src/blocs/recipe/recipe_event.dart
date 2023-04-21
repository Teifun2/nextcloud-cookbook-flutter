part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class RecipeLoaded extends RecipeEvent {
  const RecipeLoaded(this.recipeId);
  final String recipeId;

  @override
  List<String> get props => [recipeId];
}

class RecipeUpdated extends RecipeEvent {
  const RecipeUpdated(this.recipe);
  final Recipe recipe;

  @override
  List<Object> get props => [recipe];
}

class RecipeCreated extends RecipeEvent {
  const RecipeCreated(this.recipe);
  final Recipe recipe;

  @override
  List<Object> get props => [recipe];
}

class RecipeImported extends RecipeEvent {
  const RecipeImported(this.url);
  final String url;

  @override
  List<Object> get props => [url];
}

class RecipeDeleted extends RecipeEvent {
  const RecipeDeleted(this.recipe);
  final Recipe recipe;

  @override
  List<Object> get props => [recipe];
}
