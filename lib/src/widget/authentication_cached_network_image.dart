import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class AuthenticationCachedNetworkImage extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit boxFit;

  final String url;

  final Widget errorWidget;

  AuthenticationCachedNetworkImage(
      {@required this.url,
      this.width,
      this.height,
      this.boxFit,
      this.errorWidget});

  @override
  Widget build(BuildContext context) {
    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    return CachedNetworkImage(
      fit: boxFit,
      width: width,
      height: height,
      httpHeaders: {
        "Authorization": appAuthentication.basicAuth,
        "Accept": "image/jpeg"
      },
      imageUrl: url,
      placeholder: (context, url) => Container(child: Center(child: CircularProgressIndicator(),),),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: Colors.grey[400],
        child: errorWidget,
      ),
    );
  }
}
