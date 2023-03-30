import 'package:flutter/foundation.dart';

class ImageResponse {
  final Uint8List data;
  final bool isSvg;

  const ImageResponse({
    required this.data,
    required this.isSvg,
  });
}
