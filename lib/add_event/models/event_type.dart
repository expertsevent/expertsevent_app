class EventTypesModel {
  final bool status;
  final String errNum;
  final String msg;
  final List<Types> types;

  EventTypesModel(
      {required this.status,
      required this.errNum,
      required this.msg,
      required this.types});

  factory EventTypesModel.fromJson(Map<String, dynamic> json) {
    return EventTypesModel(
        status: json["status"],
        errNum: json["errNum"],
        msg: json["msg"],
        types: (json["types"] as List).map((e) => Types.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["errNum"] = errNum;
    _data["msg"] = msg;
    _data["types"] = types.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Types {
  final int id;
  final String name;
  final String photo;
  final String createdAt;
  final String updatedAt;

  Types({required this.id, required this.name, required this.photo, required this.createdAt, required this.updatedAt});

  factory Types.fromJson(Map<String, dynamic> json) {
    return Types(id: json["id"], name: json["name"], photo: json["photo"], createdAt: json["created_at"]??"", updatedAt: json["updated_at"]??"");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["photo"] = photo;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}
