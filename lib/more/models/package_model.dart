import 'dart:convert';

class PackageModel {
  bool? status;
  String? errNum;
  String? msg;
  List<Data>? data;

  PackageModel({this.status, this.errNum, this.msg, this.data});

  PackageModel.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? descripton;
  String? price;
  int? isRecommended;
  String? visitors;
  double? invitaion_price;
  String? createdAt;
  String? updatedAt;
  Data({this.id, this.invitaion_price, this.title, this.descripton, this.price, this.isRecommended, this.visitors, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    invitaion_price = json["invitaion_price"];
    title = json["title"];
    descripton = json["descripton"];
    price = json["price"];
    isRecommended = json["isRecommended"];
    visitors = json["visitors"];
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["invitaion_price"] = invitaion_price;
    _data["title"] = title;
    _data["descripton"] = descripton;
    _data["price"] = price;
    _data["isRecommended"] = isRecommended;
    _data["visitors"] = visitors;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}