import 'package:dio/dio.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class CategoriesProvider {
  Future<List<Category>> fetchCategories() async {
    Dio client = UserRepository().getAuthenticatedClient();
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    final response = await client
        .get("${appAuthentication.server}/index.php/apps/cookbook/categories");

    if (response.statusCode == 200) {
      try {
        List<Category> categories = Category.parseCategories(response.data);
        categories.sort((a, b) => a.name.compareTo(b.name));
        categories.insert(
          0,
          Category(
            translate('categories.all_categories'),
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
      throw Exception(translate('categories.errors.load_no_response'));
    }
  }
}
