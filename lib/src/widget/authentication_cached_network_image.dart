import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    return CachedNetworkImage(
      fit: boxFit,
      width: width,
      height: height,
      httpHeaders: {
        "authorization": appAuthentication.basicAuth,
      },
      imageUrl:
          '${appAuthentication.server}/index.php/apps/cookbook/recipes/$recipeId/image?size=$settings',
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[400],
        child: SvgPicture.asset(
          'assets/icon.svg',
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
