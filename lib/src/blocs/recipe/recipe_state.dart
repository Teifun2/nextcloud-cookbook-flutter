part of 'recipe_bloc.dart';

enum RecipeStatus {
  loadSuccess,
  loadFailure,
  loadInProgress,
  updateFailure,
  updateInProgress,
  updateSuccess,
  createFailure,
  createSuccess,
  createInProgress,
  deleteInProgress,
  deleteFailure,
  delteSuccess,
  importSuccess,
  importFailure,
  importInProgress;
}

class RecipeState extends Equatable {
  final RecipeStatus status;
  final String? error;
  final Recipe? recipe;
  final String? recipeId;

  RecipeState({
    this.status = RecipeStatus.loadInProgress,
    this.error,
    this.recipe,
    this.recipeId,
  }) {
    switch (status) {
      case RecipeStatus.loadInProgress:
      case RecipeStatus.updateInProgress:
      case RecipeStatus.createInProgress:
      case RecipeStatus.importInProgress:
      case RecipeStatus.deleteInProgress:
      case RecipeStatus.delteSuccess:
        assert(error == null && recipe == null && recipeId == null);
        break;
      case RecipeStatus.createSuccess:
      case RecipeStatus.updateSuccess:
        assert(error == null && recipe == null && recipeId != null);
        break;
      case RecipeStatus.loadSuccess:
      case RecipeStatus.importSuccess:
        assert(error == null && recipe != null && recipeId == null);
        break;
      case RecipeStatus.deleteFailure:
      case RecipeStatus.loadFailure:
      case RecipeStatus.updateFailure:
      case RecipeStatus.createFailure:
      case RecipeStatus.importFailure:
        assert(error != null && recipe == null && recipeId == null);
    }
  }

  @override
  List<Object?> get props => [status, error, recipe, recipeId];
}
