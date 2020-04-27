class User {
  String id;
  String phone;
  String email;
  String password;
  String name;
  String avatar;
  List<String> contacts;
  String accessToken;
  String refreshToken;

  User(
      {this.id,
      this.phone,
      this.email,
      this.password,
      this.name,
      this.avatar,
      this.contacts,
      String accessToken,
      String refreshToken});

  User.fromJson(Map<String, dynamic> map) {
    this.id = map["_id"];
    this.phone = map["phone"] ?? null;
    this.email = map["email"];
    this.password = map["password"] ?? null;
    this.name = map["name"];
    this.avatar = map["avatar"] ?? null;
    this.accessToken = map["accessToken"];
    this.refreshToken = map["refreshToken"];
  }

  toJson() {
    final data = Map<String, dynamic>();
    data["_id"] = this.id;
    data["phone"] = this.phone;
    data["email"] = this.email;
    data["password"] = this.password;
    data["name"] = this.name;
    data["avatar"] = this.avatar;
    data["accessToken"] = this.accessToken;
    data["refreshToken"] = this.refreshToken;
    return data;
  }
}
