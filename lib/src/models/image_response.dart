import 'package:flutter/foundation.dart';

// coverage:ignore-start
class ImageResponse {
  const ImageResponse({
    required this.data,
    required this.isSvg,
  });
  final Uint8List data;
  final bool isSvg;
}
// coverage:ignore-end
