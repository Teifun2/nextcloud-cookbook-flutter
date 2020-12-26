import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';

class AppAuthentication {
  String server;
  String loginName;
  String basicAuth;
  bool selfSignedCertificate;

  Dio authenticatedClient;

  AppAuthentication({
    this.server,
    this.loginName,
    this.basicAuth,
    this.selfSignedCertificate,
  }) {
    authenticatedClient = Dio();
    authenticatedClient.options.headers["authorization"] = basicAuth;
    authenticatedClient.options.headers["User-Agent"] = "Cookbook App";
    authenticatedClient.options.responseType = ResponseType.plain;

    if (selfSignedCertificate) {
      (authenticatedClient.httpClientAdapter as DefaultHttpClientAdapter)
          .onHttpClientCreate = (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
      };
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

    bool selfSignedCertificate = jsonData.containsKey("selfSignedCertificate")
        ? jsonData['selfSignedCertificate']
        : false;

    return AppAuthentication(
        server: jsonData["server"],
        loginName: jsonData["loginName"],
        basicAuth: basicAuth,
        selfSignedCertificate: selfSignedCertificate);
  }

  String toJson() {
    return json.encode({
      "server": server,
      "loginName": loginName,
      "basicAuth": basicAuth,
      "selfSignedCertificate": selfSignedCertificate,
    });
  }

  @override
  String toString() =>
      'LoggedIn { token: $server, $loginName, selfSignedCertificate $selfSignedCertificate}';
}
