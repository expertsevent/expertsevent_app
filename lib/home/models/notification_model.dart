class NotificationModel {
  bool? status;
  String? errNum;
  String? msg;
  List<Invites>? invites;

  NotificationModel({this.status, this.errNum, this.msg, this.invites});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    errNum = json["errNum"];
    msg = json["msg"];
    invites = json["invites"] == null ? null : (json["invites"] as List).map((e) => Invites.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["errNum"] = errNum;
    _data["msg"] = msg;
    if(invites != null) {
      _data["invites"] = invites?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Invites {
  int? id;
  String? eventId;
  String? userId;
  String? message;
  String? num;
  String? status;
  String? createdAt;
  String? updatedAt;
  Eventname? eventname;

  Invites({this.id, this.eventId, this.userId, this.message, this.num, this.status, this.createdAt, this.updatedAt, this.eventname});

  Invites.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    eventId = json["event_id"];
    userId = json["user_id"];
    message = json["message"];
    num = json["num"];
    status = json["status"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    eventname = json["eventname"] == null ? null : Eventname.fromJson(json["eventname"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["event_id"] = eventId;
    _data["user_id"] = userId;
    _data["message"] = message;
    _data["num"] = num;
    _data["status"] = status;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    if(eventname != null) {
      _data["eventname"] = eventname?.toJson();
    }
    return _data;
  }
}

class Eventname {
  String? name;
  int? id;

  Eventname({this.name, this.id});

  Eventname.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["id"] = id;
    return _data;
  }
}