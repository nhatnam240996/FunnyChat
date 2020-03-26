class ChatRoom {
  String name;
  String id;
  ChatRoom(this.name, this.id);

  ChatRoom.fromJson(Map<String, dynamic> map) {
    this.name = map["name"];
    this.id = map["_id"];
  }

  toJson() {
    final Map data = Map<String, dynamic>();
    data["name"] = this.name;
    data["uid"] = this.id;
  }
}
