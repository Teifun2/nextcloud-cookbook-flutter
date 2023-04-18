import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/util/custom_cache_manager.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final url = DataRepository().getUserAvatarUrl();
    final appAuthentication = UserRepository().currentAppAuthentication;

    return ClipOval(
      child: CachedNetworkImage(
        cacheManager: CustomCacheManager().instance,
        cacheKey: "avatar",
        fit: BoxFit.fill,
        httpHeaders: {
          "Authorization": appAuthentication.basicAuth,
          "Accept": "image/jpeg"
        },
        imageUrl: url,
        placeholder: (context, url) => ColoredBox(
          color: Colors.grey[400]!,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => ColoredBox(
          color: Colors.grey[400]!,
        ),
      ),
    );
  }
}
