class Comments {
  bool? status;
  String? errNum;
  String? msg;
  List<Data>? data;

    Comments({this.status, this.errNum, this.msg, this.data});

  Comments.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? likes;
  bool? userLike;
  String? createdAt;
  List<Replies>? replies;
  dynamic event;
  User? user;

  Data({this.id, this.comment, this.userId, this.createdAt, this.userLike, this.likes, this.replies, this.event, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    comment = json["comment"];
    userId = json["user_id"];
    userLike = json["userlike"];
    likes = json["likecount"].toString();
    createdAt = json["created_at"];
    replies = json["replies"] == null ? null : (json["replies"] as List).map((e) => Replies.fromJson(e)).toList();
    event = json["event"];
    user = json["user"] == null ? null : User.fromJson(json["user"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["comment"] = comment;
    _data["user_id"] = userId;
    _data["likes"] = likes;
    _data["userlike"] = userLike;
    _data["created_at"] = createdAt;
    if(replies != null) {
      _data["replies"] = replies?.map((e) => e.toJson()).toList();
    }
    _data["event"] = event;
    if(user != null) {
      _data["user"] = user?.toJson();
    }
    return _data;
  }
}


class Replies {
  int? id;
  String? comment;
  String? userId;
  String? createdAt;
  dynamic event;
  User? user;

  Replies({this.id, this.comment, this.userId, this.createdAt, this.event, this.user});

  Replies.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    comment = json["comment"];
    userId = json["user_id"];
    createdAt = json["created_at"];
    event = json["event"];
    user = json["user"] == null ? null : User.fromJson(json["user"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["comment"] = comment;
    _data["user_id"] = userId;
    _data["created_at"] = createdAt;
    _data["event"] = event;
    if(user != null) {
      _data["user"] = user?.toJson();
    }
    return _data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? phone;
  String? isVerified;
  String? type;
  String? owner;
  String? guardEventId;
  dynamic position;
  dynamic country;
  dynamic state;
  String? status;
  dynamic address;
  dynamic zip;
  dynamic landline;
  dynamic cat;
  dynamic about;
  dynamic website;
  dynamic logo;
  dynamic year;
  dynamic eventAvg;
  dynamic guestAvg;
  dynamic compName;
  dynamic compCat;
  dynamic compAbout;
  dynamic compLogo;
  dynamic compWebsite;
  String? createdAt;
  String? updatedAt;
  dynamic eventsFollow;
  dynamic compsFollow;

  User({this.id, this.name, this.email, this.emailVerifiedAt, this.phone, this.isVerified, this.type, this.owner, this.guardEventId, this.position, this.country, this.state, this.status, this.address, this.zip, this.landline, this.cat, this.about, this.website, this.logo, this.year, this.eventAvg, this.guestAvg, this.compName, this.compCat, this.compAbout, this.compLogo, this.compWebsite, this.createdAt, this.updatedAt, this.eventsFollow, this.compsFollow});

  User.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    email = json["email"];
    emailVerifiedAt = json["email_verified_at"];
    phone = json["phone"];
    isVerified = json["isVerified"];
    type = json["type"];
    owner = json["owner"];
    guardEventId = json["guard_event_id"];
    position = json["position"];
    country = json["country"];
    state = json["state"];
    status = json["status"];
    address = json["address"];
    zip = json["zip"];
    landline = json["landline"];
    cat = json["cat"];
    about = json["about"];
    website = json["website"];
    logo = json["logo"];
    year = json["year"];
    eventAvg = json["event_avg"];
    guestAvg = json["guest_avg"];
    compName = json["comp_name"];
    compCat = json["comp_cat"];
    compAbout = json["comp_about"];
    compLogo = json["comp_logo"];
    compWebsite = json["comp_website"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
    eventsFollow = json["events_follow"];
    compsFollow = json["comps_follow"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["email"] = email;
    _data["email_verified_at"] = emailVerifiedAt;
    _data["phone"] = phone;
    _data["isVerified"] = isVerified;
    _data["type"] = type;
    _data["owner"] = owner;
    _data["guard_event_id"] = guardEventId;
    _data["position"] = position;
    _data["country"] = country;
    _data["state"] = state;
    _data["status"] = status;
    _data["address"] = address;
    _data["zip"] = zip;
    _data["landline"] = landline;
    _data["cat"] = cat;
    _data["about"] = about;
    _data["website"] = website;
    _data["logo"] = logo;
    _data["year"] = year;
    _data["event_avg"] = eventAvg;
    _data["guest_avg"] = guestAvg;
    _data["comp_name"] = compName;
    _data["comp_cat"] = compCat;
    _data["comp_about"] = compAbout;
    _data["comp_logo"] = compLogo;
    _data["comp_website"] = compWebsite;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    _data["events_follow"] = eventsFollow;
    _data["comps_follow"] = compsFollow;
    return _data;
  }
}