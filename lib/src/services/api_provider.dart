part of 'services.dart';

class ApiProvider {
  factory ApiProvider() => _apiProvider;
  ApiProvider._();
  static final ApiProvider _apiProvider = ApiProvider._();

  Future<void> initialize() async {
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

    final documentsDir = await getApplicationDocumentsDirectory();

    // Global options
    final options = CacheOptions(
      // A default store is required for interceptor.
      store: SembastCacheStore(storePath: documentsDir.path),

      // All subsequent fields are optional.

      // Default.
      policy: CachePolicy.noCache,
      // Returns a cached response on error but for statuses 401 & 403.
      // Also allows to return a cached response on network errors (e.g. offline usage).
      // Defaults to [null].
      hitCacheOnErrorExcept: [401, 403],
      // Overrides any HTTP directive to delete entry past this duration.
      // Useful only when origin server has no cache config or custom behaviour is desired.
      // Defaults to [null].
      maxStale: const Duration(days: 7),
      // Default. Allows 3 cache sets and ease cleanup.
      priority: CachePriority.normal,
      // Default. Body and headers encryption with your own algorithm.
      cipher: null,
      // Default. Key builder to retrieve requests.
      keyBuilder: CacheOptions.defaultCacheKeyBuilder,
      // Default. Allows to cache POST requests.
      // Overriding [keyBuilder] is strongly recommended when [true].
      allowPostMethod: false,
    );

    ncCookbookApi = NcCookbookApi(
      basePathOverride: '${auth.server}/apps/cookbook',
      interceptors: [
        BasicAuthInterceptor(),
        DioCacheInterceptor(options: options),
      ],
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

  late NcCookbookApi ncCookbookApi;
  late RecipesApi recipeApi;
  late CategoriesApi categoryApi;
  late MiscApi miscApi;
  late TagsApi tagsApi;
}
