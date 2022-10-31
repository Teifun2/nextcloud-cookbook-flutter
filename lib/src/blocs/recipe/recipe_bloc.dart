import 'package:bloc/bloc.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/services/local/local_storage_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/services/local/timed_store_ref.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final DataRepository dataRepository = DataRepository();
  final LocalStorageRepository localStorage = LocalStorageRepository.instance;

  RecipeBloc() : super(RecipeInitial());

  @override
  Stream<RecipeState> mapEventToState(RecipeEvent event) async* {
    if (event is RecipeLoaded) {
      yield* _mapRecipeLoadedToState(event);
    } else if (event is RecipeUpdated) {
      yield* _mapRecipeUpdatedToState(event);
    } else if (event is RecipeImported) {
      yield* _mapRecipeImportedToState(event);
    } else if (event is RecipeCreated) {
      yield* _mapRecipeCreatedToState(event);
    }
  }

  Stream<RecipeState> _mapRecipeLoadedToState(
      RecipeLoaded recipeLoaded) async* {
    try {
      yield RecipeLoadInProgress();

      // CACHE
      TimedStoreRef<Recipe> cachedRecipe =
          await localStorage.loadRecipe(recipeLoaded.recipeId);

      if (cachedRecipe.value != null) {
        yield RecipeLoadSuccess(cachedRecipe.value);
      }

      if (cachedRecipe.needsUpdate()) {
        // LOAD
        final recipe =
            Recipe(await dataRepository.fetchRecipe(recipeLoaded.recipeId));

        localStorage.storeRecipe(recipeLoaded.recipeId, recipe);
        yield RecipeLoadSuccess(recipe);
      }
    } catch (_) {
      yield RecipeLoadFailure(_.toString());
    }
  }

  Stream<RecipeState> _mapRecipeUpdatedToState(
      RecipeUpdated recipeUpdated) async* {
    try {
      yield RecipeUpdateInProgress();

      int recipeId = await dataRepository.updateRecipe(recipeUpdated.recipe);

      // Update Cache
      await localStorage.storeRecipe(recipeId, recipeUpdated.recipe);

      yield RecipeUpdateSuccess(recipeId);
    } catch (_) {
      yield RecipeUpdateFailure(_.toString());
    }
  }

  Stream<RecipeState> _mapRecipeCreatedToState(
      RecipeCreated recipeCreated) async* {
    try {
      yield RecipeCreateInProgress();

      int recipeId = await dataRepository.createRecipe(recipeCreated.recipe);

      // Update Cache
      await localStorage.storeRecipe(recipeId, recipeCreated.recipe);

      yield RecipeCreateSuccess(recipeId);
    } catch (_) {
      yield RecipeCreateFailure(_.toString());
    }
  }

  Stream<RecipeState> _mapRecipeImportedToState(
      RecipeImported recipeImported) async* {
    try {
      yield RecipeImportInProgress();

      final recipeJson = await dataRepository.importRecipe(recipeImported.url);
      final recipe = Recipe(recipeJson);

      // Update Cache
      await localStorage.storeRecipe(recipe.id, recipe);

      yield RecipeImportSuccess(recipe.id);
    } catch (_) {
      yield RecipeImportFailure(_.toString());
    }
  }
}
