import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class RecipeService {
  Future<String> fetchRecipe(int id) async {
    Dio client = UserRepository().getAuthenticatedClient();

    try {
      final String url = "/index.php/apps/cookbook/api/v1/recipes/$id";
      var response = await client.get<String>(url);

      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioError catch (e) {
      throw Exception(e.response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> updateRecipe(Recipe recipe) async {
    Dio client = UserRepository().getAuthenticatedClient();

    try {
      final String url = "/index.php/apps/cookbook/api/v1/recipes/${recipe.id}";
      var response = await client.put(url,
          data: recipe.toJson(),
          options: new Options(
            contentType: "application/json;charset=UTF-8",
          ));

      if (response.statusCode == HttpStatus.ok) {
        return int.parse(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioError catch (e) {
      throw Exception(e.response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<int> createRecipe(Recipe recipe) async {
    Dio client = UserRepository().getAuthenticatedClient();

    try {
      final String url = "/index.php/apps/cookbook/api/v1/recipes";
      var response = await client.post(url,
          data: recipe.toJson(),
          options: new Options(
            contentType: "application/json;charset=UTF-8",
          ));

      if (response.statusCode == HttpStatus.ok) {
        return int.parse(response.data);
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioError catch (e) {
      throw Exception(e.response);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> importRecipe(String url) async {
    Dio client = UserRepository().getAuthenticatedClient();

    try {
      final String url = "/index.php/apps/cookbook/api/v1/import";
      var response = await client.post(url,
          data: {"url": url},
          options: new Options(
            contentType: "application/json;charset=UTF-8",
          ));

      if (response.statusCode == HttpStatus.ok) {
        return response.data;
      } else {
        throw Exception(response.statusMessage);
      }
    } on DioError catch (e) {
      throw Exception(e.response);
    } catch (e) {
      throw Exception(e);
    }
  }
}
