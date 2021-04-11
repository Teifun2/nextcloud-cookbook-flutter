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

  Future<int> importRecipe(String url) async {
    Dio client = UserRepository().getAuthenticatedClient();
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    try {
      var data = FormData.fromMap({
        'url': url,
      });
      var response = await client.post(
          "${appAuthentication.server}/index.php/apps/cookbook/import",
          data: data,
          options: new Options(
            contentType: "application/x-www-form-urlencoded",
          ));

      if (response.statusCode == 500 &&
          response.data.toString().contains("already exists")) {
        var responseText = response.data as String;

        if (responseText.contains("already exists")) {
          // TODO: Needs Translation
          throw Exception("Another recipe with that name already exists");
        } else if (responseText.contains("Could not find")) {
          // TODO: Needs Translation
          throw Exception("Could not find recipe element");
        }
      }
      return int.parse(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }
}
