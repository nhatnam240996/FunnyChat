class Message {
  String roomId;
  String userId;
  String messenger;

  Message(this.roomId, this.userId, this.messenger);

  Message.fromJson(Map<String, dynamic> map) {
    this.roomId = map['roomId'];
    this.userId = map["userId"];
    this.messenger = map["messenger"];
  }

  toJson() {
    final Map data = Map<String, dynamic>();
    data["roomId"] = this.roomId;
    data["userId"] = this.userId;
    data["messenger"] = this.messenger;
    return data;
  }
}
