import 'dart:convert';

import 'package:http/http.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class RecipeProvider {
  Client client = Client();

  Future<Recipe> fetchRecipe(int id) async {
    AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    final response = await client.get(
      "${appAuthentication.server}/index.php/apps/cookbook/api/recipes/$id",
      headers: {
        "authorization": appAuthentication.basicAuth,
      },
    );

    if (response.statusCode == 200) {
      return Recipe.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load RecipesShort!");
    }
  }
}
