class Visitors {
  bool? status;
  String? errNum;
  String? msg;
  List<Data>? data;

  Visitors({this.status, this.errNum, this.msg, this.data});

  Visitors.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? phone;
  dynamic email;
  dynamic eventId;
  dynamic inviteFrom;
  dynamic userId;
  dynamic status;
  String? rate;
  dynamic inviteCancelPoston;
  String? createdAt;
  String? updatedAt;
  Event? event;

  Data({this.id, this.name, this.phone, this.email, this.eventId, this.inviteFrom, this.userId, this.status, this.rate, this.inviteCancelPoston, this.createdAt, this.updatedAt, this.event});

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    phone = json["phone"];
    email = json["email"];
    eventId = json["event_id"];
    inviteFrom = json["invite_from"];
    userId = json["user_id"];
    status = json["status"];
    rate = json["rate"];
    inviteCancelPoston = json["invite_cancel_poston"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    event = json["event"] == null ? null : Event.fromJson(json["event"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["phone"] = phone;
    _data["email"] = email;
    _data["event_id"] = eventId;
    _data["invite_from"] = inviteFrom;
    _data["user_id"] = userId;
    _data["status"] = status;
    _data["rate"] = rate;
    _data["invite_cancel_poston"] = inviteCancelPoston;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    if(event != null) {
      _data["event"] = event?.toJson();
    }
    return _data;
  }
}

class Event {
  int? id;
  String? name;
  dynamic type;
  dynamic userId;
  dynamic status;
  dynamic draft;
  dynamic cat;
  String? privacy;
  dynamic pass;
  dynamic video;
  String? photo;
  String? timeFrom;
  String? timeTo;
  String? dateFrom;
  String? dateTo;
  String? location;
  dynamic lat;
  dynamic lang;
  dynamic countery;
  dynamic city;
  dynamic state;
  dynamic zip;
  String? content;
  dynamic guestAvg;
  dynamic rate;
  dynamic numRate;
  dynamic duration;
  String? chat;
  dynamic cancelMessage;
  dynamic postonMessage;
  String? linkDeep;
  String? createdAt;
  String? updatedAt;

  Event({this.id, this.name, this.type, this.userId, this.status, this.draft, this.cat, this.privacy, this.pass, this.video, this.photo, this.timeFrom, this.timeTo, this.dateFrom, this.dateTo, this.location, this.lat, this.lang, this.countery, this.city, this.state, this.zip, this.content, this.guestAvg, this.rate, this.numRate, this.duration, this.chat, this.cancelMessage, this.postonMessage, this.linkDeep, this.createdAt, this.updatedAt});

  Event.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    type = json["type"];
    userId = json["user_id"];
    status = json["status"];
    draft = json["draft"];
    cat = json["cat"];
    privacy = json["privacy"];
    pass = json["pass"];
    video = json["video"];
    photo = json["photo"];
    timeFrom = json["time_from"];
    timeTo = json["time_to"];
    dateFrom = json["date_from"];
    dateTo = json["date_to"];
    location = json["location"];
    lat = json["lat"];
    lang = json["lang"];
    countery = json["countery"];
    city = json["city"];
    state = json["state"];
    zip = json["zip"];
    content = json["content"];
    guestAvg = json["guest_avg"];
    rate = json["rate"];
    numRate = json["num_rate"];
    duration = json["duration"];
    chat = json["chat"];
    cancelMessage = json["cancel_message"];
    postonMessage = json["poston_message"];
    linkDeep = json["link_deep"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["type"] = type;
    _data["user_id"] = userId;
    _data["status"] = status;
    _data["draft"] = draft;
    _data["cat"] = cat;
    _data["privacy"] = privacy;
    _data["pass"] = pass;
    _data["video"] = video;
    _data["photo"] = photo;
    _data["time_from"] = timeFrom;
    _data["time_to"] = timeTo;
    _data["date_from"] = dateFrom;
    _data["date_to"] = dateTo;
    _data["location"] = location;
    _data["lat"] = lat;
    _data["lang"] = lang;
    _data["countery"] = countery;
    _data["city"] = city;
    _data["state"] = state;
    _data["zip"] = zip;
    _data["content"] = content;
    _data["guest_avg"] = guestAvg;
    _data["rate"] = rate;
    _data["num_rate"] = numRate;
    _data["duration"] = duration;
    _data["chat"] = chat;
    _data["cancel_message"] = cancelMessage;
    _data["poston_message"] = postonMessage;
    _data["link_deep"] = linkDeep;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}