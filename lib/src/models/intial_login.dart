import 'package:nextcloud_cookbook_flutter/src/models/poll.dart';

class InitialLogin {
  Poll poll;
  String login;

  InitialLogin({
    required this.poll,
    required this.login,
  });

  factory InitialLogin.fromJson(Map<String, dynamic> json) => InitialLogin(
        poll: Poll.fromJson(json["poll"]),
        login: json["login"],
      );

  Map<String, dynamic> toJson() => {
        "poll": poll.toJson(),
        "login": login,
      };
}
