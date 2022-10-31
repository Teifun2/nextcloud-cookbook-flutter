import 'dart:io';

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
      TimedStoreRef<String> cachedRecipe;
      try {
        cachedRecipe = await localStorage.loadRecipe(recipeLoaded.recipeId);
        if (cachedRecipe != null) {
          yield RecipeLoadSuccess(Recipe(cachedRecipe.value));
        }
      } catch (_) {
        stderr.writeln(_.toString());
      }

      var internet = true;
      if (internet &&
          (cachedRecipe == null ||
              cachedRecipe.dateTime.difference(DateTime.now()).inHours > 1)) {
        // LOAD
        final recipe = await dataRepository.fetchRecipe(recipeLoaded.recipeId);
        localStorage.storeRecipe(recipeLoaded.recipeId, TimedStoreRef(recipe));
        yield RecipeLoadSuccess(Recipe(recipe));
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
      await localStorage.storeRecipe(
          recipeId, TimedStoreRef(recipeUpdated.recipe.toJson()));

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
      await localStorage.storeRecipe(
          recipeId, TimedStoreRef(recipeCreated.recipe.toJson()));

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
      await localStorage.storeRecipe(recipe.id, TimedStoreRef(recipeJson));

      yield RecipeImportSuccess(recipe.id);
    } catch (_) {
      yield RecipeImportFailure(_.toString());
    }
  }
}
