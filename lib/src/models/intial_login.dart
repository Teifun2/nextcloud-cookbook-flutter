import 'package:nextcloud_cookbook_flutter/src/models/poll.dart';

class InitialLogin {
  Poll poll;
  String login;

  InitialLogin({
    required this.poll,
    required this.login,
  });

  factory InitialLogin.fromJson(Map<String, dynamic> json) => InitialLogin(
        poll: Poll.fromJson(json["poll"] as Map<String, dynamic>),
        login: json["login"] as String,
      );

  Map<String, dynamic> toJson() => {
        "poll": poll.toJson(),
        "login": login,
      };
}
