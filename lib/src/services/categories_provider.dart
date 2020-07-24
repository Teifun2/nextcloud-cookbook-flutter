import 'package:http/http.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class CategoriesProvider {
  Client client = Client();

  Future<List<Category>> fetchCategories() async {
    AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    final response = await client.get(
      "${appAuthentication.server}/index.php/apps/cookbook/categories",
      headers: {
        "authorization": appAuthentication.basicAuth,
      },
    );

    if (response.statusCode == 200) {
      try {
        return Category.parseCategories(response.body);
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception("Failed to load RecipesShort!");
    }
  }
}
