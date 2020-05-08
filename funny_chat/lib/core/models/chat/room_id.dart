class RoomId {
  String myId;
  String friendId;

  RoomId(this.myId, this.friendId);

  toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["myId"] = this.myId;
    data["frinedId"] = this.friendId;
    return data;
  }
}
