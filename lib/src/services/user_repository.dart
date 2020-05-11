import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
final storage = new FlutterSecureStorage();
final String _appkey = 'appkey';
final String _serverURL = 'serverURL';
class UserRepository {
  Future<String> authenticate({
    @required String username,
    @required String password,
    @required String serverUrl,
  }) async {
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
