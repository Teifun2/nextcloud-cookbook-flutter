import 'dart:async';
import 'dart:io';
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
final callbackUrlScheme = 'com.googleusercontent.apps.XXXXXXXXXXXX-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
class UserRepository {

  Future<String> authenticate({
    @required String serverUrl,
  }) async {


    String urlInitialCall = serverUrl+'/index.php/login/v2';

    developer.log(urlInitialCall, name: 'my.app.category');
    final response = await http.post(urlInitialCall);
    //TODO Catch lookup Problems
    developer.log("reüponse durch", name: 'my.app.category');
    if (response.statusCode == 200) {
      InitialLogin initialLoginFromJson(String str) => InitialLogin.fromJson(json.decode(str));

      final initialLogin = initialLoginFromJson(response.body);
      if (await canLaunch(initialLogin.login)) {




        Future<void> _lauched =    _launchURL(initialLogin.login);

        String urlLoginSuccess =  initialLogin.poll.endpoint + "?token=" + initialLogin.poll.token;
        //TODO add catch


        var repsponseLog =  await http.post(urlLoginSuccess);
        while (repsponseLog.statusCode != 200)  {
          //TODO check if time is good
          Timer(const Duration(milliseconds: 500), () {
          });
          repsponseLog = await http.post(urlLoginSuccess);
          developer.log(repsponseLog.statusCode.toString(), name: 'my.app.thisshoudcool');
        }

        developer.log("asdasdasdasdsad", name: 'my.app.thisshoudcool');
        closeWebView();
        Appkey appkeyFromJson(String str) => Appkey.fromJson(json.decode(str));
        developer.log(repsponseLog.body.toString(), name: 'my.app.thisshoudcool');
        final appKeyJson =appkeyFromJson(repsponseLog.body);
        developer.log(appKeyJson.appPassword.toString(), name: 'my.app.thisshoudcool');
        //TODO get ServerAppkey
        developer.log(serverUrl, name: 'my.app.thisshoudcool');
        await storage.write(key: _serverURL, value: serverUrl);
        await storage.write(key: _appkey, value: appKeyJson.appPassword.toString());

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
    developer.log(p, name: 'my.app.thisshoudcool');
    developer.log(c.toString(), name: 'my.app.thisshoudcool');
    return await storage.read(key: _appkey);
  }

  Future<void> deleteToken() async {
    /// delete from keystore/keychain
    //TODO Delete Appkey Serverside
    await storage.delete(key: _appkey);

    return;
  }


  //TODO remove
  Future<void> persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
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
}
Future<void> _launchURL( String url) async {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      enableJavaScript: true,
    );
}
