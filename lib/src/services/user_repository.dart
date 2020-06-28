import 'dart:async';
import 'dart:io';
import 'package:nextcloud_cookbook_flutter/src/screens/login_page.dart';

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
      response = await http.post(urlInitialCall);
    } catch (e) {
      //TODO good erroer
      throw ('Url not valid') ;
    }


    if (response.statusCode == 200) {
      InitialLogin initialLoginFromJson(String str) => InitialLogin.fromJson(json.decode(str));

      final initialLogin = initialLoginFromJson(response.body);
      if (await canLaunch(initialLogin.login)) {




        Future<void> _lauched =    _launchURL(initialLogin.login);

        String urlLoginSuccess =  initialLogin.poll.endpoint + "?token=" + initialLogin.poll.token;
        //TODO add when users goes back


        var repsponseLog =  await http.post(urlLoginSuccess);
        while (repsponseLog.statusCode != 200)  {
          //TODO check if time is good
          Timer(const Duration(milliseconds: 500), () {
          });
          repsponseLog = await http.post(urlLoginSuccess);

        }


        await closeWebView();
        Appkey appkeyFromJson(String str) => Appkey.fromJson(json.decode(str));

        final appKeyJson =appkeyFromJson(repsponseLog.body);

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



    String p = await storage.read(key: _appkey);
    String c = await storage.read(key: _serverURL);

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
