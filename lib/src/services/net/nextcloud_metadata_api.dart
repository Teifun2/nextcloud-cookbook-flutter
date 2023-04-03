part of '../services.dart';

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
