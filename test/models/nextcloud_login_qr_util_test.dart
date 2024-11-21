import 'package:flutter_test/flutter_test.dart';
import 'package:nextcloud_cookbook_flutter/src/util/nextcloud_login_qr_util.dart';

void main() {
  const username = 'admin';
  const password = 'superSecret';
  const server = 'https://example.com';

  final content =
      Uri.parse('nc://login/user:$username&password:$password&server:$server');

  test('parseNCLoginQR', () {
    expect(parseNCLoginQR(content), {
      'user': username,
      'password': password,
      'server': server,
    });
  });
}
