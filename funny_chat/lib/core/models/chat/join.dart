class Join {
  String roomId;
  UserInf userInfor;
  Join(this.roomId, this.userInfor);

  Join.fromJson(Map<String, dynamic> map) {
    this.roomId = map["roomId"];
    this.userInfor = UserInf.fromJson(map["userInfo"]);
  }

  toJson() {
    final data = Map<String, dynamic>();
    data["roomId"] = this.roomId;
    data["userInfo"] = this.userInfor.toJson();
    return data;
  }
}

class UserInf {
  String id;
  String name;
  UserInf(this.id, this.name);

  UserInf.fromJson(Map<String, dynamic> map) {
    this.id = map["id"];
    this.name = map["name"];
  }

  toJson() {
    final Map data = Map<String, dynamic>();
    data["id"] = this.id;
    data["name"] = this.name;
    return data;
  }
}
