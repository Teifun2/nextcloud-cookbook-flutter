/// Parses the content of a LoginQr
///
/// The result will be like:
/// ```dart
/// {
///  'user': 'admin',
///  'password': 'superSecret',
///  'server': 'https://example.com',
/// }
/// ```
Map<String, String> parseNCLoginQR(Uri uri) {
  return uri.path.split('&').map((e) {
    final parts = e.split(':');
    final key = parts[0].replaceFirst(RegExp('/'), '');
    parts.removeAt(0);
    return {key: parts.join(':')};
  }).fold({}, (p, e) => p..addAll(e));
}
