import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class AuthenticationCachedNetworkImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final BoxFit boxFit;

  const AuthenticationCachedNetworkImage(
      {@required this.imagePath, this.width, this.height, this.boxFit});

  @override
  Widget build(BuildContext context) {
    AppAuthentication appAuthentication =
        UserRepository().currentAppAuthentication;

    return CachedNetworkImage(
      width: width,
      height: height,
      fit: boxFit,
      imageUrl: '${appAuthentication.server}$imagePath',
      httpHeaders: {
        "authorization": appAuthentication.basicAuth,
      },
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.broken_image),
    );
  }
}
