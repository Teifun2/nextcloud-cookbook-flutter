import 'package:punycode/punycode.dart';

/// Utilities for validating and eycaping urls
class URLUtils {
  const URLUtils._(); // coverage:ignore-line

  /// Validates a given [url].
  ///
  /// Punycode urls are encoded before checking.
  /// Example:
  /// ```dart
  /// print(URLUtils.isValid('http://foo.bar'); // true
  /// print(URLUtils.isValid('foo.bar'); // true
  /// print(URLUtils.isValid('https://öüäööß.foo.bar/'); // true
  /// print(URLUtils.isValid('https://foo/bar'); // false
  /// print(URLUtils.isValid(''); // false
  /// ```
  static bool isValid(String url) {
    const urlPattern =
        r"^(?:http(s)?:\/\/)?[\w.-]+(?:(?:\.[\w\.-]+)|(?:\:\d+))+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]*$";
    return RegExp(urlPattern, caseSensitive: false)
        .hasMatch(_punyEncodeUrl(url));
  }

  /// Punycode encodes an entire [url].
  static String _punyEncodeUrl(String url) {
    var prefix = '';
    var punycodeUrl = url;
    if (url.startsWith('https://')) {
      punycodeUrl = url.replaceFirst('https://', '');
      prefix = 'https://';
    } else if (url.startsWith('http://')) {
      punycodeUrl = url.replaceFirst('http://', '');
      prefix = 'http://';
    }

    const pattern = r'(?:\.|^)([^.]*?[^\x00-\x7F][^.]*?)(?:\.|$)';
    final expression = RegExp(pattern, caseSensitive: false);

    final matches = expression.allMatches(punycodeUrl);
    for (final exp in matches) {
      final match = exp.group(1)!;

      punycodeUrl =
          punycodeUrl.replaceFirst(match, 'xn--${punycodeEncode(match)}');
    }

    return prefix + punycodeUrl;
  }

  /// Checks if the url has been sanitized
  static bool isSanitized(String url) => url == sanitizeUrl(url);

  /// Sanitizes a given [url].
  ///
  /// Strips trailing `/` and guesses the protocol to be `https` when not specified.
  /// Throws a `FormatException` when the url cannot be validated with [URLUtils.isValid].
  ///
  /// Example:
  /// ```dart
  /// print(URLUtils.sanitizeUrl('http://foo.bar'); // http://foo.bar
  /// print(URLUtils.sanitizeUrl('http://foo.bar/'); // http://foo.bar
  /// print(URLUtils.sanitizeUrl('https://foo.bar'); // https://foo.bar
  /// print(URLUtils.sanitizeUrl('foo.bar'); // https://foo.bar
  /// print(URLUtils.sanitizeUrl('foo.bar/cloud/'); // https://foo.bar/cloud
  /// print(URLUtils.sanitizeUrl(''); // FormatException
  /// ```
  static String sanitizeUrl(String url) {
    if (!isValid(url)) {
      throw const FormatException(
        'given url is not valid. Please validate first with URLUtils.isValid(url)',
      );
    }

    var encodedUrl = _punyEncodeUrl(url);
    if (encodedUrl.substring(0, 4) != 'http') {
      encodedUrl = 'https://$encodedUrl';
    }
    if (encodedUrl.endsWith('/')) {
      encodedUrl = encodedUrl.substring(0, encodedUrl.length - 1);
    }

    return encodedUrl;
  }
}
