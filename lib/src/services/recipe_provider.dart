import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

import 'network.dart';

class RecipeProvider {
  Future<Recipe> fetchRecipe(int id) async {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    final String url =
        "${appAuthentication.server}/index.php/apps/cookbook/api/v1/recipes/$id";
    // Parse categories
    try {
      String contents = await Network().get(url);
      return Recipe(contents);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> updateRecipe(Recipe recipe) async {
    Dio client = UserRepository().getAuthenticatedClient();
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    try {
      final String url =
          "${appAuthentication.server}/index.php/apps/cookbook/api/v1/recipes/${recipe.id}";
      var response = await client.put(url,
          data: recipe.toJson(),
          options: new Options(
            contentType: "application/json;charset=UTF-8",
          ));
      // Refresh recipe in the cache
      await DefaultCacheManager().removeFile(url);
      return int.parse(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> createRecipe(Recipe recipe) async {
    Dio client = UserRepository().getAuthenticatedClient();
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    try {
      var response = await client.post(
          "${appAuthentication.server}/index.php/apps/cookbook/api/v1/recipes",
          data: recipe.toJson(),
          options: new Options(
            contentType: "application/json;charset=UTF-8",
          ));
      return int.parse(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Recipe> importRecipe(String url) async {
    Dio client = UserRepository().getAuthenticatedClient();
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    try {
      var response = await client.post(
          "${appAuthentication.server}/index.php/apps/cookbook/api/v1/import",
          data: {"url": url},
          options: new Options(
            contentType: "application/json;charset=UTF-8",
          ));

      return Recipe(response.data);
    } on DioError catch (e) {
      throw Exception(e.response);
    } catch (e) {
      throw Exception(e);
    }
  }
}
