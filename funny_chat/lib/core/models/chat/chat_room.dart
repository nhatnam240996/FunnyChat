class ChatRoom {
  String fromId;
  String toId;
  int roomType;
  ChatRoom(this.fromId, this.toId);

  ChatRoom.fromJson(Map<String, dynamic> map) {
    this.fromId = map["from"];
    this.toId = map["to"];
  }

  toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["from"] = this.fromId;
    data["to"] = this.toId;
    return data;
  }
}
