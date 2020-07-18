import 'dart:convert';

class AppAuthentication {
  String server;
  String loginName;
  String appPassword;
  String basicAuth;

  // maybe only keep server, login name, and basic auth and drop appPassword for security.
  AppAuthentication({
    this.server,
    this.loginName,
    this.appPassword,
    this.basicAuth,
  });

  factory AppAuthentication.fromJson(String jsonString) {
    Map<String, dynamic> jsonData = json.decode(jsonString);
    return AppAuthentication(
      server: jsonData["server"],
      loginName: jsonData["loginName"],
      appPassword: jsonData["appPassword"],
      basicAuth: 'Basic '+base64Encode(utf8.encode('${jsonData["loginName"]}:${jsonData["appPassword"]}')),
    );
  }

  String toJson() {
    return json.encode({
      "server": server,
      "loginName": loginName,
      "appPassword": appPassword,
    });
  }

  @override
  String toString() => 'LoggedIn { token: $server, $loginName, $appPassword}';
}