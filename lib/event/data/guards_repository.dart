
import '../../core/network_helper.dart';

class GuardsRepository{
  static getGuards({String? filter}) async {
    if(filter == "") {
      return await NetworkHelper.repo('all-guards', 'get');
    }else{
      return await NetworkHelper.repo("all-guards?$filter", 'get');
    }
  }

  static deleteGuard(id) async {
    return await NetworkHelper.repo("delete-guard/$id", 'get');
  }

  static addGuard(formData) async {
    return await NetworkHelper.repo("add-guard", 'post',formData: formData);
  }

  static editGuard(formData,id) async {
    return await NetworkHelper.repo("edit-guard/$id", 'post',formData: formData);
  }

  static addGuardToEvent(formData) async {
    return await NetworkHelper.repo("add_guards_to_event", 'post',formData: formData);
  }

  static deleteVisitorsFromEvent(formData) async {
    return await NetworkHelper.repo("delete_visitors_from_event", 'post',formData: formData);
  }

}