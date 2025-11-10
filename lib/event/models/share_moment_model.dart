class ShareMomentModel {
  final bool? status;
  final String errNum;
  final String msg;
  final List<Data> data;

  ShareMomentModel(
      {required this.status,
        required this.errNum,
        required this.msg,
        required this.data});

  factory ShareMomentModel.fromJson(Map<String, dynamic> json) {
    return ShareMomentModel(
        status: json["status"],
        errNum: json["errNum"],
        msg: json["msg"],
        data: (json["data"] as List).map((e) => Data.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["errNum"] = errNum;
    _data["msg"] = msg;
    _data["data"] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  final int id;
  final String photo;
  final String username;
  final String createdAt;

  Data({required this.id, required this.photo, required this.username, required this.createdAt});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(id: json["id"], photo: json["photo"], username: json["username"], createdAt: json["created_at"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["username"] = username;
    _data["photo"] = photo;
    _data["created_at"] = createdAt;
    return _data;
  }
}
