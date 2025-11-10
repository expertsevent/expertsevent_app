import '../../core/network_helper.dart';

class AddEventRepository{
  static eventTypes() async {
    return await NetworkHelper.repo("type-event", 'get');
  }

  static eventSubTypes(id) async {
    return await NetworkHelper.repo("subtype-event/$id", 'get');
  }

  static showHidePayment() async {
    return await NetworkHelper.repo("show-hide-payment", 'get');
  }

  static addEvent(formData, {required List<String> images}) async {
    return await NetworkHelper.repo("add-event", 'post',formData: formData,images: images,imageKey: "photo");
  }

  static pay(formData) async {
    return await NetworkHelper.repo("payment-event", 'post', formData: formData);
  }

  static addVisitorsToEvent(formData) async {
    return await NetworkHelper.repo("increase-visitors", 'post', formData: formData);
  }

}
