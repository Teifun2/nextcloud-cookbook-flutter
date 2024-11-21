part of 'services.dart';

class UserRepository {
  factory UserRepository() => _userRepository;

  UserRepository._();
  // Singleton
  static final UserRepository _userRepository = UserRepository._();

  AppAuthentication? _currentAppAuthentication;

  AppAuthentication get currentAppAuthentication => _currentAppAuthentication!;

  static const _authKey = 'appAuthentication';

  bool get hasAuthentidation => _currentAppAuthentication != null;

  /// Loads the authentication from storage
  ///
  /// Throws a [LoadAuthException] when none is saved.
  Future<void> loadAppAuthentication() async {
    final auth = await const FlutterSecureStorage().read(key: _authKey);
    if (auth == null || auth.isEmpty) {
      throw LoadAuthException();
    }
    _currentAppAuthentication = AppAuthentication.fromJsonString(auth);
  }

  Future<bool> checkAppAuthentication() async {
    if (!hasAuthentidation) {
      return false;
    }
    try {
      await ApiProvider().miscApi.version();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> persistAppAuthentication(
    AppAuthentication appAuthentication,
  ) async {
    _currentAppAuthentication = appAuthentication;
    await const FlutterSecureStorage().write(
      key: _authKey,
      value: appAuthentication.toJsonString(),
    );
  }

  Future<void> deleteAppAuthentication() async {
    try {
      await Dio().delete(
        '${currentAppAuthentication.server}/ocs/v2.php/core/apppassword',
        options: Options(
          headers: {
            'Authorization': AppAuthentication.parsePassword(
              currentAppAuthentication.loginName,
              currentAppAuthentication.appPassword,
            ),
            'OCS-APIREQUEST': 'true',
          },
        ),
      );
    } on DioError {
      debugPrint(translate('login.errors.failed_remove_remote'));
    }

    _currentAppAuthentication = null;
    await const FlutterSecureStorage().delete(key: _authKey);
  }

  bool isVersionSupported(APIVersion version) =>
      ApiProvider().ncCookbookApi.isSupportedSync(version);

  Future<APIVersion> fetchApiVersion() async {
    final response = await ApiProvider().miscApi.version();

    return response.data!.apiVersion;
  }
}
