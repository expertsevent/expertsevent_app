import '../../core/network_helper.dart';

class InvitationsRepository{
  static getInvitations(endPoint, {String? filter}) async {
    if(filter == "") {
      return await NetworkHelper.repo('invites/$endPoint', 'get');
    }else{
      return await NetworkHelper.repo("invites/$endPoint?$filter", 'get');
    }
  }
  static respond(id,type) async {
    return await NetworkHelper.repo('action/$id/$type', 'get');
  }

}