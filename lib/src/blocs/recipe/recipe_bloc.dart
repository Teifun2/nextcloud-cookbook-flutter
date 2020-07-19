import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipe/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/data_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final UserRepository userRepository;
  final DataRepository dataRepository;

  RecipeBloc({@required this.userRepository, @required this.dataRepository});

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
      final recipe = await dataRepository.fetchRecipe(userRepository.currentAppAuthentication, recipeLoaded.recipeId);
      yield RecipeLoadSuccess(recipe: recipe);
    } catch (_) {
      yield RecipeLoadFailure();
    }
  }
}