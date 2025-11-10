class UserModel {
  bool? status;
  String? errNum;
  String? msg;
  Data? data;

  UserModel({this.status, this.errNum, this.msg, this.data});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json["status"];
    errNum = json["errNum"];
    msg = json["msg"];
    data = json["data"] == null ? json["user"] == null ? null : Data.fromJson(json["user"]) : Data.fromJson(json["data"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["status"] = status;
    _data["errNum"] = errNum;
    _data["msg"] = msg;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    return _data;
  }
}

class Data {
  String? name;
  String? phone;
  String? photo;
  String? email;
  String? birthdate;
  String? type;
  String? package_name;
  int? package_id;
  int? isVerified; 
  String? updatedAt;
  String? createdAt;
  int? id;
  String? apiToken;

  Data({this.name, this.phone, this.email, this.birthdate, this.type,this.package_name,this.package_id, this.isVerified,this.updatedAt, this.createdAt, this.id, this.apiToken});

  Data.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    phone = json["phone"];
    photo = json["photo"];
    email = json["email"];
    birthdate = json["birthdate"];
    type = json["type"];
    package_name = json["package_name"];
    package_id = json["package_id"];
    isVerified = json["isVerified"];
    updatedAt = json["updated_at"];
    createdAt = json["created_at"];
    id = json["id"];
    apiToken = json["api_token"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["phone"] = phone;
    _data["photo"] = photo;
    _data["email"] = email;
    _data["birthdate"] = birthdate;
    _data["type"] = type;
    _data["package_name"] = package_name;
    _data["package_id"] = package_id;
    _data["isVerified"] = isVerified;
    _data["updated_at"] = updatedAt;
    _data["created_at"] = createdAt;
    _data["id"] = id;
    _data["api_token"] = apiToken;
    return _data;
  }
}
