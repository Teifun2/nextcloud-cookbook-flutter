part of 'services.dart';

class ApiProvider {
  static final ApiProvider _apiProvider = ApiProvider._();

  factory ApiProvider() => _apiProvider;
  ApiProvider._() {
    final auth = UserRepository().currentAppAuthentication;

    ncCookbookApi = NcCookbookApi(
      dio: Dio(
        BaseOptions(
          baseUrl: '${auth.server}/apps/cookbook',
          connectTimeout: const Duration(milliseconds: 30000),
          receiveTimeout: const Duration(milliseconds: 30000),
        ),
      ),
    );

    ncCookbookApi.setBasicAuth(
      "app_password",
      auth.loginName,
      auth.password,
    );
    recipeApi = ncCookbookApi.getRecipesApi();
    categoryApi = ncCookbookApi.getCategoriesApi();
    miscApi = ncCookbookApi.getMiscApi();
    tagsApi = ncCookbookApi.getTagsApi();
  }

  late NcCookbookApi ncCookbookApi;
  late RecipesApi recipeApi;
  late CategoriesApi categoryApi;
  late MiscApi miscApi;
  late TagsApi tagsApi;
}
