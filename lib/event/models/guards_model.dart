class GuardsModel {
  final bool status;
  final String errNum;
  final String msg;
  final List<Guard> data;

  GuardsModel(
      {required this.status,
      required this.errNum,
      required this.msg,
      required this.data});

  factory GuardsModel.fromJson(Map<String, dynamic> json) {
    return GuardsModel(
        status: json["status"],
        errNum: json["errNum"],
        msg: json["msg"],
        data: (json["data"] as List).map((e) => Guard.fromJson(e)).toList());
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

class Guard {
  final int id;
  final String name;
  final String phone;

  Guard({required this.id, required this.name, required this.phone});

  factory Guard.fromJson(Map<String, dynamic> json) {
    return Guard(id: json["id"], name: json["name"], phone: json["phone"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["phone"] = phone;
    return _data;
  }
}
