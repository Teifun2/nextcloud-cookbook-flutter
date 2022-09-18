import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';

class AuthenticationCachedNetworkRecipeImage extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit boxFit;

  final int recipeId;
  final bool full;

  AuthenticationCachedNetworkRecipeImage(
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

    return AuthenticationCachedNetworkImage(
      url:
          '${appAuthentication.server}/apps/cookbook/api/v1/recipes/$recipeId/image?size=$settings',
      width: width,
      height: height,
      boxFit: boxFit,
      errorWidget: SvgPicture.asset(
        'assets/icon.svg',
        color: Colors.grey[600],
      ),
    );
  }
}
