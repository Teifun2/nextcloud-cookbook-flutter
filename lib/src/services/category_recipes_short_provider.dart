import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/services/version_provider.dart';

import 'network.dart';

class CategoryRecipesShortProvider {
  Future<List<RecipeShort>> fetchCategoryRecipesShort(String category) async {
    AndroidApiVersion androidApiVersion = UserRepository().getAndroidVersion();

    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    String url =
        "${appAuthentication.server}/apps/cookbook/api/v1/category/$category";
    if (androidApiVersion != AndroidApiVersion.BEFORE_API_ENDPOINT) {
      category = category == "*"
          ? "_"
          : category; // Mapping from * to _ for recipes without a category!
      url =
          "${appAuthentication.server}/index.php/apps/cookbook/api/v1/category/$category";
    }

    // Parse categories
    try {
      String contents = await Network().get(url);
      return RecipeShort.parseRecipesShort(contents);
    } catch (e) {
      throw Exception(e);
    }
  }
}
