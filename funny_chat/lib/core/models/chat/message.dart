import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String fromUid;
  String toUid;
  String content;
  String timetamp;

  Message(this.fromUid, this.toUid, this.content, this.timetamp);

  Message.fromJson(DocumentSnapshot map) {
    this.fromUid = map['fromUid'];
    this.toUid = map["toUid"];
    this.content = map["content"];
    this.timetamp = map["timetamp"];
  }

  toJson() {
    final Map data = Map<String, dynamic>();
    data["fromUid"] = this.fromUid;
    data["toUid"] = this.toUid;
    data["content"] = this.content;
    data["timetamp"] = this.timetamp;
    return data;
  }
}
