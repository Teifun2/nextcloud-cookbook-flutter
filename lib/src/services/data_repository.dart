part of 'services.dart';

class DataRepository {
  factory DataRepository() => _dataRepository ??= const DataRepository._();

  // coverage:ignore-start
  @visibleForTesting
  factory DataRepository.mocked(DataRepository mock) =>
      _dataRepository ??= mock;
  // coverage:ignore-end

  const DataRepository._();
  // Singleton
  static DataRepository? _dataRepository;

  // Provider List
  static final api = ApiProvider();

  static final _nextcloudMetadataApi = NextcloudMetadataApi();

  // Data
  static final String categoryAll = translate('categories.all_categories');
  static final String categoryUncategorized =
      translate('categories.uncategorized');

  // Actions
  Future<Iterable<RecipeStub>?> fetchRecipesShort({
    required String category,
  }) async {
    if (category == categoryAll) {
      final response = await api.recipeApi.listRecipes();
      return response.data;
    } else if (category == categoryUncategorized) {
      final response = await api.categoryApi.recipesInCategory(category: '_');
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
    return response.data;
  }

  Future<String?> createRecipe(Recipe recipe) async {
    final response = await api.recipeApi.newRecipe(recipe: recipe);
    return response.data;
  }

  Future<String?> deleteRecipe(Recipe recipe) async {
    final response = await api.recipeApi.deleteRecipe(id: recipe.id!);
    return response.data;
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

    final uncategorizedBuilder = CategoryBuilder();

    categories?.removeWhere((c) {
      if (c.name == '*') {
        uncategorizedBuilder
          ..replace(c)
          ..name = categoryUncategorized;
        return true;
      }
      return false;
    });

    categories?.add(uncategorizedBuilder.build());

    return categories?.build();
  }

  Future<Iterable<RecipeStub?>?> fetchCategoryMainRecipes(
    Iterable<Category>? categories,
  ) async {
    if (categories == null) {
      return null;
    }

    return Future.wait(categories.map(_fetchCategoryMainRecipe));
  }

  Future<RecipeStub?> _fetchCategoryMainRecipe(Category category) async {
    final categoryRecipes = await fetchRecipesShort(category: category.name);

    if (categoryRecipes != null && categoryRecipes.isNotEmpty) {
      return categoryRecipes.first;
    }
    return null;
  }

  Future<Iterable<RecipeStub>?> fetchAllRecipes() async =>
      fetchRecipesShort(category: categoryAll);

  String getUserAvatarUrl() => _nextcloudMetadataApi.getUserAvatarUrl();

  Future<Iterable<String>> getMatchingCategoryNames(String pattern) async {
    final categories = await fetchCategories();
    final matches =
        categories?.where((element) => element.name.contains(pattern));

    return matches?.map((e) => e.name) ?? [];
  }

  Future<ImageResponse?> fetchImage(String recipeId, Size size) async {
    final String sizeParam;
    if (size.longestSide <= 16) {
      sizeParam = 'thumb16';
    } else if (size.longestSide <= 250) {
      sizeParam = 'thumb';
    } else {
      sizeParam = 'full';
    }

    final response = await api.recipeApi.getImage(
      id: recipeId,
      headers: {
        'Accept': 'image/jpeg, image/svg+xml',
      },
      size: sizeParam,
    );
    if (response.data != null) {
      return ImageResponse(
        data: response.data!,
        isSvg: response.headers.value('content-type') == 'image/svg+xml',
      );
    }

    return null;
  }
}
