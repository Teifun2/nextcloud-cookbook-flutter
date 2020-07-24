import 'package:bloc/bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/categories/categories.dart';
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
      // Load
      yield CategoriesLoadSuccess(categories: null);
    } catch (_) {
      yield CategoriesLoadFailure();
    }
  }
}
