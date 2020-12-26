import 'package:dio/dio.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class CategoryRecipesShortProvider {
  Future<List<RecipeShort>> fetchCategoryRecipesShort(String category) async {
    Dio client = UserRepository().getAuthenticatedClient();
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    final response = await client.get(
      "${appAuthentication.server}/index.php/apps/cookbook/category/$category",
    );

    if (response.statusCode == 200) {
      return RecipeShort.parseRecipesShort(response.data);
    } else {
      throw Exception(translate('recipe_list.errors.load_failed'));
    }
  }
}
