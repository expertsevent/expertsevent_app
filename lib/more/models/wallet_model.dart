class WalletModel {
  bool? status;
  String? errNum;
  String? msg;
  List<Data>? transactions;
  int? wallet;
  int? spent;
  int? back;
  int? remain;

  WalletModel({this.status, this.errNum, this.msg, this.transactions,this.wallet,this.spent,this.back,this.remain});

  WalletModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    errNum = json["errNum"];
    msg = json["msg"];
    transactions = json["transactions"] == null ? null : (json["transactions"] as List).map((e) => Data.fromJson(e)).toList();
    wallet = json["wallet"];
    spent = json["spent"];
    back = json["back"];
    remain = json["remain"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["errNum"] = errNum;
    _data["msg"] = msg;
    if(transactions != null) {
      _data["transactions"] = transactions?.map((e) => e.toJson()).toList();
    }
    _data["wallet"] = wallet;
    _data["spent"] = spent;
    _data["back"] = back;
    _data["remain"] = remain;
    return _data;
  }
}

class Data {
  String? reason;
  String? type;
  dynamic price;
  String? icon;
  String? createdAt;
  Data({this.reason, this.type, this.price, this.icon, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    reason = json["reason"];
    type = json["type"];
    price = json["price"];
    icon = json["icon"];
    createdAt = json["created_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["reason"] = reason;
    _data["type"] = type;
    _data["price"] = price;
    _data["icon"] = icon;
    _data["created_at"] = createdAt;
    return _data;
  }
}