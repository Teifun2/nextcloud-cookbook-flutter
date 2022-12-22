import 'poll.dart';

class InitialLogin {
  Poll poll;
  String login;

  InitialLogin({
    this.poll,
    this.login,
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
