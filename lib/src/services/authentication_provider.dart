part of 'services.dart';

// coverage:ignore-start
class AuthenticationProvider {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final String _appAuthenticationKey = 'appAuthentication';
  AppAuthentication? currentAppAuthentication;
  dio.CancelToken? _cancelToken;

  Future<AppAuthentication> authenticate({
    required String serverUrl,
    required String username,
    required String originalBasicAuth,
    required bool isSelfSignedCertificate,
  }) async {
    assert(URLUtils.isSanitized(serverUrl));

    final urlInitialCall = '$serverUrl/ocs/v2.php/core/getapppassword';

    dio.Response response;
    try {
      final client = dio.Dio();
      if (isSelfSignedCertificate) {
        client.httpClientAdapter = IOHttpClientAdapter(
          onHttpClientCreate: (client) {
            client.badCertificateCallback = (cert, host, port) => true;
            return client;
          },
        );
      }

      response = await client.get(
        urlInitialCall,
        options: dio.Options(
          headers: {
            'OCS-APIREQUEST': 'true',
            'User-Agent': 'Cookbook App',
            'authorization': originalBasicAuth
          },
          validateStatus: (status) => status! < 500,
        ),
        cancelToken: _cancelToken,
      );
    } on dio.DioError catch (e) {
      if (e.message?.contains('SocketException') ?? false) {
        throw translate(
          'login.errors.not_reachable',
          args: {'server_url': serverUrl, 'error_msg': e},
        );
      } else if (e.message?.contains('CERTIFICATE_VERIFY_FAILED') ?? false) {
        throw translate(
          'login.errors.certificate_failed',
          args: {'server_url': serverUrl, 'error_msg': e},
        );
      }
      throw translate('login.errors.request_failed', args: {'error_msg': e});
    }
    _cancelToken = null;

    if (response.statusCode == 200) {
      String appPassword;
      try {
        appPassword = XmlDocument.parse(response.data as String)
            .findAllElements('apppassword')
            .first
            .text;
      } on XmlParserException catch (e) {
        throw translate('login.errors.parse_failed', args: {'error_msg': e});
        // ignore: avoid_catching_errors
      } on StateError catch (e) {
        throw translate('login.errors.parse_missing', args: {'error_msg': e});
      }

      final basicAuth = AppAuthentication.parseBasicAuth(username, appPassword);

      return AppAuthentication(
        server: serverUrl,
        loginName: username,
        basicAuth: basicAuth,
        isSelfSignedCertificate: isSelfSignedCertificate,
      );
    } else if (response.statusCode == 401) {
      throw translate('login.errors.auth_failed');
    } else {
      throw translate(
        'login.errors.failure',
        args: {
          'status_code': response.statusCode,
          'status_message': response.statusMessage,
        },
      );
    }
  }

  Future<AppAuthentication> authenticateAppPassword({
    required String serverUrl,
    required String username,
    required String basicAuth,
    required bool isSelfSignedCertificate,
  }) async {
    assert(URLUtils.isSanitized(serverUrl));

    bool authenticated;
    try {
      authenticated = await checkAppAuthentication(
        serverUrl,
        basicAuth,
        isSelfSignedCertificate: isSelfSignedCertificate,
      );
    } on dio.DioError catch (e) {
      if (e.message?.contains('SocketException') ?? false) {
        throw translate(
          'login.errors.not_reachable',
          args: {'server_url': serverUrl, 'error_msg': e},
        );
      } else if (e.message?.contains('CERTIFICATE_VERIFY_FAILED') ?? false) {
        throw translate(
          'login.errors.certificate_failed',
          args: {'server_url': serverUrl, 'error_msg': e},
        );
      }
      throw translate('login.errors.request_failed', args: {'error_msg': e});
    }

    if (authenticated) {
      return AppAuthentication(
        server: serverUrl,
        loginName: username,
        basicAuth: basicAuth,
        isSelfSignedCertificate: isSelfSignedCertificate,
      );
    } else {
      throw translate('login.errors.auth_failed');
    }
  }

  void stopAuthenticate() {
    _cancelToken?.cancel('Stopped by the User!');
    _cancelToken = null;
  }

  Future<bool> hasAppAuthentication() async {
    if (currentAppAuthentication != null) {
      return true;
    } else {
      final appAuthentication =
          await _secureStorage.read(key: _appAuthenticationKey);
      return appAuthentication != null;
    }
  }

  Future<void> loadAppAuthentication() async {
    final appAuthenticationString =
        await _secureStorage.read(key: _appAuthenticationKey);
    if (appAuthenticationString == null) {
      throw translate('login.errors.authentication_not_found');
    } else {
      currentAppAuthentication =
          AppAuthentication.fromJsonString(appAuthenticationString);
    }
  }

  /// If server response is 401 Unauthorized the AppPassword is (no longer?) valid!
  Future<bool> checkAppAuthentication(
    String serverUrl,
    String basicAuth, {
    required bool isSelfSignedCertificate,
  }) async {
    final urlAuthCheck = '$serverUrl/index.php/apps/cookbook/api/v1/categories';

    dio.Response response;
    try {
      final client = dio.Dio();
      if (isSelfSignedCertificate) {
        client.httpClientAdapter = IOHttpClientAdapter(
          onHttpClientCreate: (client) {
            client.badCertificateCallback = (cert, host, port) => true;
            return client;
          },
        );
      }
      response = await client.get(
        urlAuthCheck,
        options: dio.Options(
          headers: {'authorization': basicAuth},
          validateStatus: (status) => status! < 500,
        ),
      );
    } on dio.DioError catch (e) {
      throw translate(
        'login.errors.no_internet',
        args: {
          'error_msg': e.message,
        },
      );
    }

    if (response.statusCode == 401) {
      return false;
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw translate(
        'login.errors.wrong_status',
        args: {
          'error_msg': response.statusCode,
        },
      );
    }
  }

  Future<void> persistAppAuthentication(
    AppAuthentication appAuthentication,
  ) async {
    currentAppAuthentication = appAuthentication;
    await _secureStorage.write(
      key: _appAuthenticationKey,
      value: appAuthentication.toJsonString(),
    );
  }

  Future<void> deleteAppAuthentication() async {
    dio.Response? response;
    try {
      response = await currentAppAuthentication?.authenticatedClient.delete(
        '${currentAppAuthentication!.server}/ocs/v2.php/core/apppassword',
        options: dio.Options(
          headers: {
            'OCS-APIREQUEST': 'true',
          },
        ),
      );
    } on dio.DioError {
      debugPrint(translate('login.errors.failed_remove_remote'));
    }

    if (response != null && response.statusCode != 200) {
      debugPrint(translate('login.errors.failed_remove_remote'));
    }

    currentAppAuthentication = null;
    await _secureStorage.delete(key: _appAuthenticationKey);
  }
}
// coverage:ignore-end
