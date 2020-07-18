import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';

class RecipesShortProvider  {
  Client client = Client();

  Future<List<RecipeShort>> fetchRecipesShort(AppAuthentication appAuthentication) async {
    final response = await client.get(
      "${appAuthentication.server}/index.php/apps/cookbook/api/recipes",
      headers: {
        "authorization": appAuthentication.basicAuth,
      },
    );

    if (response.statusCode == 200) {
      return RecipeShort.parseRecipesShort(response.body);
    } else {
      throw Exception("Failed to load RecipesShort!");
    }
  }

  CachedNetworkImage fetchRecipeThumb(AppAuthentication appAuthentication, String path) {
    return CachedNetworkImage(
      imageUrl: '${appAuthentication.server}$path',
      httpHeaders: {
        "authorization": appAuthentication.basicAuth,
      },
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.broken_image),
    );
  }
}
