import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/services.dart';
import 'package:nextcloud_cookbook_flutter/src/widget/authentication_cached_network_image.dart';

class AuthenticationCachedNetworkRecipeImage extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit? boxFit;

  final String recipeId;
  final bool full;

  const AuthenticationCachedNetworkRecipeImage({
    super.key,
    required this.recipeId,
    required this.full,
    this.width,
    this.height,
    this.boxFit,
  });

  @override
  Widget build(BuildContext context) {
    final AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    final String settings = full ? "full" : "thumb";

    return AuthenticationCachedNetworkImage(
      url:
          '${appAuthentication.server}/index.php/apps/cookbook/api/v1/recipes/$recipeId/image?size=$settings',
      width: width,
      height: height,
      boxFit: boxFit,
      errorWidget: SvgPicture.asset(
        'assets/icon.svg',
      ),
    );
  }
}
