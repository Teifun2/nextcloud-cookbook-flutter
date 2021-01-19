import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class AuthenticationCachedNetworkImage extends StatelessWidget {
  double width;
  double height;
  BoxFit boxFit;

  final int recipeId;
  final bool full;

  AuthenticationCachedNetworkImage(
      {@required this.recipeId,
      @required this.full,
      this.width,
      this.height,
      this.boxFit});

  @override
  Widget build(BuildContext context) {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    String settings = full ? "full" : "thumb";

    print(
        "${appAuthentication.server}/index.php/apps/cookbook/recipes/$recipeId/image?size=$settings");

    return CachedNetworkImage(
      width: width,
      height: height,
      fit: boxFit,
      imageUrl:
          '${appAuthentication.server}/index.php/apps/cookbook/recipes/$recipeId/image?size=$settings',
      httpHeaders: {
        "authorization": appAuthentication.basicAuth,
      },
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.broken_image),
    );
  }
}
