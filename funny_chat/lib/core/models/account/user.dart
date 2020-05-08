import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String uid;
  String phone;
  String name;
  String photoUrl;

  User({this.uid, this.phone, this.name, this.photoUrl});

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
        name: map["name"],
        phone: map["phone"],
        photoUrl: map["photoUrl"],
        uid: map["uid"]);
  }

  factory User.fromFirebase(DocumentSnapshot data) {
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
