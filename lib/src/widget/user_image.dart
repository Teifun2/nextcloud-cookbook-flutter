import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/util/custom_cache_manager.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final url = DataRepository().getUserAvatarUrl();
    final auth = UserRepository().currentAppAuthentication;

    return CircleAvatar(
      backgroundColor: Colors.grey[400],
      child: ClipOval(
        child: CachedNetworkImage(
          cacheManager: CustomCacheManager().instance,
          cacheKey: 'avatar',
          fit: BoxFit.fill,
          httpHeaders: {
            'Authorization': AppAuthentication.parsePassword(
                auth.loginName, auth.appPassword,),
            'Accept': 'image/jpeg'
          },
          imageUrl: url,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => ColoredBox(
            color: Colors.grey[400]!,
          ),
        ),
      ),
    );
  }
}
