import 'package:nextcloud_cookbook_flutter/src/models/recipe_short_model.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/repository.dart';
import 'package:rxdart/rxdart.dart';

class RecipesShortBloc {
  Repository _repository = Repository();

  final _recipesShortFetcher = PublishSubject<List<RecipeShort>>();

  Stream<List<RecipeShort>> get recipesShort => _recipesShortFetcher.stream;

  fetchRecipesShort() async {
    List<RecipeShort> recipesShort = await _repository.fetchRecipesShort();
    _recipesShortFetcher.sink.add(recipesShort);
  }

  dispose() {
    _recipesShortFetcher.close();
  }
}

final recipesShortBloc = RecipesShortBloc();
