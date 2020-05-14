import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_web_auth/flutter_web_auth.dart';

import 'dart:convert' show jsonDecode;
final storage = new FlutterSecureStorage();
final String _appkey = 'appkey';
final String _serverURL = 'serverURL';
final callbackUrlScheme = 'com.googleusercontent.apps.XXXXXXXXXXXX-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
class UserRepository {
  Future<String> authenticate({
    @required String serverUrl,
  }) async {

    Future<http.Response> fetchAlbum() {
      return http.get('');
    }



    String returnKey = 'daskjlönlksdjFNJKPDSFBNJJKLDS';
    //TODO get ServerAppkey
    await storage.write(key: _serverURL, value: serverUrl);
    await storage.write(key: _appkey, value: returnKey);


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
