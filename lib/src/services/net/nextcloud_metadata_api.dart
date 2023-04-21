part of '../services.dart';

// coverage:ignore-start
class NextcloudMetadataApi {
  factory NextcloudMetadataApi() => NextcloudMetadataApi._(
        UserRepository().currentAppAuthentication,
      );

  NextcloudMetadataApi._(this._appAuthentication);
  final AppAuthentication _appAuthentication;

  String getUserAvatarUrl() =>
      '${_appAuthentication.server}/avatar/${_appAuthentication.loginName}/80';
}
// coverage:ignore-end
