import 'dart:developer';

import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/categories_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/category_recipes_short_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/category_search_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/net/nextcloud_metadata_api.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipe_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';

class DataRepository {
  // Singleton
  static final DataRepository _dataRepository = DataRepository._();
  factory DataRepository() => _dataRepository;

  DataRepository._();

  // Provider List
  RecipesShortProvider recipesShortProvider = RecipesShortProvider();
  CategoryRecipesShortProvider categoryRecipesShortProvider =
      CategoryRecipesShortProvider();
  CategorySearchProvider categorySearchProvider = CategorySearchProvider();
  RecipeProvider recipeProvider = RecipeProvider();
  CategoriesProvider categoriesProvider = CategoriesProvider();
  final NextcloudMetadataApi _nextcloudMetadataApi = NextcloudMetadataApi();

  // Data
  static String categoryAll = translate('categories.all_categories');

  // Actions
  Future<List<RecipeShort>> fetchRecipesShort({required String category}) {
    if (category == categoryAll) {
      return recipesShortProvider.fetchRecipesShort();
    } else {
      return categoryRecipesShortProvider.fetchCategoryRecipesShort(category);
    }
  }

  Future<Recipe> fetchRecipe(String id) {
    return recipeProvider.fetchRecipe(int.parse(id));
  }

  Future<String> updateRecipe(Recipe recipe) async {
    final response = await recipeProvider.updateRecipe(recipe);
    return response.toString();
  }

  Future<String> createRecipe(Recipe recipe) async {
    final response = await recipeProvider.createRecipe(recipe);

    return response.toString();
  }

  Future<Recipe> importRecipe(String url) {
    return recipeProvider.importRecipe(url);
  }

  Future<List<Category>> fetchCategories() {
    return categoriesProvider.fetchCategories();
  }

  Future<List<Category>> fetchCategoryMainRecipes(
    List<Category> categories,
  ) async {
    return Future.wait(
      categories.map((category) => _fetchCategoryMainRecipe(category)).toList(),
    );
  }

  Future<Category> _fetchCategoryMainRecipe(Category category) async {
    List<RecipeShort> categoryRecipes = [];

    try {
      if (category.name == translate('categories.all_categories')) {
        categoryRecipes = await recipesShortProvider.fetchRecipesShort();
      } else {
        categoryRecipes = await categoryRecipesShortProvider
            .fetchCategoryRecipesShort(category.name);
      }
    } catch (e) {
      log("Could not load main recipe of Category!");
    }

    if (categoryRecipes.isNotEmpty) {
      return category.copyWith(firstRecipeId: categoryRecipes.first.recipeId);
    }

    return category;
  }

  Future<List<RecipeShort>> fetchAllRecipes() async {
    return fetchRecipesShort(category: categoryAll);
  }

  String getUserAvatarUrl() {
    return _nextcloudMetadataApi.getUserAvatarUrl();
  }

  void updateCategoryNames(List<Category> categories) {
    categorySearchProvider.updateCategoryNames(categories);
  }

  Future<Iterable<String>> getMatchingCategoryNames(String pattern) async {
    if (!categorySearchProvider.categoriesLoaded) {
      await categoriesProvider.fetchCategories();
    }

    return categorySearchProvider.getMatchingCategoryNames(pattern);
  }
}
