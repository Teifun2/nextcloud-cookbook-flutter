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

    var response = await dio.Dio().get(
      urlInitialCall,
      options: new dio.Options(
        headers: {"OCS-APIREQUEST": "true", "authorization": originalBasicAuth},
      ),
    );

    print(response.statusCode);
    print(response.data);

    throw ("TESTING");

    // if (response.statusCode == 200) {
    //   final initialLogin = InitialLogin.fromJson(json.decode(response.body));
    //
    //   if (await canLaunch(initialLogin.login)) {
    //     _launchURL(initialLogin.login);
    //
    //     String urlLoginSuccess =
    //         initialLogin.poll.endpoint + "?token=" + initialLogin.poll.token;
    //
    //     var responseLog = await http.post(urlLoginSuccess);
    //     while (responseLog.statusCode != 200 && resumeAuthenticate) {
    //       await Future.delayed(Duration(milliseconds: 100));
    //       responseLog = await http.post(urlLoginSuccess);
    //     }
    //
    //     await closeWebView();
    //
    //     if (responseLog.statusCode != 200) {
    //       throw translate('login.errors.interrupted');
    //     } else {
    //       return AppAuthentication.fromJson(responseLog.body);
    //     }
    //   } else {
    //     throw translate('login.errors.window_error');
    //   }
    // } else {
    //   throw Exception(translate('login.errors.communication_failed'));
    // }
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
