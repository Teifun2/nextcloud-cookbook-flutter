import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class NextcloudMetadataApi {
  final AppAuthentication _appAuthentication;

  factory NextcloudMetadataApi() {
    return NextcloudMetadataApi._(
      UserRepository().currentAppAuthentication,
    );
  }

  NextcloudMetadataApi._(this._appAuthentication);

  String getUserAvatarUrl() {
    return "${_appAuthentication.server}/avatar/${_appAuthentication.loginName}/80";
  }
}
