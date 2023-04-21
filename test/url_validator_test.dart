import 'package:flutter_test/flutter_test.dart';
import 'package:nextcloud_cookbook_flutter/src/util/url_validator.dart';

void main() {
  group('URLUtils', () {
    test('.isValid() validates a url', () {
      const emptyUrl = '';
      expect(URLUtils.isValid(emptyUrl), false);
      const validUrl = 'http://foo.bar';
      expect(URLUtils.isValid(validUrl), true);
      const noProtocol = 'foo.bar';
      expect(URLUtils.isValid(noProtocol), true);
      const punycodeUrl = 'https://öüäööß.foo.bar/';
      expect(URLUtils.isValid(punycodeUrl), true);
      const missingTLD = 'https://foo/bar';
      expect(URLUtils.isValid(missingTLD), false);
    });

    test('.isSanitized() check sanitized', () {
      const dirtyUrl = 'foo.bar/cloud/';
      expect(URLUtils.isSanitized(dirtyUrl), false);

      const cleanUrl = 'http://foo.bar';
      expect(URLUtils.isSanitized(cleanUrl), true);
    });

    test('.sanitizeUrl() sanitizes URL', () {
      const insecureUrl = 'http://foo.bar';
      expect(URLUtils.sanitizeUrl(insecureUrl), equals('http://foo.bar'));
      const secureUrl = 'https://foo.bar/';
      expect(URLUtils.sanitizeUrl(secureUrl), equals('https://foo.bar'));
      const plainDomain = 'foo.bar/';
      expect(URLUtils.sanitizeUrl(plainDomain), equals('https://foo.bar'));
      const subdirUrl = 'foo.bar/cloud/';
      expect(URLUtils.sanitizeUrl(subdirUrl), equals('https://foo.bar/cloud'));
    });
  });
}
