class DashboardModel {
  bool? status;
  String? errNum;
  String? msg;
  int? allevents;
  int? activeevent;
  int? pendingevent;
  int? finishevent;
  int? draftevent;
  int? cancelevent;
  int? allvisitor;
  int? attendvisitor;
  int? cancelvisitor;
  int? waitingvisitor;
  List<EventsSummary>? eventsSummary;

  DashboardModel({this.status, this.errNum, this.msg, this.allevents,this.activeevent, this.pendingevent, this.finishevent, this.draftevent, this.cancelevent,this.allvisitor, this.attendvisitor, this.cancelvisitor, this.waitingvisitor, this.eventsSummary});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    errNum = json["errNum"];
    msg = json["msg"];
    allevents = json["allevents"];
    activeevent = json["activeevent"];
    pendingevent = json["pendingevent"];
    finishevent = json["finishevent"];
    draftevent = json["draftevent"];
    cancelevent = json["cancelevent"];
    allvisitor = json["allvisitor"];
    attendvisitor = json["attendvisitor"];
    cancelvisitor = json["cancelvisitor"];
    waitingvisitor = json["waitingvisitor"];
    eventsSummary = json["EventsSummary"] == null ? null : (json["EventsSummary"] as List).map((e) => EventsSummary.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["errNum"] = errNum;
    _data["msg"] = msg;
    _data["allevents"] = allevents;
    _data["activeevent"] = activeevent;
    _data["pendingevent"] = pendingevent;
    _data["finishevent"] = finishevent;
    _data["draftevent"] = draftevent;
    _data["cancelevent"] = cancelevent;
    _data["allvisitor"] = allvisitor;
    _data["attendvisitor"] = attendvisitor;
    _data["cancelvisitor"] = cancelvisitor;
    _data["waitingvisitor"] = waitingvisitor;
    if(eventsSummary != null) {
      _data["EventsSummary"] = eventsSummary?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class EventsSummary {
  String? name;
  int? id;
  int? comments;
  int? invites;

  EventsSummary({this.name, this.id, this.comments, this.invites});

  EventsSummary.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    id = json["id"];
    comments = json["comments"];
    invites = json["invites"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["id"] = id;
    _data["comments"] = comments;
    _data["invites"] = invites;
    return _data;
  }
}