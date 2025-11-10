class EventSubTypesModel {
  final bool status;
  final String errNum;
  final String msg;
  final List<SubTypes> types;

  EventSubTypesModel(
      {required this.status,
      required this.errNum,
      required this.msg,
      required this.types});

  factory EventSubTypesModel.fromJson(Map<String, dynamic> json) {
    return EventSubTypesModel(
        status: json["status"],
        errNum: json["errNum"],
        msg: json["msg"],
        types:
            (json["types"] as List).map((e) => SubTypes.fromJson(e)).toList());
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

class SubTypes {
  final int id;
  final String name;
  final String photo;
  List<Template>? templates;
  final String createdAt;
  final String updatedAt;

  SubTypes(
      {required this.id,
      required this.name,
      required this.photo,
      this.templates,
      required this.createdAt,
      required this.updatedAt});

  factory SubTypes.fromJson(Map<String, dynamic> json) {
    return SubTypes(
        id: json["id"],
        name: json["name"],
        photo: json["photo"],
        templates: json["templates"] == null
            ? null
            : (json["templates"] as List)
                .map((e) => Template.fromJson(e))
                .toList(),
        createdAt: json["created_at"] ?? "",
        updatedAt: json["updated_at"] ?? "");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["photo"] = photo;
    if (templates != null) {
      _data["templates"] = templates?.map((e) => e.toJson()).toList();
    }
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}

class Template {
  int? id;
  int? packageId;
  String? photo;
  String? createdAt;

  Template({this.id, this.packageId, this.photo, this.createdAt});

  Template.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    packageId = json["package_id"];
    photo = json["photo"];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["package_id"] = packageId;
    _data["photo"] = photo;
    _data["created_at"] = createdAt;
    return _data;
  }
}
