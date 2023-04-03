import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_authentication.g.dart';

@JsonSerializable()
class AppAuthentication extends Equatable {
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
    authenticatedClient.options
      ..headers["authorization"] = basicAuth
      ..headers["User-Agent"] = "Cookbook App"
      ..responseType = ResponseType.plain;

    if (isSelfSignedCertificate) {
      authenticatedClient.httpClientAdapter = IOHttpClientAdapter(
        onHttpClientCreate: (client) {
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        },
      );
    }
  }

  factory AppAuthentication.fromJsonString(String jsonString) =>
      AppAuthentication.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );

  factory AppAuthentication.fromJson(Map<String, dynamic> jsonData) {
    try {
      return _$AppAuthenticationFromJson(jsonData);
      // ignore: avoid_catching_errors
    } on TypeError {
      final basicAuth = parseBasicAuth(
        jsonData["loginName"] as String,
        jsonData["appPassword"] as String,
      );

      final selfSignedCertificate =
          jsonData['isSelfSignedCertificate'] as bool? ?? false;

      return AppAuthentication(
        server: jsonData["server"] as String,
        loginName: jsonData["loginName"] as String,
        basicAuth: basicAuth,
        isSelfSignedCertificate: selfSignedCertificate,
      );
    }
  }

  String toJsonString() => json.encode(toJson());
  Map<String, dynamic> toJson() => _$AppAuthenticationToJson(this);

  String get password {
    final base64 = basicAuth.substring(6);
    final string = utf8.decode(base64Decode(base64));
    final auth = string.split(":");
    return auth[1];
  }

  static String parseBasicAuth(String loginName, String appPassword) {
    return 'Basic ${base64Encode(utf8.encode('$loginName:$appPassword'))}';
  }

  @override
  String toString() =>
      'LoggedIn { token: $server, $loginName, isSelfSignedCertificate $isSelfSignedCertificate}';

  @override
  List<Object?> get props => [
        server,
        loginName,
        basicAuth,
        isSelfSignedCertificate,
      ];
}
