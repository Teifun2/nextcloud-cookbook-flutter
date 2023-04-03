import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final DataRepository dataRepository = DataRepository();

  CategoriesBloc() : super(CategoriesState()) {
    on<CategoriesLoaded>(_mapCategoriesLoadedEventToState);
  }

  Future<void> _mapCategoriesLoadedEventToState(
    CategoriesLoaded event,
    Emitter<CategoriesState> emit,
  ) async {
    try {
      final List<Category> categories = await dataRepository.fetchCategories();
      dataRepository.updateCategoryNames(categories);
      emit(
        CategoriesState(
          status: CategoriesStatus.loadSuccess,
          categories: categories,
        ),
      );
      final List<Category> categoriesWithImage =
          await dataRepository.fetchCategoryMainRecipes(categories);
      emit(
        CategoriesState(
          status: CategoriesStatus.imageLoadSuccess,
          categories: categoriesWithImage,
        ),
      );
    } on Exception catch (e) {
      emit(
        CategoriesState(
          status: CategoriesStatus.loadFailure,
          error: e.toString(),
        ),
      );
    }
  }
}
