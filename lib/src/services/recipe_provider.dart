import 'package:dio/dio.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class RecipeProvider {
  Future<Recipe> fetchRecipe(int id) async {
    Dio client = UserRepository().getAuthenticatedClient();
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    final response = await client.get(
      "${appAuthentication.server}/index.php/apps/cookbook/api/recipes/$id",
    );

    if (response.statusCode == 200) {
      try {
        return Recipe(response.data);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception(translate('recipe.errors.load_failed'));
    }
  }

  Future<int> updateRecipe(Recipe recipe) async {
    Dio client = UserRepository().getAuthenticatedClient();
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    try {
      var response = await client.put(
          "${appAuthentication.server}/index.php/apps/cookbook/api/recipes/${recipe.id}",
          data: recipe.toJson(),
          options: new Options(
            contentType: "application/json;charset=UTF-8",
          ));
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
      var response = await client.put(
          "${appAuthentication.server}/index.php/apps/cookbook/api/recipes",
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
          "${appAuthentication.server}/index.php/apps/cookbook/import",
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
