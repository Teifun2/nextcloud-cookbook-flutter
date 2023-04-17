import 'package:flutter/foundation.dart';

class ImageResponse {
  const ImageResponse({
    required this.data,
    required this.isSvg,
  });
  final Uint8List data;
  final bool isSvg;
}
