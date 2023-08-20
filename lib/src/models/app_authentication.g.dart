// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_authentication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppAuthentication _$AppAuthenticationFromJson(Map<String, dynamic> json) =>
    AppAuthentication(
      server: json['server'] as String,
      loginName: json['loginName'] as String,
      appPassword: json['appPassword'] as String,
      isSelfSignedCertificate: json['isSelfSignedCertificate'] as bool,
    );

Map<String, dynamic> _$AppAuthenticationToJson(AppAuthentication instance) =>
    <String, dynamic>{
      'server': instance.server,
      'loginName': instance.loginName,
      'appPassword': instance.appPassword,
      'isSelfSignedCertificate': instance.isSelfSignedCertificate,
    };
