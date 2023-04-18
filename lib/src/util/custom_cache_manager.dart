import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/io_client.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';

class CustomCacheManager {
  static final CustomCacheManager _cacheManager = CustomCacheManager._();
  factory CustomCacheManager() => _cacheManager;

  CustomCacheManager._();

  static const key = 'customCacheKey';

  CacheManager selfSignedCacheManager = CacheManager(
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

  CacheManager get instance {
    if (UserRepository().currentAppAuthentication.isSelfSignedCertificate) {
      return selfSignedCacheManager;
    } else {
      return DefaultCacheManager();
    }
  }
}
