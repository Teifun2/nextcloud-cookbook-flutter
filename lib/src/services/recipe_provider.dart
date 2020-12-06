import 'package:dio/dio.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class RecipeProvider {
  Client client = Client();

  Future<Recipe> fetchRecipe(int id) async {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    final response = await client.get(
      "${appAuthentication.server}/index.php/apps/cookbook/api/recipes/$id",
      headers: {
        "authorization": appAuthentication.basicAuth,
      },
    );

    if (response.statusCode == 200) {
      try {
        return Recipe(response.body);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception(translate('recipe.errors.load_failed'));
    }
  }

  Future<int> updateRecipe(Recipe recipe) async {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    try {
      var response = await Dio().put(
          "${appAuthentication.server}/index.php/apps/cookbook/api/recipes/${recipe.id}",
          data: recipe.toJson(),
          options: new Options(
              contentType: "application/x-www-form-urlencoded",
              headers: {
                "authorization": appAuthentication.basicAuth,
              }));
      return response.data;
    } catch (e) {
      throw Exception(e);
    }
  }
}
