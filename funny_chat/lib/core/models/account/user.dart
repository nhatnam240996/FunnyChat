class User {
  String phone;
  String email;
  String password;
  String name;
  String image;

  User({this.phone, this.email, this.password, this.name, this.image});

  User.fromJson(Map<String, dynamic> map) {
    this.phone = map["phone"];
    this.email = map["email"];
    this.password = map["password"];
    this.name = map["name"];
    this.image = map["image"];
  }

  toJson() {
    final data = Map<String, dynamic>();
    data["phone"] = this.phone;
    data["email"] = this.email;
    data["password"] = this.password;
    data["name"] = this.name;
    data["image"] = this.image;
    return data;
  }
}
