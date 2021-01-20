import 'package:extended_image/extended_image.dart';
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

    return ExtendedImage.network(
      '${appAuthentication.server}/index.php/apps/cookbook/recipes/$recipeId/image?size=$settings',
      headers: {
        "authorization": appAuthentication.basicAuth,
      },
      fit: boxFit,
      width: width,
      height: height,
      cache: true,
      retries: 0,
      loadStateChanged: (ExtendedImageState state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          return Container(
            color: Colors.grey[400],
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state.extendedImageLoadState == LoadState.failed) {
          return Container(
            width: 500,
            height: 500,
            color: Colors.grey[400],
            child: SvgPicture.asset(
              'assets/icon.svg',
              color: Colors.grey[600],
            ),
          );
        } else {
          return null;
        }
      },
    );
  }
}
