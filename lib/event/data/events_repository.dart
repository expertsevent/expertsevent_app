import '../../core/network_helper.dart';

class EventsRepository{
  static getEvents(endPoint, {String? filter}) async {
    if(filter == "") {
      return await NetworkHelper.repo(endPoint, 'get');
    }else{
      return await NetworkHelper.repo("$endPoint?$filter", 'get');
    }
  }

  static addComment(id, Map<String, String> formData) async {
    return await NetworkHelper.repo("add-comments/$id", 'post',formData: formData);
  }

  static cancelEvent(Map<String, String> formData) async {
    return await NetworkHelper.repo("cancel-or-poston-event", 'post',formData: formData);
  }

  static getComments(id) async {
    return await NetworkHelper.repo("all-comments/$id", 'get');
  }

  static getMoments(id) async {
    return await NetworkHelper.repo("getMoments/$id", 'get');
  }

  static addMoments(formData, {required List<String> images}) async {
    return await NetworkHelper.repo("addMoments", 'post',formData: formData,images: images,imageKey: "photo");
  }

  static addLike(id) async {
    return await NetworkHelper.repo("add-comment-like/$id", 'get');
  }

  static getGreetings(id) async {
    return await NetworkHelper.repo("getGreetings/$id", 'get');
  }

  static addGreetings(formData) async {
    return await NetworkHelper.repo("addGreetings", 'post',formData: formData);
  }

}