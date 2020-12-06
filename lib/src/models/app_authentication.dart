import 'dart:convert';

class AppAuthentication {
  String server;
  String loginName;
  String basicAuth;

  AppAuthentication({
    this.server,
    this.loginName,
    this.basicAuth,
  });

  factory AppAuthentication.fromJson(String jsonString) {
    Map<String, dynamic> jsonData = json.decode(jsonString);

    String basicAuth = jsonData.containsKey("basicAuth")
        ? jsonData['basicAuth']
        : 'Basic ' +
            base64Encode(
              utf8.encode(
                '${jsonData["loginName"]}:${jsonData["appPassword"]}',
              ),
            );

    return AppAuthentication(
      server: jsonData["server"],
      loginName: jsonData["loginName"],
      basicAuth: basicAuth,
    );
  }

  String toJson() {
    return json.encode({
      "server": server,
      "loginName": loginName,
      "basicAuth": basicAuth,
    });
  }

  @override
  String toString() => 'LoggedIn { token: $server, $loginName, $basicAuth}';
}
