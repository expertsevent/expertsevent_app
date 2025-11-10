import 'package:expert_events/auth/models/user_model.dart';
import 'package:expert_events/core/app_util.dart';
import 'package:expert_events/more/data/more_repository.dart';
import 'package:expert_events/more/models/dashboard_model.dart';
import 'package:expert_events/more/models/visitors_model.dart';
import 'package:expert_events/more/presentation/controller/more_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../core/cash_helper.dart';
import '../../../event/models/events_model.dart' as event;
import '../screens/pages/profile/delete_account_page.dart';

class MoreCubit extends Cubit<MoreStates>{
  MoreCubit():super(MoreInitState());
  static MoreCubit get(context) => BlocProvider.of(context);
  GlobalKey? scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  var inputReasonDelete= TextEditingController();
  String checkboxData = "";

  bool _deleteCheck = true;
  bool get deleteCheck => _deleteCheck;
  set deleteCheck(bool deleteCheck) {
    _deleteCheck = deleteCheck;
    emit(deleteCheckChangeState());
  }

  int _deleteCheckbox1 = 1;
  int get deleteCheckbox1 => _deleteCheckbox1;
  set deleteCheckbox1(int deleteCheckbox1) {
    _deleteCheckbox1 = deleteCheckbox1;
    emit(deleteCheckboxChangeState());
  }

  int _deleteCheckbox2 = 0;
  int get deleteCheckbox2  => _deleteCheckbox2;
  set deleteCheckbox2 (int deleteCheckbox2 ) {
    _deleteCheckbox2 = deleteCheckbox2 ;
    emit(deleteCheckboxChangeState());
  }

  int _deleteCheckbox3 = 0;
  int get deleteCheckbox3 => _deleteCheckbox3;
  set deleteCheckbox3(int deleteCheckbox3) {
    _deleteCheckbox3 = deleteCheckbox3;
    emit(deleteCheckboxChangeState());
  }

  int _deleteCheckbox4 = 0;
  int get deleteCheckbox4 => _deleteCheckbox4;
  set deleteCheckbox4(int deleteCheckbox4) {
    _deleteCheckbox4 = deleteCheckbox4;
    emit(deleteCheckboxChangeState());
  }

  String reasonDelete = "";
  String userPhone = '';
  getUserPhone() async {
    userPhone = await CashHelper.getSavedString("phone","");
    return userPhone;
  }

  String userName = '';
  getUserName() async {
    userName = await CashHelper.getSavedString("name","");
    return userName;
  }

  String userType = '';
  getUsertype() async {
    userType = await CashHelper.getSavedString("type","");
    return userType;
  }


  DashboardModel? dashboardModel;

  getDashboard() async {
    emit(DashboardLoadingState());
    try{
      Map<String,dynamic> response = await MoreRepository.getDashboard();
      dashboardModel = DashboardModel.fromJson(response);
      emit(DashboardLoadedState());
    }catch(e){
      emit(DashboardErrorState());
      return Future.error(e);
    }
  }

  String content = "";
  staticPage(endPoint) async {
    emit(StaticPageLoadingState());
    try{
      Map<String, dynamic> response = await MoreRepository.staticPage(endPoint);
      content = response['data'];
      emit(StaticPageLoadedState());
    }catch(e){
      emit(StaticPageErrorState());
      return Future.error(e);
    }
  }

  Visitors? visitors;

  getVisitors(endPoint,{String? filter}) async {
    emit(VisitorsLoadingState());
    try{
      Map<String,dynamic> response = await MoreRepository.getVisitors(endPoint,filter: filter??"");
      visitors = Visitors.fromJson(response);
      if(visitors!.data!.isEmpty){
        emit(VisitorsEmptyState());
      }else {
        emit(VisitorsLoadedState());
      }
    }catch(e){
      emit(VisitorsErrorState());
      return Future.error(e);
    }
  }

  var filterController = TextEditingController();
  event.Event? selectedEvent;
  event.EventsModel? eventsModel;
  getUserEvents() async {
    try{
      Map<String,dynamic> response = await MoreRepository.getUserEvents();
      eventsModel = event.EventsModel.fromJson(response);
    }catch(e){
      return Future.error(e);
    }
  }

  deleteAccount(context) async {
    try{
      Map<String,dynamic> response = await MoreRepository.deleteAccount(inputReasonDelete,checkboxData);
      if(response['status']){
        AppUtil.mainNavigator(context, const DeleteAccountPage());
      }
    }catch(e){
      return Future.error(e);
    }
  }


  scanQr(visitorId,context) async {
    emit(ScanQrLoadingState());
    try{
      Map<String,dynamic> response = await MoreRepository.scanQr(visitorId);
      if(response['status']){
            AppUtil.successToast(context, response['msg']);
            emit(ScanQrLoadedState());
      }else{
        AppUtil.errorToast(context, response['msg']);
        emit(ScanQrLoadedState());
      }
      emit(ScanQrLoadedState());
    }catch(e){
      AppUtil.errorToast(context, e.toString());
      emit(ScanQrErrorState());
      return Future.error(e);
    }
  }
}

