class AppAuthentication {
  String server;
  String loginName;
  String appPassword;

  AppAuthentication({
    this.server,
    this.loginName,
    this.appPassword,
  });

  factory AppAuthentication.fromJson(Map<String, dynamic> json) => AppAuthentication(
    server: json["server"],
    loginName: json["loginName"],
    appPassword: json["appPassword"],
  );

  Map<String, dynamic> toJson() => {
    "server": server,
    "loginName": loginName,
    "appPassword": appPassword,
  };
}