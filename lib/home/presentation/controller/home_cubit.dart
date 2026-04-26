
import 'package:expert_events/home/models/notification_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/cash_helper.dart';
import '../../../core/guest_mode.dart';
import '../../../event/models/events_model.dart';
import '../../data/home_repository.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeStates>{
  HomeCubit():super(HomeInitStates());
  static HomeCubit get(context) => BlocProvider.of(context);

  String userPhone = '';
  getUserPhone() async {
    userPhone = await CashHelper.getSavedString("phone","");
    return userPhone;
  }

  String userType = '';
  getUsertype() async {
    userType = await CashHelper.getSavedString("type","");
    return userType;
  }

  EventsModel? eventsModel;
  getEvents() async {
    if (GuestMode.isGuest) {
      eventsModel = GuestMode.buildMockEvents();
      emit(EventsLoadedState());
      return;
    }
    emit(EventsLoadingState());
    try{
      Map<String,dynamic> response = await HomeRepository.getEvents();
      eventsModel = EventsModel.fromJson(response);
      if(eventsModel!.data.isEmpty){
        emit(EventsEmptyState());
      }else {
        emit(EventsLoadedState());
      }
    }catch(e){
      emit(EventsErrorState());
      return Future.error(e);
    }
  }

  EventsModel? invitationsModel;

  getInvitations() async {
    if (GuestMode.isGuest) {
      invitationsModel = GuestMode.buildMockInvitations();
      emit(InvitationsLoadedState());
      return;
    }
    emit(InvitationsLoadingState());
    try{
      Map<String,dynamic> response = await HomeRepository.getInvitations();
      invitationsModel = EventsModel.fromJson(response);
      if(invitationsModel!.data.isEmpty){
        emit(InvitationsEmptyState());
      }else {
        emit(InvitationsLoadedState());
      }
    }catch(e){
      emit(InvitationsErrorState());
      return Future.error(e);
    }
  }

  NotificationModel? notificationModel;

  notification() async {
    if (GuestMode.isGuest) {
      // Guest UI replaces the body with a sign-in CTA, so we don't need a
      // model here. Emit empty so the original loading spinner doesn't run.
      emit(NotificationEmptyState());
      return;
    }
    emit(NotificationLoadingState());
    try{
      Map<String,dynamic> response = await HomeRepository.notification();
      notificationModel = NotificationModel.fromJson(response);
      if(notificationModel!.invites!.isEmpty){
        emit(NotificationEmptyState());
      }else {
        emit(NotificationLoadedState());
      }
    }catch(e){
      emit(NotificationErrorState());
      return Future.error(e);
    }
  }

  bool   showAd = false;
  String textAd = "";
  String photoAd = "";
  showHideAds() async {
    if (GuestMode.isGuest) {
      showAd = false;
      textAd = "";
      photoAd = "";
      return;
    }
    try{
      Map<String,dynamic> response = await HomeRepository.showHideAds();
      String adId = await CashHelper.getSavedString('ad_id', "");
      if(adId == response['id'].toString() || response['id'].toString() == "0"){
         showAd  = false;
         textAd  = "";
         photoAd = "";
      }else{
         showAd  = true;
         textAd  = response['text'];
         photoAd = response['photo'];
         await CashHelper.setSavedString("ad_id", response['id'].toString());
      }
    }catch(e){
      return Future.error(e);
    }
  }

}