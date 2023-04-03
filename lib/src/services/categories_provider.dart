part of 'services.dart';

class CategoriesProvider {
  Future<List<Category>> fetchCategories() async {
    final AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    final String url =
        "${appAuthentication.server}/index.php/apps/cookbook/api/v1/categories";

    // Parse categories
    try {
      final String contents = await Network().get(url);
      final List<Category> categories = Category.parseCategories(contents);
      categories.sort((a, b) => a.name.compareTo(b.name));
      categories.insert(
        0,
        Category(
          translate('categories.all_categories'),
          categories.fold(
            0,
            (int previousValue, Category element) =>
                previousValue + element.recipeCount,
          ),
        ),
      );
      return categories;
    } catch (e) {
      throw Exception(e);
    }
  }
}
