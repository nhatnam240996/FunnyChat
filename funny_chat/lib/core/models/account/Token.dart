class Token {
  String accessToken;
  String refreshToken;
  Token(this.accessToken, this.refreshToken);

  Token.fromJson(Map<String, dynamic> map) {
    print(map.toString());
    this.accessToken = map["accessToken"];
    this.refreshToken = map["refreshToken"];
  }
}
