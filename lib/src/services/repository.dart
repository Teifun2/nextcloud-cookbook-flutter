import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';

class Repository {
  RecipesShortProvider appRecipesShortProvider = RecipesShortProvider();

  Future<List<RecipeShort>> fetchRecipesShort() =>
      appRecipesShortProvider.fetchRecipesShort();
}
