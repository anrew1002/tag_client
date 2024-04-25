class ApiKey {
  String login;
  String key;
  // String pass;
  ApiKey({
    required this.login,
    required this.key
    // required this.pass,
  });
  factory ApiKey.fromJson(Map<String, dynamic> json) {
    return ApiKey(
      login: json["login"],
      key: json["api_key"],
      // pass: json["pass"]
    );
  }

  Map<String, dynamic> toJson() => {
    "api_key": key,
    "login": login,
  };
}