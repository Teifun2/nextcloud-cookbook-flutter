import 'package:bloc/bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short_event.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short_state.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';

class RecipesShortBloc extends Bloc<RecipesShortEvent, RecipesShortState> {
  final DataRepository dataRepository = DataRepository();

  RecipesShortBloc() : super(RecipesShortLoadInProgress());

  @override
  Stream<RecipesShortState> mapEventToState(RecipesShortEvent event) async* {
    if (event is RecipesShortLoaded) {
      yield* _mapRecipesShortLoadedToState(event);
    } else if (event is RecipesShortLoadedAll) {
      yield* _mapRecipesShortLoadedAllToState(event);
    }
  }

  Stream<RecipesShortState> _mapRecipesShortLoadedToState(
      RecipesShortLoaded recipesShortLoaded) async* {
    try {
      final recipesShort = await dataRepository.fetchRecipesShort(
          category: recipesShortLoaded.category);
      yield RecipesShortLoadSuccess(recipesShort);
    } catch (_) {
      yield RecipesShortLoadFailure();
    }
  }

  Stream<RecipesShortState> _mapRecipesShortLoadedAllToState(
      RecipesShortLoadedAll recipesShortLoadedAll) async* {
    try {
      yield RecipesShortLoadAllInProgress();
      final recipesShort = await dataRepository.fetchAllRecipes();
      yield RecipesShortLoadAllSuccess(recipesShort);
    } catch (e) {
      yield RecipesShortLoadAllFailure(e.toString());
    }
  }
}
