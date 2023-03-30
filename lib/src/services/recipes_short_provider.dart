part of 'services.dart';

class RecipesShortProvider {
  Future<List<RecipeStub>> fetchRecipesShort() async {
    final AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    final String url =
        "${appAuthentication.server}/index.php/apps/cookbook/api/v1/recipes";
    try {
      final String contents = await Network().get(url);
      return RecipeStub.parseRecipesShort(contents);
    } catch (e) {
      throw Exception(translate('recipe_list.errors.load_failed'));
    }
  }
}
