import 'dart:convert';
import 'dart:io';
import 'package:device_calendar/device_calendar.dart' as device_calendar;
import 'package:expert_events/core/app_util.dart';
import 'package:expert_events/home/presentation/controller/home_cubit.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../add_event/models/event_type.dart';
import '../../../event/models/events_model.dart';
import '../../data/invitations_repository.dart';
import 'invitations_states.dart';
import 'package:timezone/timezone.dart' as tz;
import '../../../../core/calendar_util.dart';

class InvitationsCubit extends Cubit<InvitationsStates>{
  InvitationsCubit(): super(InvitationsInitState());
  static InvitationsCubit get(context) => BlocProvider.of(context);


///////////////// 1. Create an Event Calendars ==============
  // Parse date and time separately
  Future<void> createEvent({String? eventName,String? eventDate,String? eventTime,String? eventLocation,String? eventContent}) async{
    final selectedDate = DateTime.parse(eventDate!);
    final selectedTimeParts = eventTime!.split(':');
    final selectedHour = int.parse(selectedTimeParts[0]);
    final selectedMinute = int.parse(selectedTimeParts[1]);

    // Combine date + time into one DateTime
    final startDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedHour,
      selectedMinute,
    );

    // Set event duration (example: 2 hours)
    final endDateTime = startDateTime.add(const Duration(hours: 0));
    await CalendarUtils.addAppointmentsToSystemCalendar(startDateTime, endDateTime, eventName!, eventContent!);

  }

  String endPoint = '';
  EventsModel? invitationsModel;

  getInvitations(endPoint,{String? filter}) async {
    emit(InvitationsLoadingState());
    try{
      Map<String,dynamic> response = await InvitationsRepository.getInvitations(endPoint,filter: filter??"");
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

  respond(context,id,type,{String? eventName,String? eventDate,String? eventTime,String? eventLocation,String? eventContent}) async {
    if(type == "accept") {
      emit(AcceptLoadingState());
    }else{
      emit(RejectLoadingState());
    }
    try{
      Map<String,dynamic> response = await InvitationsRepository.respond(id,type);
      if(response['status']){
        AppUtil.successToast(context, response['msg']);
        getInvitations('pending');
        HomeCubit.get(context).getInvitations();
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      if(type == "accept") {
         createEvent(eventName: eventName,eventDate : eventDate,eventTime : eventTime,eventLocation : eventLocation,eventContent :eventContent).catchError((e) {
           // Handle or ignore the error
           print('createEvent failed: $e');
         });
        emit(AcceptLoadedState());
      }else{
        emit(RejectLoadedState());
      }
    }catch(e){
      if(type == "accept") {
        emit(AcceptLoadedState());
      }else{
        emit(RejectLoadedState());
      }
      return Future.error(e);
    }
  }

  var location = TextEditingController();
  var name = TextEditingController();
  Types? selectedType;
  getFilterPath(){
    String filter = "";
    filter = "location=${location.text}";

    if(filter == ""){
      String filter = "name=${name.text}";
    }else{
      String filter = "&name=${name.text}";
    }
    if(selectedType!=null){
      if(filter == ""){
        filter = "type=${selectedType!.id}";
      }else{
        filter = "&type=${selectedType!.id}";
      }
    }
    return filter;
  }
}