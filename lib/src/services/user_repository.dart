import 'dart:async';

import 'jsonClasses/app_key.dart';
import 'jsonClasses/intial_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'dart:convert' show json, jsonDecode;
import 'package:url_launcher/url_launcher.dart';
final storage = new FlutterSecureStorage();
final String _appkey = 'appkey';
final String _serverURL = 'serverURL';
final String _username = 'username';

class UserRepository {

  Future<String> authenticate({
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

        final appKeyJson =Appkey.fromJson(json.decode(responseLog.body));

        //TODO get ServerAppkey

        await storage.write(key: _serverURL, value: serverUrl);
        await storage.write(key: _appkey, value: appKeyJson.appPassword.toString());
        await storage.write(key: _username, value: appKeyJson.loginName.toString());

      } else {
        //TODO throw good errror
        throw 'Could not launchsade';
      }
    } else{
      //TODO Catch Errors
      throw Exception('Your server Name is not correct');
    }

    return await storage.read(key: _appkey);
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    //TODO Delete Appkey Serverside
    await storage.delete(key: _appkey);

    return;
  }



  Future<bool> hasToken() async {
    /// read from keystore/keychain
    String appkey = await storage.read(key: _appkey);
    if (appkey == null){
      return false;
    }
    else{
      return true;
    }
  }

  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    // TODO: Implement proper Persistent Token generation
    await Future.delayed(Duration(seconds: 1));
    return;
  }
}
Future<void> _launchURL( String url) async {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    );
}
