import '../../core/network_helper.dart';

class MoreRepository{
  static getVisitors(endPoint, {String? filter}) async {
    if(filter == "") {
      return await NetworkHelper.repo(endPoint, 'get');
    }else{
      return await NetworkHelper.repo("$endPoint?$filter", 'get');
    }
  }

  static getUserEvents() async {
    return await NetworkHelper.repo('event-users', 'get');
  }

  static scanQr(visitorId) async {
    return await NetworkHelper.repo('Scan-Event/$visitorId', 'get');
  }


  static deleteAccount(inputReasonDelete,checkboxData) async {
    return await NetworkHelper.repo('delete-user?inputreason=$inputReasonDelete&checkbox=$checkboxData', 'get');
  }

  static getDashboard() async {
    return await NetworkHelper.repo('statitics', 'get');
  }

  static profile() async {
    return await NetworkHelper.repo('Auth-User', 'get');
  }

  static Future staticPage(endPoint) async {
    return await NetworkHelper.repo("settings/$endPoint", "get");
  }

  static editProfile(formData, {required List<String> images}) async {
    return await NetworkHelper.repo('Edit-Profile', 'post',formData: formData,images: images,imageKey: "photo");
  }

}