import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

import 'network.dart';

class CategoriesProvider {
  Future<List<Category>> fetchCategories() async {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    final String url =
        "${appAuthentication.server}/index.php/apps/cookbook/api/v1/categories";

    // Parse categories
    try {
      String contents = await Network().get(url);
      List<Category> categories = Category.parseCategories(contents);
      categories.sort((a, b) => a.name.compareTo(b.name));
      categories.insert(
        0,
        Category(
          translate('categories.all_categories'),
          categories.fold(0,
              (previousValue, element) => previousValue + element.recipeCount),
        ),
      );
      return categories;
    } catch (e) {
      throw Exception(e);
    }
  }
}
