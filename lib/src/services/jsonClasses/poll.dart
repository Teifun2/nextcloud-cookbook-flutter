class Poll {
  String token;
  String endpoint;

  Poll({
    this.token,
    this.endpoint,
  });

  factory Poll.fromJson(Map<String, dynamic> json) => Poll(
    token: json["token"],
    endpoint: json["endpoint"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "endpoint": endpoint,
  };
}