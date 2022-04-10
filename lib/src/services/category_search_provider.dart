import 'package:nextcloud_cookbook_flutter/src/models/category.dart';

class CategorySearchProvider {
  List<String> categoryNames = [];
  bool categoriesLoaded = false;

  void updateCategoryNames(List<Category> categories) {
    categoryNames = categories.map((e) => e.name).toList();
    categoriesLoaded = true;
  }

  Iterable<String> getMatchingCategoryNames(String pattern) {
    return categoryNames.where((element) => element.contains(pattern));
  }
}
