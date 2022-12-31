import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:xml/xml.dart';

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
    String url = serverUrl;
    if (url.substring(0, 4) != 'http') {
      url = 'https://$url';
      if (url.endsWith("/")) {
        url = url.substring(0, url.length - 1);
      }
    }
    final String urlInitialCall = '$url/ocs/v2.php/core/getapppassword';

    dio.Response response;
    try {
      final dio.Dio client = dio.Dio();
      if (isSelfSignedCertificate) {
        (client.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient httpClient) {
          httpClient.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return null;
        };
      }

      response = await client.get(
        urlInitialCall,
        options: dio.Options(
          headers: {
            "OCS-APIREQUEST": "true",
            "User-Agent": "Cookbook App",
            "authorization": originalBasicAuth
          },
          validateStatus: (status) => status! < 500,
        ),
        cancelToken: _cancelToken,
      );
    } on dio.DioError catch (e) {
      if (e.message.contains("SocketException")) {
        throw translate(
          "login.errors.not_reachable",
          args: {"server_url": url, "error_msg": e},
        );
      } else if (e.message.contains("CERTIFICATE_VERIFY_FAILED")) {
        throw translate(
          "login.errors.certificate_failed",
          args: {"server_url": url, "error_msg": e},
        );
      }
      throw translate("login.errors.request_failed", args: {"error_msg": e});
    }
    _cancelToken = null;

    if (response.statusCode == 200) {
      String appPassword;
      try {
        appPassword = XmlDocument.parse(response.data as String)
            .findAllElements("apppassword")
            .first
            .text;
      } on XmlParserException catch (e) {
        throw translate("login.errors.parse_failed", args: {"error_msg": e});
      } on StateError catch (e) {
        throw translate("login.errors.parse_missing", args: {"error_msg": e});
      }

      final String basicAuth =
          'Basic ${base64Encode(utf8.encode('$username:$appPassword'))}';

      return AppAuthentication(
        server: url,
        loginName: username,
        basicAuth: basicAuth,
        isSelfSignedCertificate: isSelfSignedCertificate,
      );
    } else if (response.statusCode == 401) {
      throw translate("login.errors.auth_failed");
    } else {
      throw translate(
        "login.errors.failure",
        args: {
          "status_code": response.statusCode,
          "status_message": response.statusMessage,
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
    String url = serverUrl;
    if (url.substring(0, 4) != 'http') {
      url = 'https://$url';
    }

    bool authenticated;
    try {
      authenticated = await checkAppAuthentication(
        url,
        basicAuth,
        isSelfSignedCertificate,
      );
    } on dio.DioError catch (e) {
      if (e.message.contains("SocketException")) {
        throw translate(
          "login.errors.not_reachable",
          args: {"server_url": url, "error_msg": e},
        );
      } else if (e.message.contains("CERTIFICATE_VERIFY_FAILED")) {
        throw translate(
          "login.errors.certificate_failed",
          args: {"server_url": url, "error_msg": e},
        );
      }
      throw translate("login.errors.request_failed", args: {"error_msg": e});
    }

    if (authenticated) {
      return AppAuthentication(
        server: url,
        loginName: username,
        basicAuth: basicAuth,
        isSelfSignedCertificate: isSelfSignedCertificate,
      );
    } else {
      throw translate("login.errors.auth_failed");
    }
  }

  void stopAuthenticate() {
    _cancelToken?.cancel("Stopped by the User!");
    _cancelToken = null;
  }

  Future<bool> hasAppAuthentication() async {
    if (currentAppAuthentication != null) {
      return true;
    } else {
      final String? appAuthentication =
          await _secureStorage.read(key: _appAuthenticationKey);
      return appAuthentication != null;
    }
  }

  Future<void> loadAppAuthentication() async {
    final String? appAuthenticationString =
        await _secureStorage.read(key: _appAuthenticationKey);
    if (appAuthenticationString == null) {
      throw translate('login.errors.authentication_not_found');
    } else {
      currentAppAuthentication =
          AppAuthentication.fromJson(appAuthenticationString);
    }
  }

  /// If server response is 401 Unauthorized the AppPassword is (no longer?) valid!
  Future<bool> checkAppAuthentication(
    String serverUrl,
    String basicAuth,
    bool isSelfSignedCertificate,
  ) async {
    final String urlAuthCheck =
        '$serverUrl/index.php/apps/cookbook/api/v1/categories';

    dio.Response response;
    try {
      final dio.Dio client = dio.Dio();
      if (isSelfSignedCertificate) {
        (client.httpClientAdapter as DefaultHttpClientAdapter)
            .onHttpClientCreate = (HttpClient httpClient) {
          httpClient.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return null;
        };
      }
      response = await client.get(
        urlAuthCheck,
        options: dio.Options(
          headers: {"authorization": basicAuth},
          validateStatus: (status) => status! < 500,
        ),
      );
    } on dio.DioError catch (e) {
      throw translate(
        "login.errors.no_internet",
        args: {
          "error_msg": e.message,
        },
      );
    }

    if (response.statusCode == 401) {
      return false;
    } else if (response.statusCode == 200) {
      return true;
    } else {
      throw translate(
        "login.errors.wrong_status",
        args: {
          "error_msg": response.statusCode,
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
      value: appAuthentication.toJson(),
    );
  }

  Future<void> deleteAppAuthentication() async {
    dio.Response? response;
    try {
      response = await currentAppAuthentication?.authenticatedClient.delete(
        "${currentAppAuthentication!.server}/ocs/v2.php/core/apppassword",
        options: dio.Options(
          headers: {
            "OCS-APIREQUEST": "true",
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
