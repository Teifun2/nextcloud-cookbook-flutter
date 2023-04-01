import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
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
      final categories = await dataRepository.fetchCategories();
      emit(
        CategoriesState(
          status: CategoriesStatus.loadSuccess,
          categories: categories,
        ),
      );
      final recipes = await dataRepository.fetchCategoryMainRecipes(categories);
      emit(
        CategoriesState(
          status: CategoriesStatus.imageLoadSuccess,
          categories: categories,
          recipes: recipes,
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
