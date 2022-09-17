import 'dart:convert';

import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/services/user_repository.dart';

class VersionProvider {
  ApiVersion _currentApiVersion;
  bool warningWasShown = false;

  Future<ApiVersion> fetchApiVersion() async {
    warningWasShown = false;

    AppAuthentication appAuthentication =
        UserRepository().getCurrentAppAuthentication();

    var response = await appAuthentication.authenticatedClient
        .get("${appAuthentication.server}/index.php/apps/cookbook/api/version");

    if (response.statusCode == 200 &&
        !response.data.toString().startsWith("<!DOCTYPE html>")) {
      try {
        _currentApiVersion = ApiVersion.decodeJsonApiVersion(response.data);
      } catch (e) {
        _currentApiVersion = ApiVersion(0, 0, 0, 0, 0);
        _currentApiVersion.loadFailureMessage = e.toString();
      }
    } else {
      _currentApiVersion = ApiVersion(0, 0, 0, 0, 0);
    }

    return _currentApiVersion;
  }

  ApiVersion getApiVersion() {
    return _currentApiVersion;
  }
}

class ApiVersion {
  static const int CONFIRMED_MAJOR_API_VERSION = 1;
  static const int CONFIRMED_MINOR_API_VERSION = 0;

  final int majorApiVersion;
  final int minorApiVersion;
  final int majorAppVersion;
  final int minorAppVersion;
  final int patchAppVersion;

  String loadFailureMessage = "";

  ApiVersion(
    this.majorApiVersion,
    this.minorApiVersion,
    this.majorAppVersion,
    this.minorAppVersion,
    this.patchAppVersion,
  );

  static ApiVersion decodeJsonApiVersion(jsonString) {
    Map<String, dynamic> data = json.decode(jsonString);

    if (!(data.containsKey("cookbook_version") &&
        data.containsKey("api_version"))) {
      throw Exception("Required Fields not present!\n$jsonString");
    }

    List<int> appVersion = data["cookbook_version"].cast<int>();
    var apiVersion = data["api_version"];

    if (!(appVersion.length == 3 &&
        apiVersion.containsKey("major") &&
        apiVersion.containsKey("minor"))) {
      throw Exception("Required Fields not present!\n$jsonString");
    }

    return ApiVersion(
      apiVersion["major"],
      apiVersion["minor"],
      appVersion[0],
      appVersion[1],
      appVersion[2],
    );
  }

  /// Returns a VersionCode that indicates the app which endpoints to call.
  /// Versions only need to be adapted if backwards comparability is required.
  AndroidApiVersion getAndroidVersion() {
    if (majorApiVersion == 0 && minorApiVersion == 0) {
      return AndroidApiVersion.BEFORE_API_ENDPOINT;
    } else {
      return AndroidApiVersion.CATEGORY_API_TRANSITION;
    }
  }

  bool isVersionAboveConfirmed() {
    if (majorApiVersion > CONFIRMED_MAJOR_API_VERSION ||
        (majorApiVersion == CONFIRMED_MAJOR_API_VERSION &&
            minorApiVersion > CONFIRMED_MINOR_API_VERSION)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  String toString() {
    return "ApiVersion: $majorApiVersion.$minorApiVersion  AppVersion: $majorAppVersion.$minorAppVersion.$patchAppVersion";
  }
}

enum AndroidApiVersion { BEFORE_API_ENDPOINT, CATEGORY_API_TRANSITION }
