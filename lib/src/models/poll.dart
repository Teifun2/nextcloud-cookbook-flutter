class Poll {
  String token;
  String endpoint;

  Poll({
    required this.token,
    required this.endpoint,
  });

  factory Poll.fromJson(Map<String, dynamic> json) => Poll(
        token: json["token"] as String,
        endpoint: json["endpoint"] as String,
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "endpoint": endpoint,
      };
}
