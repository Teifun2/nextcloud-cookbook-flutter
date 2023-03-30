part of 'services.dart';

class RecipeProvider {
  Future<Recipe> fetchRecipe(int id) async {
    final AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    final String url =
        "${appAuthentication.server}/index.php/apps/cookbook/api/v1/recipes/$id";
    // Parse categories
    try {
      final String contents = await Network().get(url);
      return Recipe(contents);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> updateRecipe(Recipe recipe) async {
    final Dio client = UserRepository().authenticatedClient;
    final AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    try {
      final String url =
          "${appAuthentication.server}/index.php/apps/cookbook/api/v1/recipes/${recipe.id}";
      final response = await client.put(
        url,
        data: recipe.toJson(),
        options: Options(
          contentType: "application/json;charset=UTF-8",
        ),
      );
      // Refresh recipe in the cache
      await DefaultCacheManager().removeFile(url);
      return int.parse(response.data as String);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> createRecipe(Recipe recipe) async {
    final Dio client = UserRepository().authenticatedClient;
    final AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    try {
      final response = await client.post(
        "${appAuthentication.server}/index.php/apps/cookbook/api/v1/recipes",
        data: recipe.toJson(),
        options: Options(
          contentType: "application/json;charset=UTF-8",
        ),
      );
      return int.parse(response.data as String);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Recipe> importRecipe(String url) async {
    final Dio client = UserRepository().authenticatedClient;
    final AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    try {
      final response = await client.post(
        "${appAuthentication.server}/index.php/apps/cookbook/api/v1/import",
        data: {"url": url},
        options: Options(
          contentType: "application/json;charset=UTF-8",
        ),
      );

      return Recipe(response.data as String);
    } on DioError catch (e) {
      throw Exception(e.response);
    } catch (e) {
      throw Exception(e);
    }
  }
}
