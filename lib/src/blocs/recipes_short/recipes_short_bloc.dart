import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

part 'recipes_short_event.dart';
part 'recipes_short_state.dart';

class RecipesShortBloc extends Bloc<RecipesShortEvent, RecipesShortState> {
  final DataRepository dataRepository = DataRepository();

  RecipesShortBloc() : super(RecipesShortState()) {
    on<RecipesShortLoaded>(_mapRecipesShortLoadedToState);
    on<RecipesShortLoadedAll>(_mapRecipesShortLoadedAllToState);
  }

  Future<void> _mapRecipesShortLoadedToState(
    RecipesShortLoaded recipesShortLoaded,
    Emitter<RecipesShortState> emit,
  ) async {
    try {
      final recipesShort = await dataRepository.fetchRecipesShort(
        category: recipesShortLoaded.category,
      );
      emit(
        RecipesShortState(
          status: RecipesShortStatus.loadSuccess,
          recipesShort: recipesShort,
        ),
      );
    } catch (_) {
      emit(
        RecipesShortState(
          status: RecipesShortStatus.loadFailure,
          error: "",
        ),
      );
    }
  }

  Future<void> _mapRecipesShortLoadedAllToState(
    RecipesShortLoadedAll recipesShortLoadedAll,
    Emitter<RecipesShortState> emit,
  ) async {
    try {
      emit(
        RecipesShortState(
          status: RecipesShortStatus.loadAllInProgress,
        ),
      );
      final recipesShort = await dataRepository.fetchAllRecipes();
      emit(
        RecipesShortState(
          status: RecipesShortStatus.loadAllSuccess,
          recipesShort: recipesShort,
        ),
      );
    } catch (e) {
      emit(
        RecipesShortState(
          status: RecipesShortStatus.loadAllFailure,
          error: "",
        ),
      );
    }
  }
}
