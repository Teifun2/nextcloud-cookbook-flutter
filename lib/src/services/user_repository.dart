part of 'services.dart';

class UserRepository {
  factory UserRepository() => _userRepository;

  UserRepository._();
  // Singleton
  static final UserRepository _userRepository = UserRepository._();

  AuthenticationProvider authenticationProvider = AuthenticationProvider();

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

  Future<bool> hasAppAuthentication() async => authenticationProvider.hasAppAuthentication();

  Future<void> loadAppAuthentication() async =>
      authenticationProvider.loadAppAuthentication();

  Future<bool> checkAppAuthentication() async => authenticationProvider.checkAppAuthentication(
      currentAppAuthentication.server,
      currentAppAuthentication.appPassword,
      isSelfSignedCertificate: currentAppAuthentication.isSelfSignedCertificate,
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
