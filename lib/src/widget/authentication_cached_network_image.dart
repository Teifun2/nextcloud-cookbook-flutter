import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class AuthenticationCachedNetworkImage extends StatelessWidget {
  final String imagePath;

  const AuthenticationCachedNetworkImage({@required this.imagePath});

  @override
  Widget build(BuildContext context) {
    AppAuthentication appAuthentication = UserRepository().currentAppAuthentication;

    return CachedNetworkImage(
      imageUrl: '${appAuthentication.server}$imagePath',
      httpHeaders: {
        "authorization": appAuthentication.basicAuth,
      },
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.broken_image),
    );
  }
}