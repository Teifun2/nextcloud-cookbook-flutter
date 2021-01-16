import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class AuthenticationCachedNetworkImage extends StatelessWidget {
  final RegExp exp = new RegExp(r'recipes/(\d*?)/image\?(.*?)$');
  String imageId;
  String imageSettings;
  final String imagePath;
  final double width;
  final double height;
  final BoxFit boxFit;

  AuthenticationCachedNetworkImage({
    @required this.imagePath,
    this.width,
    this.height,
    this.boxFit,
  }) {
    RegExpMatch match = exp.firstMatch(imagePath);
    this.imageId = match.group(1);
    this.imageSettings = match.group(2);
  }

  @override
  Widget build(BuildContext context) {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    return CachedNetworkImage(
      width: width,
      height: height,
      fit: boxFit,
      imageUrl:
          '${appAuthentication.server}/index.php/apps/cookbook/recipes/$imageId/image?$imageSettings',
      httpHeaders: {
        "authorization": appAuthentication.basicAuth,
      },
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.broken_image),
    );
  }
}
