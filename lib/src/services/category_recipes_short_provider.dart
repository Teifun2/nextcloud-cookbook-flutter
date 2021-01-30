import 'package:dio/dio.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/services/version_provider.dart';

class CategoryRecipesShortProvider {
  Future<List<RecipeShort>> fetchCategoryRecipesShort(String category) async {
    AndroidApiVersion androidApiVersion = UserRepository().getAndroidVersion();
    Dio client = UserRepository().getAuthenticatedClient();
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    Response response;
    if (androidApiVersion == AndroidApiVersion.BEFORE_API_ENDPOINT) {
      response = await client.get(
          "${appAuthentication.server}/index.php/apps/cookbook/category/$category");
    } else {
      category = category == "*"
          ? "_"
          : category; // Mapping from * to _ for recipes without a category!
      response = await client.get(
          "${appAuthentication.server}/index.php/apps/cookbook/api/category/$category");
    }

    if (response.statusCode == 200) {
      return RecipeShort.parseRecipesShort(response.data);
    } else {
      throw Exception(translate('recipe_list.errors.load_failed'));
    }
  }
}
