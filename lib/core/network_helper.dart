import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'cash_helper.dart';


class NetworkHelper {
  static Uri setApi(String endPoint) {
    return Uri.parse("https://api.expertsevent.com/api/$endPoint");
  }

    static String url = "https://api.expertsevent.com/";


  static Future<Map<String, dynamic>> repo(String endPoint, String type,
      {Map<String, String>? formData, bool headerState = true,List<String> images= const [],String imageKey=""}) async {
    String lang = await CashHelper.getSavedString("lang", "");
    String jwt = await CashHelper.getSavedString("jwt", "");
    if (kDebugMode) {
      print(formData);
      print(jwt);
      print(setApi(endPoint));
      print(lang);
    }
    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $jwt",
      "Accept-Language": lang
    };
    if(type.toLowerCase() != "get") {
      var request = http.MultipartRequest(
          type.toUpperCase(), NetworkHelper.setApi(endPoint));
      request.headers.addAll(headers);
      var index = 0;
      for (var element in images) {
        var multipartFileSign = await http.MultipartFile.fromPath(
        images.length == 1 ? imageKey : '$imageKey${index.toString()}' , element);
        request.files.add(multipartFileSign);
        index = index + 1;
      }
      // if(images.isEmpty){
      //   var multipartFileSign = await http.MultipartFile.fromPath(
      //       imageKey, "/Users/mohamedelsamman/Downloads/b.jpeg");
      //   request.files.add(multipartFileSign);
      // }
      if (formData != null) {
        request.fields.addAll(formData);
      }
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      if (kDebugMode) {
        print("res$respStr");
      }
      Map<String, dynamic> mapResponse = await json.decode(respStr);
      return mapResponse;
    }else{
      http.Response response = await http.get(NetworkHelper.setApi(endPoint),headers: headers);
      Map<String, dynamic> mapResponse = await json.decode(response.body);
      print("res$mapResponse");
      return mapResponse;
    }
  }
}