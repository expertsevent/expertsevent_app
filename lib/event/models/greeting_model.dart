class GreetingsModel {
  bool? status;
  String? errNum;
  String? msg;
  List<Data>? data;

  GreetingsModel({this.status, this.errNum, this.msg, this.data});

  GreetingsModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    errNum = json["errNum"];
    msg = json["msg"];
    data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["errNum"] = errNum;
    _data["msg"] = msg;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  int? id;
  String? comment;
  String? userName;
  String? userPhoto;
  String? createdAt;

  Data({this.id, this.comment, this.userName,this.userPhoto, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    comment = json["comment"];
    userName = json["userName"];
    userPhoto = json["userPhoto"];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["comment"] = comment;
    _data["userName"] = userName;
    _data["userPhoto"] = userPhoto;
    _data["created_at"] = createdAt;
    return _data;
  }
}