part of 'recipes_short_bloc.dart';

enum RecipesShortStatus {
  loadInProgress,
  loadFailure,
  loadSuccess,
  loadAllSuccess,
  loadAllFailure,
  loadAllInProgress;
}

class RecipesShortState extends Equatable {
  final RecipesShortStatus status;
  final String? error;
  final Iterable<RecipeStub>? recipesShort;

  RecipesShortState({
    this.status = RecipesShortStatus.loadInProgress,
    this.error,
    this.recipesShort,
  }) {
    switch (status) {
      case RecipesShortStatus.loadInProgress:
      case RecipesShortStatus.loadAllInProgress:
        assert(error == null, recipesShort == null);
        break;
      case RecipesShortStatus.loadAllSuccess:
      case RecipesShortStatus.loadSuccess:
        assert(error == null, recipesShort != null);
        break;
      case RecipesShortStatus.loadAllFailure:
      case RecipesShortStatus.loadFailure:
        assert(error != null, recipesShort == null);
        break;
    }
  }

  @override
  List<Object?> get props => [status, error, recipesShort];
}
