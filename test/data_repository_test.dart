import 'package:built_collection/built_collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

import 'helpers/translation_helpers.dart';
import 'mocks/mocks.dart';

void main() {
  final api = ApiProvider.mocked(ApiMock());

  setUpAll(setupL10n);

  group(DataRepository, () {
    test('fetchRecipesShort', () async {
      when(() => api.recipeApi.listRecipes()).thenAnswer(
        (_) async => ResponseMock<BuiltList<FakeRecipeStub>>(data: BuiltList()),
      );
      when(
        () =>
            api.categoryApi.recipesInCategory(category: any(named: 'category')),
      ).thenAnswer(
        (_) async => ResponseMock<BuiltList<FakeRecipeStub>>(data: BuiltList()),
      );

      final allRecipes = await DataRepository()
          .fetchRecipesShort(category: DataRepository.categoryAll);

      expect(allRecipes, isEmpty);
      verify(() => api.recipeApi.listRecipes()).called(1);

      final uncategorized = await DataRepository()
          .fetchRecipesShort(category: DataRepository.categoryUncategorized);

      expect(uncategorized, isEmpty);
      verify(
        () => api.categoryApi.recipesInCategory(category: '_'),
      ).called(1);

      final recipes =
          await DataRepository().fetchRecipesShort(category: 'category');

      expect(recipes, isEmpty);
      verify(
        () => api.categoryApi.recipesInCategory(category: 'category'),
      ).called(1);
    });

    test('fetchRecipe', () async {
      when(() => api.recipeApi.recipeDetails(id: any(named: 'id'))).thenAnswer(
        (_) async => ResponseMock<FakeRecipe>(data: FakeRecipe()),
      );

      final recipe = await DataRepository().fetchRecipe('id');

      expect(recipe, isA<Recipe>());
      verify(() => api.recipeApi.recipeDetails(id: 'id')).called(1);
    });

    test('updateRecipe', () async {
      final recipe = FakeRecipe();
      when(
        () => api.recipeApi.updateRecipe(id: recipe.id, recipe: recipe),
      ).thenAnswer(
        (invocation) async => ResponseMock<String>(data: recipe.id),
      );

      final id = await DataRepository().updateRecipe(recipe);

      expect(id, recipe.id);
      verify(() => api.recipeApi.updateRecipe(id: recipe.id, recipe: recipe))
          .called(1);
    });

    test('createRecipe', () async {
      final recipe = FakeRecipe();
      when(
        () => api.recipeApi.newRecipe(recipe: recipe),
      ).thenAnswer(
        (invocation) async => ResponseMock<String>(data: recipe.id),
      );

      final id = await DataRepository().createRecipe(recipe);

      expect(id, recipe.id);
      verify(() => api.recipeApi.newRecipe(recipe: recipe)).called(1);
    });

    test('deleteRecipe', () async {
      final recipe = FakeRecipe();
      when(
        () => api.recipeApi.deleteRecipe(id: recipe.id),
      ).thenAnswer(
        (invocation) async => ResponseMock<String>(data: recipe.id),
      );

      final id = await DataRepository().deleteRecipe(recipe);

      expect(id, recipe.id);
      verify(() => api.recipeApi.deleteRecipe(id: recipe.id)).called(1);
    });

    test('importRecipe', () async {
      final url = UrlBuilder()..url = 'testUrl';
      when(
        () => api.recipeApi.callImport(url: url.build()),
      ).thenAnswer(
        (invocation) async => ResponseMock<FakeRecipe>(),
      );

      await DataRepository().importRecipe(url.url!);

      verify(() => api.recipeApi.callImport(url: url.build())).called(1);
    });

    test('fetchCategories', () async {});

    test('fetchCategoryMainRecipes', () async {});

    test('fetchAllRecipes', () async {});

    test('getUserAvatarUrl', () async {});

    test('getMatchingCategoryNames', () async {});

    test('fetchImage', () async {});
  });
}
