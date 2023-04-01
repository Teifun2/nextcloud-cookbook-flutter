part of 'services.dart';

class DataRepository {
  // Singleton
  static final DataRepository _dataRepository = DataRepository._();
  factory DataRepository() => _dataRepository;

  DataRepository._();

  // Provider List
  final ApiProvider api = ApiProvider();

  final NextcloudMetadataApi _nextcloudMetadataApi = NextcloudMetadataApi();

  // Data
  static final String categoryAll = translate('categories.all_categories');

  // Actions
  Future<Iterable<RecipeStub>?> fetchRecipesShort({
    required String category,
  }) async {
    if (category == categoryAll) {
      final response = await api.recipeApi.listRecipes();
      return response.data;
    } else if (category == "*") {
      final response = await api.categoryApi.recipesInCategory(category: "_");
      return response.data;
    } else {
      final response =
          await api.categoryApi.recipesInCategory(category: category);
      return response.data;
    }
  }

  Future<Recipe?> fetchRecipe(String id) async {
    final response = await api.recipeApi.recipeDetails(id: id);
    return response.data;
  }

  Future<String?> updateRecipe(Recipe recipe) async {
    final response =
        await api.recipeApi.updateRecipe(id: recipe.id!, recipe: recipe);
    return response.data?.toString();
  }

  Future<String?> createRecipe(Recipe recipe) async {
    final response = await api.recipeApi.newRecipe(recipe: recipe);
    return response.data?.toString();
  }

  Future<Recipe?> importRecipe(String url) async {
    final requestUrl = UrlBuilder()..url = url;

    final response = await api.recipeApi.callImport(url: requestUrl.build());
    return response.data;
  }

  Future<Iterable<Category>?> fetchCategories() async {
    final response = await api.categoryApi.listCategories();
    final categories = response.data?.toBuilder();

    final allRecepies = await fetchAllRecipes();
    final allCount = allRecepies?.length;

    if (allCount != null && allCount > 0) {
      final allCategory = CategoryBuilder()
        ..name = categoryAll
        ..recipeCount = allCount;

      categories?.insert(
        0,
        allCategory.build(),
      );
    }

    return categories?.build();
  }

  Future<Iterable<RecipeStub?>?> fetchCategoryMainRecipes(
    Iterable<Category>? categories,
  ) async {
    if (categories == null) return null;

    return Future.wait(categories.map(_fetchCategoryMainRecipe));
  }

  Future<RecipeStub?> _fetchCategoryMainRecipe(Category category) async {
    try {
      final categoryRecipes = await fetchRecipesShort(category: category.name);
      if (categoryRecipes != null) {
        for (final category in categoryRecipes) {
          if (category.imageUrl.isNotEmpty) {
            return category;
          }
        }
      }
    } catch (e) {
      log("Could not load main recipe of Category!");
      rethrow;
    }

    return null;
  }

  Future<Iterable<RecipeStub>?> fetchAllRecipes() async {
    return fetchRecipesShort(category: categoryAll);
  }

  String getUserAvatarUrl() {
    return _nextcloudMetadataApi.getUserAvatarUrl();
  }

  Future<Iterable<String>> getMatchingCategoryNames(String pattern) async {
    final categories = await fetchCategories();
    final matches =
        categories?.where((element) => element.name.contains(pattern));

    return matches?.map((e) => e.name) ?? [];
  }
}
