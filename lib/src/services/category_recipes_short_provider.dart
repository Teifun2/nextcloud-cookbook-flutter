import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/network.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/services/version_provider.dart';

class CategoryRecipesShortProvider {
  Future<List<RecipeStub>> fetchCategoryRecipesShort(String category) async {
    final AndroidApiVersion androidApiVersion =
        UserRepository().getAndroidVersion();

    final AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    String url =
        "${appAuthentication.server}/apps/cookbook/api/v1/category/$category";
    if (androidApiVersion != AndroidApiVersion.beforeApiEndpoint) {
      final categorySanitized = category == "*"
          ? "_"
          : category; // Mapping from * to _ for recipes without a category!
      url =
          "${appAuthentication.server}/index.php/apps/cookbook/api/v1/category/$categorySanitized";
    }

    // Parse categories
    try {
      final String contents = await Network().get(url);
      return RecipeStub.parseRecipesShort(contents);
    } catch (e) {
      throw Exception(e);
    }
  }
}
