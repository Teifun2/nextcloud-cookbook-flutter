import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nextcloud_cookbook_flutter/src/util/self_signed_certificate_http_overrides.dart';

class AppAuthentication {
  final String server;
  final String loginName;
  final String basicAuth;
  final bool isSelfSignedCertificate;

  final Dio authenticatedClient = Dio();

  AppAuthentication({
    required this.server,
    required this.loginName,
    required this.basicAuth,
    required this.isSelfSignedCertificate,
  }) {
    authenticatedClient.options.headers["authorization"] = basicAuth;
    authenticatedClient.options.headers["User-Agent"] = "Cookbook App";
    authenticatedClient.options.responseType = ResponseType.plain;

    if (isSelfSignedCertificate) {
      HttpOverrides.global = new SelfSignedCertificateHttpOverride();
    }
  }

  factory AppAuthentication.fromJson(String jsonString) {
    Map<String, dynamic> jsonData = json.decode(jsonString);

    String basicAuth = jsonData.containsKey("basicAuth")
        ? jsonData['basicAuth']
        : 'Basic ' +
            base64Encode(
              utf8.encode(
                '${jsonData["loginName"]}:${jsonData["appPassword"]}',
              ),
            );

    bool selfSignedCertificate = jsonData.containsKey("isSelfSignedCertificate")
        ? jsonData['isSelfSignedCertificate']
        : false;

    return AppAuthentication(
        server: jsonData["server"],
        loginName: jsonData["loginName"],
        basicAuth: basicAuth,
        isSelfSignedCertificate: selfSignedCertificate);
  }

  String toJson() {
    return json.encode({
      "server": server,
      "loginName": loginName,
      "basicAuth": basicAuth,
      "isSelfSignedCertificate": isSelfSignedCertificate,
    });
  }

  @override
  String toString() =>
      'LoggedIn { token: $server, $loginName, isSelfSignedCertificate $isSelfSignedCertificate}';
}
