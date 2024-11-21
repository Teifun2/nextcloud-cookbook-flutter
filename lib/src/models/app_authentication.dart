import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_authentication.g.dart';

@JsonSerializable()
class AppAuthentication extends Equatable {
  const AppAuthentication({
    required this.server,
    required this.loginName,
    required this.appPassword,
    required this.isSelfSignedCertificate,
  });

  factory AppAuthentication.fromJsonString(String jsonString) =>
      AppAuthentication.fromJson(
        json.decode(jsonString) as Map<String, dynamic>,
      );

  factory AppAuthentication.fromJson(Map<String, dynamic> jsonData) {
    try {
      return _$AppAuthenticationFromJson(jsonData);
      // ignore: avoid_catching_errors
    } on TypeError {
      final basicAuth = jsonData['basicAuth'] as String?;
      final appPassword =
          jsonData['appPassword'] as String? ?? parseBasicAuth(basicAuth!);

      final selfSignedCertificate =
          jsonData['isSelfSignedCertificate'] as bool? ?? false;

      return AppAuthentication(
        server: jsonData['server'] as String,
        loginName: jsonData['loginName'] as String,
        appPassword: appPassword,
        isSelfSignedCertificate: selfSignedCertificate,
      );
    }
  }
  final String server;
  final String loginName;
  final String appPassword;
  final bool isSelfSignedCertificate;

  String toJsonString() => json.encode(toJson());
  Map<String, dynamic> toJson() => _$AppAuthenticationToJson(this);

  static String parseBasicAuth(String basicAuth) {
    final base64 = basicAuth.substring(6);
    final string = utf8.decode(base64Decode(base64));
    final auth = string.split(':');
    return auth[1];
  }

  static String parsePassword(String loginName, String appPassword) => 'Basic ${base64Encode(utf8.encode('$loginName:$appPassword'))}';

  @override
  String toString() =>
      'LoggedIn { token: $server, $loginName, isSelfSignedCertificate $isSelfSignedCertificate}';

  @override
  List<Object?> get props => [
        server,
        loginName,
        appPassword,
        isSelfSignedCertificate,
      ];
}
