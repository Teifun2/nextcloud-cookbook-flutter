import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/io_client.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class CustomCacheManager {
  static const key = 'customCacheKey';
  static UserRepository userRepository = UserRepository();

  static CacheManager selfSignedCacheManager = CacheManager(
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

  static CacheManager getInstance() {
    if (userRepository.currentAppAuthentication.isSelfSignedCertificate) {
      return selfSignedCacheManager;
    } else {
      return DefaultCacheManager();
    }
  }
}
