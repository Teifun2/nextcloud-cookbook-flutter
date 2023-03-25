import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final DataRepository dataRepository = DataRepository();

  CategoriesBloc() : super(CategoriesInitial());

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    if (event is CategoriesLoaded) {
      yield* _mapCategoriesLoadedToState();
    }
  }

  Stream<CategoriesState> _mapCategoriesLoadedToState() async* {
    try {
      yield CategoriesLoadInProgress();
      final List<Category> categories = await dataRepository.fetchCategories();
      dataRepository.updateCategoryNames(categories);
      yield CategoriesLoadSuccess(categories: categories);
      final List<Category> categoriesWithImage =
          await dataRepository.fetchCategoryMainRecipes(categories);
      yield CategoriesImageLoadSuccess(categories: categoriesWithImage);
    } on Exception catch (e) {
      yield CategoriesLoadFailure(e.toString());
    }
  }
}
