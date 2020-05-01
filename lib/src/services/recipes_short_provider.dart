import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short_model.dart';

class RecipesShortProvider {
  Client client = Client();
  final _baseUrl = 'host';

  static final String _username = 'username';
  static final String _password = 'password';
  static final String _basicAuth =
      'Basic ' + base64Encode(utf8.encode('$_username:$_password'));

  Future<List<RecipeShort>> fetchRecipesShort() async {
    final response = await client.get(
      "$_baseUrl/apps/cookbook/api/recipes",
      headers: {
        "authorization": _basicAuth,
      },
    );

    if (response.statusCode == 200) {
      return RecipeShort.parseRecipesShort(response.body);
    } else {
      throw Exception("Failed to load RecipesShort!");
    }
  }

  CachedNetworkImage fetchRecipeThumb(String path) {
    return CachedNetworkImage(
      imageUrl: '$_baseUrl$path',
      httpHeaders: {
        "authorization": _basicAuth,
      },
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
