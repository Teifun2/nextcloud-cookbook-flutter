import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  RecipeBloc() : super(RecipeState()) {
    on<RecipeLoaded>(_mapRecipeLoadedToState);
    on<RecipeUpdated>(_mapRecipeUpdatedToState);
    on<RecipeImported>(_mapRecipeImportedToState);
    on<RecipeCreated>(_mapRecipeCreatedToState);
    on<RecipeDeleted>(_mapRecipeDeletedToState);
  }
  final DataRepository dataRepository = DataRepository();

  Future<void> _mapRecipeLoadedToState(
    RecipeLoaded recipeLoaded,
    Emitter<RecipeState> emit,
  ) async {
    try {
      final recipe = await dataRepository.fetchRecipe(recipeLoaded.recipeId);
      emit(RecipeState(status: RecipeStatus.loadSuccess, recipe: recipe));
    } catch (e) {
      emit(RecipeState(status: RecipeStatus.loadFailure, error: e.toString()));
    }
  }

  Future<void> _mapRecipeUpdatedToState(
    RecipeUpdated recipeUpdated,
    Emitter<RecipeState> emit,
  ) async {
    try {
      emit(RecipeState(status: RecipeStatus.updateInProgress));
      final recipeId = await dataRepository.updateRecipe(recipeUpdated.recipe);
      emit(RecipeState(status: RecipeStatus.updateSuccess, recipeId: recipeId));
    } catch (e) {
      emit(
        RecipeState(
          status: RecipeStatus.updateFailure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _mapRecipeCreatedToState(
    RecipeCreated recipeCreated,
    Emitter<RecipeState> emit,
  ) async {
    try {
      emit(RecipeState(status: RecipeStatus.createInProgress));
      final recipeId = await dataRepository.createRecipe(recipeCreated.recipe);
      emit(RecipeState(status: RecipeStatus.createSuccess, recipeId: recipeId));
    } catch (e) {
      emit(
        RecipeState(
          status: RecipeStatus.createFailure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _mapRecipeImportedToState(
    RecipeImported recipeImported,
    Emitter<RecipeState> emit,
  ) async {
    try {
      emit(RecipeState(status: RecipeStatus.importInProgress));
      final recipe = await dataRepository.importRecipe(recipeImported.url);
      emit(RecipeState(status: RecipeStatus.importSuccess, recipe: recipe));
    } catch (e) {
      emit(
        RecipeState(
          status: RecipeStatus.importFailure,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> _mapRecipeDeletedToState(
    RecipeDeleted recipeDeleted,
    Emitter<RecipeState> emit,
  ) async {
    try {
      emit(RecipeState(status: RecipeStatus.deleteInProgress));
      await dataRepository.deleteRecipe(recipeDeleted.recipe);
      emit(RecipeState(status: RecipeStatus.delteSuccess));
    } catch (e) {
      emit(
        RecipeState(
          status: RecipeStatus.deleteFailure,
          error: e.toString(),
        ),
      );
    }
  }
}
