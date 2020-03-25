import 'package:funny_chat/core/models/account/user.dart';

class Message {
  String content;
  User fromUser;
  User toUser;
  String typeContent;
  int timetamp;

  Message(this.content, this.fromUser, this.toUser, this.typeContent,
      this.timetamp);

  Message.fromJson(Map<String, dynamic> map) {
    this.content = map["content"];
    this.fromUser = map["fromUser"];
    this.toUser = map["toUser"];
    this.typeContent = map["typeContent"];
    this.timetamp = map["timetamp"];
  }

  toJson() {
    final Map data = Map<String, dynamic>();
    data["content"] = this.content;
    data["fromUser"] = this.fromUser;
    data["toUser"] = this.toUser;
    data["typeContent"] = this.typeContent;
    data["timetamp"] = this.timetamp;
  }
}
