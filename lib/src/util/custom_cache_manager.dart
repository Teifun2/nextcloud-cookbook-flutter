import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/io_client.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

class CustomCacheManager {
  static final CustomCacheManager _instance = CustomCacheManager._();

  factory CustomCacheManager() => _instance;

  CustomCacheManager._();

  static const key = 'customCacheKey';
  final UserRepository _userRepository = UserRepository();

  final CacheManager _selfSignedCacheManager = CacheManager(
    Config(
      key,
      fileService: HttpFileService(
        httpClient: IOClient(
          HttpClient()
            ..badCertificateCallback =
                (X509Certificate cert, String host, int port) => true,
        ),
      ),
    ),
  );

  CacheManager getInstance() {
    if (_userRepository.currentAppAuthentication.isSelfSignedCertificate) {
      return _selfSignedCacheManager;
    } else {
      return DefaultCacheManager();
    }
  }
}
