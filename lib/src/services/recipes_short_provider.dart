import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'dart:developer' as developer;

class RecipesShortProvider  {
  Client client = Client();

  final storage = new FlutterSecureStorage();
  final String _appKeyKey = 'appkey';
  final String _serverURLKey = 'serverURL';
  final String _usernameKey = 'username';
  String _baseUrl = "";
  String _basicAuth = "";


  Future<String> basicAuth() async {
    String _username = await storage.read(key: _usernameKey);
    String _password = await storage.read(key: _appKeyKey);
    developer.log(_password, name: 'my.app.category');
    return  'Basic '+base64Encode(utf8.encode('$_username:$_password'));
  }

  Future<String> serverURL() async {
    return await storage.read(key: _serverURLKey);
  }






  Future<List<RecipeShort>> fetchRecipesShort() async {

     _baseUrl = await serverURL();
     _basicAuth = await basicAuth();


    final response = await client.get(
      "$_baseUrl/index.php/apps/cookbook/api/recipes",
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
      //null looks better then error, when no pictures added
      errorWidget: (context, url, error) => Icon(null),
    );
  }
}
