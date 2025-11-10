import '../../core/network_helper.dart';

class HomeRepository{
  static getEvents() async {
    return await NetworkHelper.repo("home", 'get');
  }

  static getInvitations() async {
    return await NetworkHelper.repo("invites/pending", 'get');
  }

  static notification() async {
    return await NetworkHelper.repo("notifications", 'get');
  }

  static showHideAds() async {
    return await NetworkHelper.repo("popads", 'get');
  }

  static Future sendToken(formData) async {
    return await NetworkHelper.repo("add_guest_token","post", formData: formData);
  }

}