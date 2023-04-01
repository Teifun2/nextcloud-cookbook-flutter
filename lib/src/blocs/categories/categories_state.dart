part of 'categories_bloc.dart';

enum CategoriesStatus {
  loadInProgress,
  loadFailure,
  loadSuccess,
  imageLoadSuccess;
}

class CategoriesState extends Equatable {
  final CategoriesStatus status;
  final String? error;
  final Iterable<Category>? categories;
  final Iterable<RecipeStub?>? recipes;

  CategoriesState({
    this.status = CategoriesStatus.loadInProgress,
    this.error,
    this.categories,
    this.recipes,
  }) {
    switch (status) {
      case CategoriesStatus.loadInProgress:
        assert(error == null && categories == null && recipes == null);
        break;
      case CategoriesStatus.loadSuccess:
        assert(error == null && categories != null && recipes == null);
        break;
      case CategoriesStatus.imageLoadSuccess:
        assert(error == null && categories != null && recipes != null);
        break;
      case CategoriesStatus.loadFailure:
        assert(error != null && categories == null && recipes == null);
    }
  }

  @override
  List<Object?> get props => [status, error, categories];
}
