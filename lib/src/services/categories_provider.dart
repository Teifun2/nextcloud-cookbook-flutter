import 'package:http/http.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class CategoriesProvider {
  Client client = Client();

  Future<List<Category>> fetchCategories() async {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    final response = await client.get(
      "${appAuthentication.server}/index.php/apps/cookbook/categories",
      headers: {
        "authorization": appAuthentication.basicAuth,
      },
    );

    if (response.statusCode == 200) {
      try {
        List<Category> categories = Category.parseCategories(response.body);
        categories.sort((a, b) => a.name.compareTo(b.name));
        categories.insert(
          0,
          Category(
            "All",
            categories.fold(
                0,
                (previousValue, element) =>
                    previousValue + element.recipeCount),
          ),
        );
        return categories;
      } catch (e) {
        throw Exception(e);
      }
    } else {
      throw Exception("Failed to load RecipesShort!");
    }
  }
}
