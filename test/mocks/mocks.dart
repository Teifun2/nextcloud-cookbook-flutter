import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nc_cookbook_api/nc_cookbook_api.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

class ApiMock extends Mock implements ApiProvider {
  final _recipesApi = RecipesApiMock();
  final _categoriesApi = CategoriesApiMock();
  final _miscApi = MiscApiMock();
  final _tagsApi = TagsApiMock();

  @override
  RecipesApi get recipeApi => _recipesApi;
  @override
  CategoriesApi get categoryApi => _categoriesApi;
  @override
  MiscApi get miscApi => _miscApi;
  @override
  TagsApi get tagsApi => _tagsApi;
}

class RecipesApiMock extends Mock implements RecipesApi {}

class CategoriesApiMock extends Mock implements CategoriesApi {}

class MiscApiMock extends Mock implements MiscApi {}

class TagsApiMock extends Mock implements TagsApi {}

class ResponseMock<T> extends Mock implements Response<T> {
  ResponseMock({this.data});

  @override
  T? data;
}

class FakeRecipeStub extends Fake implements RecipeStub {}

class FakeRecipe extends Fake implements Recipe {
  @override
  String get id => 'some ID';
}

class FakeUrl extends Fake implements Url {}
