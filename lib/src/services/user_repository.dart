import 'dart:async';

import 'package:flutter/material.dart';

import '../models/app_authentication.dart';
import '../models/intial_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'dart:convert' show json;
import 'package:url_launcher/url_launcher.dart';

class UserRepository {

  // Singleton
  static final UserRepository _userRepository = UserRepository._internal();
  factory UserRepository() {
    return _userRepository;
  }
  UserRepository._internal();

  final FlutterSecureStorage _secureStorage = new FlutterSecureStorage();
  final String _appAuthenticationKey = 'appAuthentication';
  AppAuthentication currentAppAuthentication;

  Future<AppAuthentication> authenticate({
    @required String serverUrl,
  }) async {

    if (serverUrl.substring(0,4) != 'http') {
      serverUrl = 'https://'+serverUrl;
    }
    String urlInitialCall = serverUrl+'/index.php/login/v2';
    var response;
    try {
      response = await http.post(urlInitialCall, headers: {"User-Agent":"Cookbook App", "Accept-Language":"en-US"});
    } catch (e) {
      throw ('Cannot reach: $serverUrl') ;
    }

    if (response.statusCode == 200) {
      final initialLogin = InitialLogin.fromJson(json.decode(response.body));

      if (await canLaunch(initialLogin.login)) {

        Future<void> _launched = _launchURL(initialLogin.login);

        String urlLoginSuccess = initialLogin.poll.endpoint + "?token=" + initialLogin.poll.token;
        //TODO add when users goes back

        var responseLog = await http.post(urlLoginSuccess);
        while (responseLog.statusCode != 200)  {
          //TODO check if time is good
          // I think this is no a correct usage of the Timer. We cold use Timer.periodic. But it should call the function.
          Timer(const Duration(milliseconds: 500), () {
          });
          responseLog = await http.post(urlLoginSuccess);
        }

        await closeWebView();

        return AppAuthentication.fromJson(responseLog.body);
      } else {
        //TODO throw good errror
        throw 'Could not launchsade';
      }
    } else{
      //TODO Catch Errors
      throw Exception('Your server Name is not correct');
    }
  }

  Future<bool> hasAppAuthentication() async {
    if (currentAppAuthentication != null) {
      return true;
    } else {
      String appAuthentication = await _secureStorage.read(key: _appAuthenticationKey);
      return appAuthentication != null;
    }
  }

  Future<AppAuthentication> getAppAuthentication() async {
    if (currentAppAuthentication != null) {
      return currentAppAuthentication;
    } else {
      String appAuthenticationString = await _secureStorage.read(key: _appAuthenticationKey);
      if (appAuthenticationString == null) {
        throw("No authentication found in Storage");
      } else{
        currentAppAuthentication = AppAuthentication.fromJson(appAuthenticationString);
        return currentAppAuthentication;
      }
    }
  }

  Future<void> persistAppAuthentication(AppAuthentication appAuthentication) async {
    currentAppAuthentication = appAuthentication;
    await _secureStorage.write(key: _appAuthenticationKey, value: appAuthentication.toJson());
  }

  Future<void> deleteAppAuthentication() async {
    //TODO Delete Appkey Serverside
    currentAppAuthentication = null;
    await _secureStorage.delete(key: _appAuthenticationKey);
  }
}

// TODO: Move this to more appropriate position
Future<void> _launchURL( String url) async {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    );
}
