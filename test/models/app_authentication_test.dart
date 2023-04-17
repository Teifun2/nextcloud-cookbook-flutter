import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';

void main() {
  const server = 'https://example.com';
  const loginName = 'admin';
  const password = 'password';
  final basicAuth = 'Basic ${base64Encode(
    utf8.encode(
      '$loginName:$password',
    ),
  )}';
  const isSelfSignedCertificate = false;

  final auth = AppAuthentication(
    server: server,
    loginName: loginName,
    basicAuth: basicAuth,
    isSelfSignedCertificate: isSelfSignedCertificate,
  );

  final encodedJson =
      '"{\\"server\\":\\"$server\\",\\"loginName\\":\\"$loginName\\",\\"basicAuth\\":\\"$basicAuth\\",\\"isSelfSignedCertificate\\":$isSelfSignedCertificate}"';
  final jsonBasicAuth =
      '{"server":"$server","loginName":"$loginName","basicAuth":"$basicAuth","isSelfSignedCertificate":$isSelfSignedCertificate}';
  const jsonPassword =
      '{"server":"$server","loginName":"$loginName","appPassword":"$password","isSelfSignedCertificate":$isSelfSignedCertificate}';

  group(AppAuthentication, () {
    test('toJson', () {
      expect(jsonEncode(auth.toJsonString()), equals(encodedJson));
    });

    test('fromJson', () {
      expect(
        AppAuthentication.fromJsonString(jsonBasicAuth),
        equals(auth),
      );
      expect(
        AppAuthentication.fromJsonString(jsonPassword),
        equals(auth),
      );
    });

    test('password', () {
      expect(auth.password, equals(password));
    });

    test('parseBasicAuth', () {
      expect(
        AppAuthentication.parseBasicAuth(loginName, password),
        equals(basicAuth),
      );
    });

    test('toJson does not contain password', () {
      expect(auth.toString(), isNot(contains(basicAuth)));
    });
  });
}
