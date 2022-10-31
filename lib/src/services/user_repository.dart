import 'dart:async';

import 'package:dio/dio.dart';
import 'package:nextcloud_cookbook_flutter/src/services/authentication_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/version_provider.dart';

import '../models/app_authentication.dart';

class UserRepository {
  // Singleton
  static final UserRepository _userRepository = UserRepository._internal();
  factory UserRepository() {
    return _userRepository;
  }
  UserRepository._internal();

  AuthenticationProvider authenticationProvider = AuthenticationProvider();
  VersionProvider versionProvider = VersionProvider();

  Future<AppAuthentication> authenticate(
    String serverUrl,
    String username,
    String originalBasicAuth,
    bool isSelfSignedCertificate,
  ) async {
    return authenticationProvider.authenticate(
      serverUrl: serverUrl,
      username: username,
      originalBasicAuth: originalBasicAuth,
      isSelfSignedCertificate: isSelfSignedCertificate,
    );
  }

  Future<AppAuthentication> authenticateAppPassword(
    String serverUrl,
    String username,
    String basicAuth,
    bool isSelfSignedCertificate,
  ) async {
    return authenticationProvider.authenticateAppPassword(
      serverUrl: serverUrl,
      username: username,
      basicAuth: basicAuth,
      isSelfSignedCertificate: isSelfSignedCertificate,
    );
  }

  void stopAuthenticate() {
    authenticationProvider.stopAuthenticate();
  }

  @deprecated
  AppAuthentication getCurrentAppAuthentication() {
    return authenticationProvider.currentAppAuthentication;
  }

  Dio getAuthenticatedClient() {
    return authenticationProvider.currentAppAuthentication.authenticatedClient;
  }

  Future<bool> hasAppAuthentication() async {
    return authenticationProvider.hasAppAuthentication();
  }

  Future<void> loadAppAuthentication() async {
    return authenticationProvider.loadAppAuthentication();
  }

  Future<bool> checkAppAuthentication() async {
    return authenticationProvider.checkAppAuthentication(
        authenticationProvider.currentAppAuthentication.server,
        authenticationProvider.currentAppAuthentication.basicAuth,
        authenticationProvider
            .currentAppAuthentication.isSelfSignedCertificate);
  }

  Future<void> persistAppAuthentication(
      AppAuthentication appAuthentication) async {
    return authenticationProvider.persistAppAuthentication(appAuthentication);
  }

  Future<void> deleteAppAuthentication() async {
    return authenticationProvider.deleteAppAuthentication();
  }

  Future<ApiVersion> fetchApiVersion() async {
    return versionProvider.fetchApiVersion();
  }

  AndroidApiVersion getAndroidVersion() {
    return versionProvider.getApiVersion().getAndroidVersion();
  }
}
