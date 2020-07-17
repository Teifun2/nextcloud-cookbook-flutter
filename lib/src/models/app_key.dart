class AppKey {
  String server;
  String loginName;
  String appPassword;

  AppKey({
    this.server,
    this.loginName,
    this.appPassword,
  });

  factory AppKey.fromJson(Map<String, dynamic> json) => AppKey(
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