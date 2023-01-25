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

  CategoriesState({
    this.status = CategoriesStatus.loadInProgress,
    this.error,
    this.categories,
  }) {
    switch (status) {
      case CategoriesStatus.loadInProgress:
        assert(error == null && categories == null);
        break;
      case CategoriesStatus.loadSuccess:
      case CategoriesStatus.imageLoadSuccess:
        assert(error == null && categories != null);
        break;
      case CategoriesStatus.loadFailure:
        assert(error != null && categories == null);
    }
  }

  @override
  List<Object?> get props => [status, error, categories];
}
