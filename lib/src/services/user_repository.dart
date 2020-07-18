import 'dart:async';

import '../models/app_authentication.dart';
import 'jsonClasses/intial_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


import 'dart:convert' show json;
import 'package:url_launcher/url_launcher.dart';

final storage = new FlutterSecureStorage();

final String _appAuthentication = 'appAuthentication';

class UserRepository {

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
    String appAuthentication = await storage.read(key: _appAuthentication);
    return appAuthentication != null;
  }

  Future<AppAuthentication> getAppAuthentication() async {
    String appAuthenticationString = await storage.read(key: _appAuthentication);
    if (appAuthenticationString == null) {
      throw("No authentication found in Storage");
    } else{
      return AppAuthentication.fromJson(appAuthenticationString);
    }
  }

  Future<void> persistAppAuthentication(AppAuthentication appAuthentication) async {
    await storage.write(key: _appAuthentication, value: appAuthentication.toJson());
  }

  Future<void> deleteAppAuthentication() async {
    //TODO Delete Appkey Serverside
    await storage.delete(key: _appAuthentication);
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
