part of 'services.dart';

class UserRepository {
  factory UserRepository() => _userRepository ??= const UserRepository._();

  // coverage:ignore-start
  @visibleForTesting
  factory UserRepository.mocked(UserRepository mock) =>
      _userRepository ??= mock;
  // coverage:ignore-end

  const UserRepository._();
  // Singleton
  static UserRepository? _userRepository;

  static final authenticationProvider = AuthenticationProvider();

  Future<AppAuthentication> authenticate(
    String serverUrl,
    String username,
    String originalBasicAuth, {
    required bool isSelfSignedCertificate,
  }) async =>
      authenticationProvider.authenticate(
        serverUrl: serverUrl,
        username: username,
        originalBasicAuth: originalBasicAuth,
        isSelfSignedCertificate: isSelfSignedCertificate,
      );

  Future<AppAuthentication> authenticateAppPassword(
    String serverUrl,
    String username,
    String basicAuth, {
    required bool isSelfSignedCertificate,
  }) async =>
      authenticationProvider.authenticateAppPassword(
        serverUrl: serverUrl,
        username: username,
        basicAuth: basicAuth,
        isSelfSignedCertificate: isSelfSignedCertificate,
      );

  void stopAuthenticate() {
    authenticationProvider.stopAuthenticate();
  }

  AppAuthentication get currentAppAuthentication =>
      authenticationProvider.currentAppAuthentication!;

  Dio get authenticatedClient => currentAppAuthentication.authenticatedClient;

  Future<bool> hasAppAuthentication() async =>
      authenticationProvider.hasAppAuthentication();

  Future<void> loadAppAuthentication() async =>
      authenticationProvider.loadAppAuthentication();

  Future<bool> checkAppAuthentication() async =>
      authenticationProvider.checkAppAuthentication(
        currentAppAuthentication.server,
        currentAppAuthentication.basicAuth,
        isSelfSignedCertificate:
            currentAppAuthentication.isSelfSignedCertificate,
      );

  Future<void> persistAppAuthentication(
    AppAuthentication appAuthentication,
  ) async =>
      authenticationProvider.persistAppAuthentication(appAuthentication);

  Future<void> deleteAppAuthentication() async =>
      authenticationProvider.deleteAppAuthentication();

  bool isVersionSupported(APIVersion version) =>
      ApiProvider().ncCookbookApi.isSupportedSync(version);

  Future<APIVersion> fetchApiVersion() async {
    final response = await ApiProvider().miscApi.version();

    return response.data!.apiVersion;
  }
}
