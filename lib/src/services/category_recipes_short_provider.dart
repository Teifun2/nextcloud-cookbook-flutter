import 'package:http/http.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class CategoryRecipesShortProvider {
  Client client = Client();

  Future<List<RecipeShort>> fetchCategoryRecipesShort(String category) async {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    final response = await client.get(
      "${appAuthentication.server}/index.php/apps/cookbook/category/$category",
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
}
