import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/category.dart';

class CategorySearchProvider {
  List<String> categoryNames = [];
  bool categoriesLoaded = false;
  static String categoryAll = translate('categories.all_categories');

  void updateCategoryNames(List<Category> categories) {
    categoryNames = categories
        .map((e) => e.name)
        .where((element) => element != categoryAll && element != '*')
        .toList();
    categoriesLoaded = true;
  }

  Iterable<String> getMatchingCategoryNames(String pattern) {
    return categoryNames.where((element) => element.contains(pattern));
  }
}
