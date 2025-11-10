class EventsModel {
  final bool status;
  final String errNum;
  final String msg;
  final List<Event> data;

  EventsModel({required this.status, required this.errNum, required this.msg, required this.data});

  factory EventsModel.fromJson(Map<String, dynamic> json) {
    return EventsModel(status: json["status"], errNum: json["errNum"], msg: json["msg"], data: json["data"] == null ? (json["invites"] as List).map((e) => Event.fromJson(e)).toList() : (json["data"] as List).map((e) => Event.fromJson(e)).toList());
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

class Event {
  final int id;
  final String name;
  final Type type;
  final String userId;
  final String status;
  final String eventStatus;
  final String draft;
  final String privacy;
  final String video;
  final String photo;
  final String timeFrom;
  final String timeTo;
  final String dateFrom;
  final String dateTo;
  final String location;
  final String content;
  final String? sharePhotoOne;
  final String? sharePhotoTwo;
  final String lat;
  final String lang;
  final String guestAvg;
  final String rate;
  final String numRate;
  final String? chat;
  final String linkDeep;
  final String createdAt;
  final String updatedAt;
  final int countvisitor;
  final int pendingvisitorCount;
  final int attendvisitorCount;
  final int cancelvisitorCount;
  final int acceptvisitorCount;
  final List<Visitors> visitors;
  final List<Guards> guards;

  Event({required this.id, required this.name, required this.type, required this.pendingvisitorCount, required this.attendvisitorCount, required this.cancelvisitorCount, required this.acceptvisitorCount, required this.guards,required this.visitors, required this.userId, required this.status,required this.eventStatus, required this.draft, required this.privacy, required this.video, required this.photo,required  this.timeFrom, required this.timeTo, required this.dateFrom, required this.dateTo, required this.location, required this.lat, required this.lang, required this.content, required this.guestAvg, required this.rate, required this.numRate, required this.chat, required this.linkDeep, required this.createdAt, required this.updatedAt, required this.countvisitor, required this.sharePhotoOne, required this.sharePhotoTwo});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
    id: json["id"],
    name: json["name"],
    type: Type.fromJson(json["type"]),
    status: json["status"].toString(),
    eventStatus: json["eventStatus"].toString(),
    draft: json["draft"].toString(),
    privacy: json["privacy"],
    video: json["video"]??"",
    photo: json["photo"],
    timeFrom: json["time_from"],
    timeTo: json["time_to"],
    dateFrom: json["date_from"],
    dateTo: json["date_to"],
    location: json["location"],
    lat: json["lat"].toString(),
    lang: json["lang"].toString(),
    content: json["content"],
    sharePhotoOne: json["sharePhotoOne"],
    sharePhotoTwo: json["sharePhotoTwo"],
    guestAvg: json["guest_avg"].toString(),
    rate: json["rate"].toString(),
    numRate: json["num_rate"].toString(),
    chat: json["chat"].toString(),
    linkDeep: json["link_deep"],
    createdAt: json["created_at"], updatedAt: json["updated_at"], countvisitor: json["countvisitor"]??0, userId: json['user_id'].toString(), visitors: json["visitors"]==null? [Visitors(id : 0,name: '', phone: '', status: '')] : (json["visitors"] as List).map((e) => Visitors.fromJson(e)).toList(), guards: json['guards']==null?[Guards(id:0,name: '', phone: '')]:(json["guards"] as List).map((e) => Guards.fromJson(e)).toList(), pendingvisitorCount: json['pendingvisitorCount']??0, acceptvisitorCount: json['acceptvisitorCount']??0, attendvisitorCount: json['attendvisitorCount']??0, cancelvisitorCount: json['cancelvisitorCount']??0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["type"] = type.toJson();
    _data["user_id"] = userId;
    _data["status"] = status;
    _data["eventStatus"] = eventStatus;
    _data["draft"] = draft;
    _data["privacy"] = privacy;
    _data["video"] = video;
    _data["photo"] = photo;
    _data["time_from"] = timeFrom;
    _data["time_to"] = timeTo;
    _data["date_from"] = dateFrom;
    _data["date_to"] = dateTo;
    _data["location"] = location;
    _data["lat"] = lat;
    _data["lang"] = lang;
    _data["content"] = content;
    _data["sharePhotoOne"] = sharePhotoOne;
    _data["sharePhotoTwo"] = sharePhotoTwo;
    _data["guest_avg"] = guestAvg;
    _data["rate"] = rate;
    _data["num_rate"] = numRate;
    _data["chat"] = chat;
    _data["link_deep"] = linkDeep;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["countvisitor"] = countvisitor;
    return _data;
  }
}

class Type {
  final int id;
  final String name;
  final String photo;
  final String createdAt;
  final String updatedAt;

  Type({required this.id, required this.name, required this.photo, required this.createdAt, required this.updatedAt});

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(id: json["id"], name: json["name"], photo: json["photo"], createdAt: json["created_at"]??"", updatedAt: json["updated_at"]??"");
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

class Visitors {
  final int id;
  final String name;
  final String phone;
  final String status;

  Visitors({required this.id,required this.name, required this.phone, required this.status});

  factory Visitors.fromJson(Map<String, dynamic> json) {
    return Visitors(name: json['name'], phone: json['phone'], status: json['status'].toString(), id: json['id']);

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["phone"] = phone;
    _data["status"] = status;
    return _data;
  }
}

class Guards {
  final int id;
  final String name;
  final String phone;

  Guards({required this.id,required this.name, required this.phone});

  factory Guards.fromJson(Map<String, dynamic> json) {
    return Guards(id: json['id'],name: json['name'], phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["phone"] = phone;
    return _data;
  }
}