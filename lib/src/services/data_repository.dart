import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipe_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';

class DataRepository {
  RecipesShortProvider recipesShortProvider = RecipesShortProvider();
  RecipeProvider recipeProvider = RecipeProvider();

  Future<List<RecipeShort>> fetchRecipesShort(AppAuthentication appAuthentication) {
    return recipesShortProvider.fetchRecipesShort(appAuthentication);
  }

  Future<Recipe> fetchRecipe(AppAuthentication appAuthentication, int id) {
    return recipeProvider.fetchRecipe(appAuthentication, id);
  }
}
