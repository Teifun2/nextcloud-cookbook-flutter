import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short_event.dart';
import 'package:nextcloud_cookbook_flutter/src/blocs/recipes_short/recipes_short_state.dart';
import 'package:nextcloud_cookbook_flutter/src/services/repository.dart';

class RecipesShortBloc extends Bloc<RecipesShortEvent, RecipesShortState> {
  final Repository repository;

  RecipesShortBloc({@required this.repository});

  @override
  RecipesShortState get initialState => RecipesShortLoadInProgress();

  @override
  Stream<RecipesShortState> mapEventToState(RecipesShortEvent event) async* {
    if (event is RecipesShortLoaded) {
      yield* _mapRecipesShortLoadedToState();
    }
    // TODO: Implement other events.
  }

  Stream<RecipesShortState> _mapRecipesShortLoadedToState() async* {
    try {
      final recipesShort = await this.repository.fetchRecipesShort();
      yield RecipesShortLoadSuccess(recipesShort);
    } catch (_) {
      yield RecipesShortLoadFailure();
    }
  }
}