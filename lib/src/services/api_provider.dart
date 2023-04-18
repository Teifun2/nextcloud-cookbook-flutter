part of 'services.dart';

class ApiProvider {
  factory ApiProvider() => _apiProvider ??= ApiProvider._();

  // coverage:ignore-start
  @visibleForTesting
  factory ApiProvider.mocked(ApiProvider mock) => _apiProvider ??= mock;
  // coverage:ignore-end

  ApiProvider._() {
    final auth = UserRepository().currentAppAuthentication;

    final client = Dio(
      BaseOptions(
        baseUrl: '${auth.server}/apps/cookbook',
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
      ),
    )..httpClientAdapter = IOHttpClientAdapter(
        onHttpClientCreate: (client) =>
            client..badCertificateCallback = (cert, host, port) => true,
      );

    if (auth.isSelfSignedCertificate) {
      client.httpClientAdapter = IOHttpClientAdapter(
        onHttpClientCreate: (client) =>
            client..badCertificateCallback = (cert, host, port) => true,
      );
    }

    ncCookbookApi = NcCookbookApi(
      dio: client,
    );

    ncCookbookApi.setBasicAuth(
      'app_password',
      auth.loginName,
      auth.password,
    );
    recipeApi = ncCookbookApi.getRecipesApi();
    categoryApi = ncCookbookApi.getCategoriesApi();
    miscApi = ncCookbookApi.getMiscApi();
    tagsApi = ncCookbookApi.getTagsApi();
  }
  static ApiProvider? _apiProvider;

  late NcCookbookApi ncCookbookApi;
  late RecipesApi recipeApi;
  late CategoriesApi categoryApi;
  late MiscApi miscApi;
  late TagsApi tagsApi;
}
