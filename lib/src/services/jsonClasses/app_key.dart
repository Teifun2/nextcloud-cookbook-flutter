class Appkey {
  String server;
  String loginName;
  String appPassword;

  Appkey({
    this.server,
    this.loginName,
    this.appPassword,
  });

  factory Appkey.fromJson(Map<String, dynamic> json) => Appkey(
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