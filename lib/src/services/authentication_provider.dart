import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:http/http.dart' as http;
import 'package:nextcloud_cookbook_flutter/src/models/app_authentication.dart';
import 'package:nextcloud_cookbook_flutter/src/models/intial_login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xml/xml.dart';

class AuthenticationProvider {
  final FlutterSecureStorage _secureStorage = new FlutterSecureStorage();
  final String _appAuthenticationKey = 'appAuthentication';
  AppAuthentication currentAppAuthentication;
  bool resumeAuthenticate = true;

  Future<AppAuthentication> authenticate(
      {@required String serverUrl,
      @required String username,
      @required String originalBasicAuth}) async {
    resumeAuthenticate = true;
    if (serverUrl.substring(0, 4) != 'http') {
      serverUrl = 'https://' + serverUrl;
    }
    String urlInitialCall = serverUrl + '/ocs/v2.php/core/getapppassword';

    dio.Response response;
    try {
      response = await dio.Dio().get(
        urlInitialCall,
        options: new dio.Options(
          headers: {
            "OCS-APIREQUEST": "true",
            "User-Agent": "Cookbook App",
            "authorization": originalBasicAuth
          },
          validateStatus: (status) => status < 500,
        ),
      );
    } on dio.DioError catch (e) {
      if (e.message.contains("SocketException")) {
        throw ("SocketException: The URL is wrong or the server is not reachable!\n $e");
      }
      throw ("AppPassword request failed:\n $e");
    }

    if (response.statusCode == 200) {
      String appPassword;
      try {
        appPassword = XmlDocument.parse(response.data)
            .findAllElements("apppassword")
            .first
            .text;
      } on XmlParserException catch (e) {
        throw ('Cannot parse the appPassword response!\n $e');
      } on StateError catch (e) {
        throw ('Cannot find appPassword in response!\n $e');
      }

      String basicAuth =
          'Basic ' + base64Encode(utf8.encode('$username:$appPassword'));

      return AppAuthentication(
        server: serverUrl,
        loginName: username,
        basicAuth: basicAuth,
      );
    } else if (response.statusCode == 401) {
      throw ('Username and / or Password is incorrect!');
    } else {
      throw ('Login Process could not finish properly.\n ${response.statusCode}\n ${response.statusMessage}');
    }
  }

  void stopAuthenticate() {
    resumeAuthenticate = false;
  }

  Future<bool> hasAppAuthentication() async {
    if (currentAppAuthentication != null) {
      return true;
    } else {
      String appAuthentication =
          await _secureStorage.read(key: _appAuthenticationKey);
      return appAuthentication != null;
    }
  }

  Future<void> loadAppAuthentication() async {
    String appAuthenticationString =
        await _secureStorage.read(key: _appAuthenticationKey);
    if (appAuthenticationString == null) {
      throw (translate('login.errors.authentication_not_found'));
    } else {
      currentAppAuthentication =
          AppAuthentication.fromJson(appAuthenticationString);
    }
  }

  Future<void> persistAppAuthentication(
      AppAuthentication appAuthentication) async {
    currentAppAuthentication = appAuthentication;
    await _secureStorage.write(
        key: _appAuthenticationKey, value: appAuthentication.toJson());
  }

  Future<void> deleteAppAuthentication() async {
    var response = await dio.Dio().delete(
      "${currentAppAuthentication.server}/ocs/v2.php/core/apppassword",
      options: new dio.Options(
        headers: {
          "OCS-APIREQUEST": "true",
          "authorization": currentAppAuthentication.basicAuth
        },
      ),
    );

    if (response.statusCode != 200) {
      debugPrint(translate('login.errors.failed_remove_remote'));
    }

    //TODO Delete Appkey Serverside
    currentAppAuthentication = null;
    await _secureStorage.delete(key: _appAuthenticationKey);
  }

  Future<void> _launchURL(String url) async {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    );
  }
}
