part of 'services.dart';

class UserRepository {
  // Singleton
  static final UserRepository _userRepository = UserRepository._();
  factory UserRepository() => _userRepository;

  UserRepository._();

  AuthenticationProvider authenticationProvider = AuthenticationProvider();
  VersionProvider versionProvider = VersionProvider();

  Future<AppAuthentication> authenticate(
    String serverUrl,
    String username,
    String originalBasicAuth, {
    required bool isSelfSignedCertificate,
  }) async {
    return authenticationProvider.authenticate(
      serverUrl: serverUrl,
      username: username,
      originalBasicAuth: originalBasicAuth,
      isSelfSignedCertificate: isSelfSignedCertificate,
    );
  }

  Future<AppAuthentication> authenticateAppPassword(
    String serverUrl,
    String username,
    String basicAuth, {
    required bool isSelfSignedCertificate,
  }) async {
    return authenticationProvider.authenticateAppPassword(
      serverUrl: serverUrl,
      username: username,
      basicAuth: basicAuth,
      isSelfSignedCertificate: isSelfSignedCertificate,
    );
  }

  void stopAuthenticate() {
    authenticationProvider.stopAuthenticate();
  }

  AppAuthentication get currentAppAuthentication {
    return authenticationProvider.currentAppAuthentication!;
  }

  Dio get authenticatedClient {
    return currentAppAuthentication.authenticatedClient;
  }

  Future<bool> hasAppAuthentication() async {
    return authenticationProvider.hasAppAuthentication();
  }

  Future<void> loadAppAuthentication() async {
    return authenticationProvider.loadAppAuthentication();
  }

  Future<bool> checkAppAuthentication() async {
    return authenticationProvider.checkAppAuthentication(
      currentAppAuthentication.server,
      currentAppAuthentication.basicAuth,
      isSelfSignedCertificate: currentAppAuthentication.isSelfSignedCertificate,
    );
  }

  Future<void> persistAppAuthentication(
    AppAuthentication appAuthentication,
  ) async {
    return authenticationProvider.persistAppAuthentication(appAuthentication);
  }

  Future<void> deleteAppAuthentication() async {
    return authenticationProvider.deleteAppAuthentication();
  }

  Future<ApiVersion> fetchApiVersion() async {
    return versionProvider.fetchApiVersion();
  }

  AndroidApiVersion getAndroidVersion() {
    return versionProvider.getApiVersion().getAndroidVersion();
  }
}
