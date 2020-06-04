import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';
import 'dart:developer' as developer;
class Repository {
  RecipesShortProvider appRecipesShortProvider = RecipesShortProvider();

  Future<List<RecipeShort>> fetchRecipesShort() {
    developer.log('log msadasdsa  e', name: 'my.app.category');
    return appRecipesShortProvider.fetchRecipesShort();
  }

}
