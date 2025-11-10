import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/core/app_util.dart';
import 'package:expert_events/event/models/comments_model.dart';
import 'package:expert_events/layout/presentation/screens/layout_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../add_event/models/event_type.dart';
import '../../../data/events_repository.dart';
import '../../../models/events_model.dart';
import '../../../models/greeting_model.dart';
import '../../../models/share_moment_model.dart';
import 'events_states.dart';

class EventsCubit extends Cubit<EventsStates>{
  EventsCubit():super(EventsInitState());
  static EventsCubit get(context) => BlocProvider.of(context);

  var eventFormKey = GlobalKey<FormState>();

  var selectType = TextEditingController();

  final ImagePicker sharesPicker = ImagePicker();
  // List<XFile>? eventPhoto = [];
  XFile? eventPhoto;
  XFile? eventPhoto1;
  XFile? eventPhoto2;
  XFile? eventPhoto3;
  XFile? eventPhoto4;

  List<String> pathes = [];


  chooseImageDialog(context,index) async {
    //openGallery(context);
    openCamera(context,index);
  }

  openCamera(context,index) async {
    if(index == 0) {
      eventPhoto = await sharesPicker.pickImage(source: ImageSource.camera);
      pathes.add(eventPhoto!.path);
    }else if(index == 1) {
      eventPhoto1 = await sharesPicker.pickImage(source: ImageSource.camera);
      pathes.add(eventPhoto1!.path);
    }else if(index == 2) {
      eventPhoto2 = await sharesPicker.pickImage(source: ImageSource.camera);
      pathes.add(eventPhoto2!.path);
    }else if(index == 3) {
      eventPhoto3 = await sharesPicker.pickImage(source: ImageSource.camera);
      pathes.add(eventPhoto3!.path);
    }else if(index == 4) {
      eventPhoto4 = await sharesPicker.pickImage(source: ImageSource.camera);
      pathes.add(eventPhoto4!.path);
    }
    emit(EventPhotoChangeState());
  }
  openGallery(context) async {
    // final List<XFile>? selectedImages = await sharesPicker.pickMultiImage();
    // if(selectedImages!.isNotEmpty){
    //   eventPhoto!.addAll(selectedImages);
    // }
    eventPhoto = await sharesPicker.pickImage(source: ImageSource.gallery); //pickMultiImage()
    // Navigator.of(context,rootNavigator: true).pop();
    emit(EventPhotoChangeState());
  }

  // Future<PermissionStatus> requestCameraPermission() async {
  //   return await Permission.camera.request();
  // }
  //
  // Future<bool> handleCameraPermission(BuildContext context) async {
  //   PermissionStatus cameraPermissionStatus = await requestCameraPermission();
  //
  //   if (cameraPermissionStatus != PermissionStatus.granted) {
  //     print('😰 😰 😰 😰 😰 😰 Permission to camera was not granted! 😰 😰 😰 😰 😰 😰');
  //     await showDialog(
  //       context: context,
  //       builder: (_context) => AppAlertDialog(
  //         onConfirm: () => openAppSettings(),
  //         title: 'Camera Permission',
  //         subtitle: 'Camera permission should Be granted to use this feature, would you like to go to app settings to give camera permission?',
  //       ),
  //     );
  //     return false;
  //   }
  //   return true;
  // }

  EventsModel? draftEventsModel;

  getDraftEvents({String? filter}) async {
    emit(DraftEventsLoadingState());
    try{
      Map<String,dynamic> response = await EventsRepository.getEvents("draft-events",filter: filter??"");
      draftEventsModel = EventsModel.fromJson(response);
      if(draftEventsModel!.data.isEmpty){
        emit(DraftEventsEmptyState());
      }else {
        emit(DraftEventsLoadedState());
      }
    }catch(e){
      if (!isClosed) {
        emit(DraftEventsErrorState());
      }
      return Future.error(e);
    }
  }

  EventsModel? waitEventsModel;
  getWaitEvents({String? filter}) async {
    emit(WaitEventsLoadingState());
    // try{
      Map<String,dynamic> response = await EventsRepository.getEvents("wait-events",filter: filter??"");
      waitEventsModel = EventsModel.fromJson(response);
      if(waitEventsModel!.data.isEmpty){
        emit(WaitEventsEmptyState());
      }else {
        emit(WaitEventsLoadedState());
      }
    // }catch(e){
    //   emit(WaitEventsErrorState());
    //   return Future.error(e);
    // }
  }

  EventsModel? finishEventsModel;
  getFinishEvents({String? filter}) async {
    emit(FinishEventsLoadingState());
    try {
      Map<String, dynamic> response = await EventsRepository.getEvents("finish-events", filter: filter ?? "");
      finishEventsModel = EventsModel.fromJson(response);
      if (finishEventsModel!.data.isEmpty) {
        emit(FinishEventsEmptyState());
      } else {
        emit(FinishEventsLoadedState());
      }
    } catch (e) {
      emit(FinishEventsErrorState());
      return Future.error(e);
    }
  }

  EventsModel? cancelEventsModel;
  getCancelEvents({String? filter}) async {
    emit(CancelEventsLoadingState());
    try{
      Map<String,dynamic> response = await EventsRepository.getEvents("cancel-events",filter: filter??"");
      cancelEventsModel = EventsModel.fromJson(response);
      if(cancelEventsModel!.data.isEmpty){
        emit(CancelEventsEmptyState());
      }else {
        emit(CancelEventsLoadedState());
      }
    }catch(e){
      emit(CancelEventsErrorState());
      return Future.error(e);
    }
  }

  EventsModel? activeEventsModel;
  getActiveEvents({String? filter}) async {
    emit(ActiveEventsLoadingState());
    try{
      Map<String,dynamic> response = await EventsRepository.getEvents("active-events",filter: filter??"");
      activeEventsModel = EventsModel.fromJson(response);
      if(activeEventsModel!.data.isEmpty){
        emit(ActiveEventsEmptyState());
      }else {
        emit(ActiveEventsLoadedState());
      }
    }catch(e){
      emit(ActiveEventsErrorState());
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
      filter = "name=${name.text}";
    }else{
      filter = "&name=${name.text}";
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

  addComment(context,String comment,eventId, {String id = "0"}) async {
    Map<String,String> formData = {
      "comment": comment,
      "event_id": eventId
    };

    emit(AddCommentLoadingState());
    try{
      Map<String,dynamic> response = await EventsRepository.addComment(id,formData);
      if(response['status']){
        getComments(eventId);
        Navigator.of(context,rootNavigator: true).pop();
        AppUtil.successToast(context, response['msg']);
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(AddCommentLoadedState());
    }catch(e){
      emit(AddCommentLoadedState());
      return Future.error(e);
    }
  }

  addLike(id) async {
    try{
      Map<String,dynamic> response = await EventsRepository.addLike(id);
    }catch(e){
      return Future.error(e);
    }
  }

  var reason = TextEditingController();
  var dob = TextEditingController();
  var time = TextEditingController();
  selectDate(context) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(DateTime.now().year + 100));
    if (date != null) {
      dob.text =
      "${date.year}-${date.month < 10 ? "0${date.month}" : date.month}-${date.day < 10 ? "0${date.day}" : date.day}";
    }
  }

  selectTime(context) async {
    TimeOfDay? date = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (date != null) {
      time.text =
      "${date.hour}:${date.minute < 10 ? "0${date.minute}" : date.minute}";
    }
  }
  cancelEvent(context,id,type) async {
    Map<String,String> formData = {
      "event_id": id.toString(),
      "type": type,
      "message": reason.text,
    };
    if(type == "postpone") {
      formData.addAll({"date": dob.text,"time": time.text});
    }
    emit(CancelEventLoadingSate());
    try{
      Map<String,dynamic> response = await EventsRepository.cancelEvent(formData);
      if(response['status']){
        reason.clear();
        dob.clear();
        time.clear();
        AppUtil.removeUntilNavigator(context, const LayoutScreen());
        AppUtil.successToast(context, response['msg']);
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(CancelEventLoadedSate());
    }catch(e){
      emit(CancelEventLoadingSate());
      return Future.error(e);
    }
  }

  var replyControllers = [];
  Comments? comments;
  getComments(eventId) async {
    replyControllers.clear();
    emit(CommentLoadingState());
    try{
      Map<String,dynamic> response = await EventsRepository.getComments(eventId);
     comments = Comments.fromJson(response);
     if(comments!.data!.isNotEmpty) {
       for (var element in comments!.data!) {
         replyControllers.add(TextEditingController());
       }
       emit(CommentLoadedState());
     }else{
       emit(CommentEmptyState());
     }
    }catch(e){
      emit(CommentErrorState());
      return Future.error(e);
    }
  }


  ShareMomentModel? momentModel;
  getMoments(eventId) async {
    emit(MomentsLoadingState());
    try{
      Map<String,dynamic> response = await EventsRepository.getMoments(eventId);
      momentModel = ShareMomentModel.fromJson(response);
      print(response);
      if(momentModel!.status!){
        emit(MomentsLoadedState());
      }
      if(momentModel!.data.isEmpty) {
        emit(MomentsEmptyState());
      }
    }catch(e){
      emit(MomentsErrorState());
      print(e.toString());
      return Future.error(e);
    }
  }

  addMoments(context, {required String? id}) async {
    if(eventPhoto == null && eventPhoto1 == null && eventPhoto2 == null && eventPhoto3 == null && eventPhoto4 == null) {
      AppUtil.errorToast(context,"please upload photos".tr());
    }else {
      Map<String, String> formData = {
        "privacy": selectType.text,
        "event_id": id.toString(),
      };
      emit(AddMomentLoadingState());
      try {
        Map<String, dynamic> response = await EventsRepository.addMoments(
          formData, images: eventPhoto == null && eventPhoto1 == null && eventPhoto2 == null && eventPhoto3 == null && eventPhoto4 == null
          ? [] : pathes,);
        print(response);
        if (response['status']) {
          emit(AddMomentLoadedState());
          selectType.clear();
          eventPhoto = null;
          AppUtil.successToast(context, response['msg']);
        }else{
          selectType.clear();
          eventPhoto = null;
          emit(AddMomentLoadedState());
          AppUtil.errorToast(context, response['msg']);
        }
      } catch (e) {
        emit(AddMomentLoadedState());
        AppUtil.errorToast(context, e.toString());
        return Future.error(e);
      }
    }
  }


  GreetingsModel? greetingsModel;
  getGreetings(eventId) async {
    emit(GreetingsLoadingState());
    try{
      Map<String,dynamic> response = await EventsRepository.getGreetings(eventId);
      greetingsModel = GreetingsModel.fromJson(response);
      print(response);
      if(greetingsModel!.status!){
        emit(GreetingsLoadedState());
      }
      if(greetingsModel!.data!.isEmpty) {
        emit(GreetingsEmptyState());
      }
    }catch(e){
      emit(GreetingsErrorState());
      print(e.toString());
      return Future.error(e);
    }
  }

  addGreetings(context, String text, {required String? id}) async {
      Map<String, String> formData = {
        "event_id": id.toString(),
        'comment' : text
      };
      emit(AddGreetingLoadingState());
      try {
        Map<String, dynamic> response = await EventsRepository.addGreetings(formData);
        print(response);
        if (response['status']) {
          emit(AddGreetingLoadedState());
          AppUtil.successToast(context, response['msg']);
        }else{
          emit(AddGreetingLoadedState());
          AppUtil.errorToast(context, response['msg']);
        }
      } catch (e) {
        emit(AddGreetingLoadedState());
        AppUtil.errorToast(context, e.toString());
        return Future.error(e);
      }
  }

}
