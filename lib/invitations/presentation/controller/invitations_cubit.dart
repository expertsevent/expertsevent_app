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

class InvitationsCubit extends Cubit<InvitationsStates>{
  InvitationsCubit(): super(InvitationsInitState());
  static InvitationsCubit get(context) => BlocProvider.of(context);


//////////// 1. Request Permissions Calendars ==================
  //////////// 1. Request Permissions Calendars ==================
  static final device_calendar.DeviceCalendarPlugin _deviceCalendarPlugin = device_calendar.DeviceCalendarPlugin();
  static Future<bool> requestPermissions() async {
    final permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && permissionsGranted.data == true) {
      return true;
    }
    final result = await _deviceCalendarPlugin.requestPermissions();
    return result.isSuccess && result.data == true;
  }
///////////////// 2. Create an Event Calendars ==============
  Future<void> createEvent({String? eventName,String? eventDate,String? eventTime,String? eventLocation,String? eventContent}) async {
    final hasPermissions = await requestPermissions();
    if (!hasPermissions) return;
    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
    if (!calendarsResult.isSuccess || calendarsResult.data == null || calendarsResult.data!.isEmpty) {
      if (kDebugMode) {
        print("❌ No calendars found or permission denied.");
      }
      return;
    }
    final calendar = calendarsResult.data?.firstWhere(
          (cal) => cal.isDefault ?? false,
      orElse: () => calendarsResult.data!.first,
    );
    if (calendar == null) {
      if (kDebugMode) {
        print("❌ No calendar found to create the event");
      }
      return;
    }
    // change to your local timezone
    final locationTimeZone = tz.getLocation('Asia/Riyadh');
    // Parse date and time separately
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
    //final endDateTime = startDateTime.subtract(const Duration(days: 1));
    // Check for duplicates
    final existingEventsResult = await _deviceCalendarPlugin.retrieveEvents(
      calendar.id,
      device_calendar.RetrieveEventsParams(
        startDate: startDateTime,
        endDate: endDateTime,
      ),
    );

    final isDuplicate = existingEventsResult.data?.any((e) =>
    e.title == eventName! &&
        e.start?.isAtSameMomentAs(startDateTime) == true &&
        e.end?.isAtSameMomentAs(endDateTime) == true) ??
        false;

    if (isDuplicate) {
      if (kDebugMode) {
        print("📅 Skipped duplicate: ${eventName!}");
      }
    }
    final event = device_calendar.Event(
      calendar.id,
      title: eventName!,
      start: tz.TZDateTime.from(startDateTime, locationTimeZone),
      end: tz.TZDateTime.from(endDateTime, locationTimeZone),
      description: eventContent!,
      location: eventLocation!,
      reminders: [
        device_calendar.Reminder(minutes: 60),
        device_calendar.Reminder(minutes: 30),
        device_calendar.Reminder(minutes: 15),
        device_calendar.Reminder(minutes: 5),
      ],

    );

    final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    if (result!.isSuccess && result.data!.isNotEmpty) {
      if (kDebugMode) {
        print("Event created: ${result.data}");
      }
    }
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