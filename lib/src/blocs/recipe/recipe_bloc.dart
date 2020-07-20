import 'package:bloc/bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final DataRepository dataRepository = DataRepository();

  @override
  RecipeState get initialState => RecipeInitial();

  @override
  Stream<RecipeState> mapEventToState(RecipeEvent event) async* {
    if (event is RecipeLoaded) {
      yield* _mapRecipeLoadedToState(event);
    }
  }


  Stream<RecipeState> _mapRecipeLoadedToState(RecipeLoaded recipeLoaded) async* {
    try {
      yield RecipeLoadInProgress();
      final recipe = await dataRepository.fetchRecipe(recipeLoaded.recipeId);
      yield RecipeLoadSuccess(recipe: recipe);
    } catch (_) {
      yield RecipeLoadFailure();
    }
  }
}