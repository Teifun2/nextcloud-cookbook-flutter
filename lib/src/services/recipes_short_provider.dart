import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

import 'network.dart';

class RecipesShortProvider {
  Future<List<RecipeShort>> fetchRecipesShort() async {
    AppAuthentication appAuthentication =
    UserRepository().getCurrentAppAuthentication();

    final String url = "${appAuthentication.server}/index.php/apps/cookbook/api/v1/recipes";
    try {
      String contents = await Network().get(url);
            return RecipeShort.parseRecipesShort(contents);
    }
    catch (e) {
      throw Exception(translate('recipe_list.errors.load_failed'));
    }
  }
}
