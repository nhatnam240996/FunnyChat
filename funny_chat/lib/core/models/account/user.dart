class User {
  String uid;
  String phone;
  String name;
  String photoUrl;

  User({this.uid, this.phone, this.name, this.photoUrl});

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
        uid: data["uid"],
        name: data["name"],
        phone: data["phone"],
        photoUrl: data["photoUrl"] ?? "");
  }

  toJson() {
    final data = Map<String, dynamic>();
    data["phone"] = this.phone;
    data["name"] = this.name;
    data["photoUrl"] = this.photoUrl;
    data["uid"] = this.uid;
    return data;
  }
}
