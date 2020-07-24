import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/categories_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipe_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';

class DataRepository {
  // Singleton
  static final DataRepository _dataRepository = DataRepository._internal();
  factory DataRepository() {
    return _dataRepository;
  }
  DataRepository._internal();

  // Provider List
  RecipesShortProvider recipesShortProvider = RecipesShortProvider();
  RecipeProvider recipeProvider = RecipeProvider();
  CategoriesProvider categoriesProvider = CategoriesProvider();

  // Actions
  Future<List<RecipeShort>> fetchRecipesShort() {
    return recipesShortProvider.fetchRecipesShort();
  }

  Future<Recipe> fetchRecipe(int id) {
    return recipeProvider.fetchRecipe(id);
  }

  Future<List<Category>> fetchCategories() {
    return categoriesProvider.fetchCategories();
  }
}
