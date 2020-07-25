import 'package:bloc/bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final DataRepository dataRepository = DataRepository();

  @override
  CategoriesState get initialState => CategoriesInitial();

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    if (event is CategoriesLoaded) {
      yield* _mapCategoriesLoadedToState();
    }
  }

  Stream<CategoriesState> _mapCategoriesLoadedToState() async* {
    try {
      yield CategoriesLoadInProgress();
      List<Category> categories = await dataRepository.fetchCategories();
      yield CategoriesLoadSuccess(categories: categories);
      List<Category> categoriesWithImage =
          await dataRepository.fetchCategoryImages(categories);
      yield CategoriesImageLoadSuccess(categories: categoriesWithImage);
    } catch (_) {
      yield CategoriesLoadFailure(_.toString());
    }
  }
}
