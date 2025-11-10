import 'dart:convert';
import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:expert_events/event/presentation/controller/events/events_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/app_util.dart';
import '../../../home/presentation/controller/home_cubit.dart';
import '../../../layout/presentation/screens/layout_screen.dart';
import '../../data/add_event_repository.dart';
import '../../models/event_subtype.dart';
import '../../models/event_type.dart';
import 'add_event_states.dart';

class AddEventCubit extends Cubit<AddEventState> {
  AddEventCubit() : super(AddEventInit());
  static AddEventCubit get(context) => BlocProvider.of(context);

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var eventFormKey = GlobalKey<FormState>();
  int _pageIndex = 0;


  int get pageIndex => _pageIndex;

  set pageIndex(int pageIndex) {
    _pageIndex = pageIndex;
    emit(PageChangeState());
  }

  final ImagePicker carsPicker = ImagePicker();
  File? eventPhoto;
  XFile? eventPhotoUpload;

  chooseImageDialog(context) async {
    openGallery(context);
  }

  openGallery(context) async {
    eventPhotoUpload = await carsPicker.pickImage(source: ImageSource.gallery);
    // Navigator.of(context,rootNavigator: true).pop();
    emit(EventPhotoChangeState());
  }

  bool _uploadImageCheck = false;
  bool get uploadImageCheck => _uploadImageCheck;
  set uploadImageCheck(bool uploadImageCheck) {
    _uploadImageCheck = uploadImageCheck;
    emit(UploadImageCheckChangeState());
  }

  var eventName = TextEditingController();
  var dob = TextEditingController();
  var time = TextEditingController();
  var eventType = TextEditingController();
  var address = TextEditingController();
  LatLng? location;
  var desc = TextEditingController();
  var descTheme = TextEditingController();

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

  bool _checkBox = false;

  bool get checkBox => _checkBox;

  set checkBox(bool checkBox) {
    _checkBox = checkBox;
    emit(CheckBoxChangeSate());
  }

  EventTypesModel? eventTypesModel;
  Types? selectedType;

  eventTypes() async {
    emit(EventTypesLoadingState());
    try {
      Map<String, dynamic> response = await AddEventRepository.eventTypes();
      eventTypesModel = EventTypesModel.fromJson(response);
      if (eventTypesModel!.types.isEmpty) {
        emit(EventTypesEmptyState());
      } else {
        emit(EventTypesLoadedState());
      }
    } catch (e) {
      emit(EventTypesErrorState());
      return Future.error(e);
    }
  }

  EventSubTypesModel? eventSubTypesModel;
  int? selectedSubType;
  String? selectedSubTypePhoto;
  String? selectedSubTypePackage;

  eventSubTypes(context, int? id) async {
    emit(EventSubTypesLoadingState());
    try {
      Map<String, dynamic> response =
      await AddEventRepository.eventSubTypes(id.toString());
      print(response);
      eventSubTypesModel = EventSubTypesModel.fromJson(response);
      if (eventSubTypesModel!.types.isEmpty) {
        emit(EventSubTypesEmptyState());
      } else {
        emit(EventSubTypesLoadedState());
      }
    } catch (e) {
      emit(EventSubTypesErrorState());
      return Future.error(e);
    }
  }

  changeText(context) async {
    emit(EventSubTypesTextChangeState());
  }

  resetEventData() {
    eventName.clear();
    dob.clear();
    time.clear();
    eventType.clear();
    address.clear();
    desc.clear();
    location = null;
    eventPhoto = null;
    selectedType == null;
    selectedSubType == null;
    contacts.clear();
    _contactsCheck.clear();
    names.clear();
    phones.clear();
    invitation = 0;
  }

  List<Contact> contacts = [];
  final List<String> _contactsCheck = [];
  List<String> names = [];
  List<String> phones = [];
  int invitation = 0;

  List<String> get contactsCheck => _contactsCheck;
  setContactsCheck(index, String contactsCheck) {
    _contactsCheck.add(contactsCheck);
    emit(ContactChangeState());
  }

  selectAllContacts() {
    _contactsCheck.clear();
    for (var element in contacts) {
      for (var element in element.phones!) {
        _contactsCheck.add(element.value!);
      }
    }
    emit(ContactsLoadedState());
  }

  unSelectAllContacts() {
    _contactsCheck.clear();
    emit(ContactsLoadedState());
  }

//////////// 1. Request Permissions Calendars ==================
  static final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  static Future<bool> requestPermissions() async {
    final permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && permissionsGranted.data == true) {
      return true;
    }
    final result = await _deviceCalendarPlugin.requestPermissions();
    return result.isSuccess && result.data == true;
  }
///////////////// 2. Create an Event Calendars ==============
  Future<void> createEvent() async {
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
    final selectedDate = DateTime.parse(dob.text);
    final selectedTimeParts = time.text.split(':');
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
      RetrieveEventsParams(
        startDate: startDateTime,
        endDate: endDateTime,
      ),
    );

    final isDuplicate = existingEventsResult.data?.any((e) =>
    e.title == eventName.text &&
        e.start?.isAtSameMomentAs(startDateTime) == true &&
        e.end?.isAtSameMomentAs(endDateTime) == true) ??
        false;

    if (isDuplicate) {
      if (kDebugMode) {
        print("📅 Skipped duplicate: ${eventName.text}");
      }
    }
    final event = Event(
      calendar.id,
      title: eventName.text,
      start: tz.TZDateTime.from(startDateTime, locationTimeZone),
      end: tz.TZDateTime.from(endDateTime, locationTimeZone),
      description: desc.text,
      location: address.text,
      reminders: [
        Reminder(minutes: 60),
        Reminder(minutes: 30),
        Reminder(minutes: 15),
        Reminder(minutes: 5),
      ],

    );

    final result = await _deviceCalendarPlugin.createOrUpdateEvent(event);
    if (result!.isSuccess && result.data!.isNotEmpty) {
      if (kDebugMode) {
        print("Event created: ${result.data}");
      }
    }
  }

  ////////////////start Contacts permissions
  Future<void> askPermissions(context) async {
    if (Platform.isAndroid) {
      PermissionStatus permissionStatus = await _getContactPermission();
      if (permissionStatus == PermissionStatus.granted) {
        getContacts();
      } else {
        _handleInvalidPermissions(permissionStatus, context);
      }
    } else {
      getContacts();
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus, context) {
    if (permissionStatus == PermissionStatus.denied) {
      AppUtil.errorToast(context, 'Access to contact data denied');
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      AppUtil.errorToast(context, 'Contact data not available on device');
    }
  }

  getContacts({String search = ""}) async {
    contacts.clear();
    // contactsCheck.clear();
    // contactsCheckTrue.clear();
    emit(ContactsLoadingState());
    try {
      contacts = search.isEmpty
          ? await ContactsService.getContacts(
        withThumbnails: false,
        photoHighResolution: false,
        iOSLocalizedLabels: false,
      )
          : await ContactsService.getContacts(
        query: search,
        withThumbnails: false,
        photoHighResolution: false,
        iOSLocalizedLabels: false,
      );
      contacts.removeWhere(
              (element) => element.phones == null || element.phones!.isEmpty || element.displayName == null);
      int i = 0;
      for (var element in contacts) {
        contacts[i].displayName = contacts[i].displayName ?? '';
        int y = 0;
        for (var element2 in contacts[i].phones!) {
          contacts[i].phones![y].value = element2.value!.replaceAll(" ", "");
          y++;
        }
        i++;
      }
      i = 0;
      for (var element in contacts) {
        contacts[i].phones = [
          ...{...element.phones!}
        ];
        i++;
      }

      if (contacts.isEmpty) {
        emit(ContactsEmptyState());
      } else {
        emit(ContactsLoadedState());
      }
    } catch (e) {
      emit(ContactsErrorState());
      return Future.error(e);
    }
  }

  var contactName = TextEditingController();
  var contactPhone = TextEditingController();
  var contactCountryCode = TextEditingController();
  var searchContact = TextEditingController();

  addContact() async {
    Contact newContact = Contact(
        familyName: contactName.text,
        displayName: contactName.text,
        androidAccountName: contactName.text,
        phones: [
          Item(
              label: "",
              value: "+${contactCountryCode.text}${contactPhone.text}")
        ]);
    try {
      await ContactsService.addContact(newContact);
      getContacts();
      emit(ContactsLoadedState());
    } catch (e) {
      emit(ContactsErrorState());
      return Future.error(e);
    }
  }

  int? eventId;
  addEvent(guards, context, {required bool draft, String? id, bool pay = false,bool package = false}) async {
    int i = 0;
    for (var element in phones) {
      if (phones[i].contains("+")) {
        phones[i] = element.substring(1);
      }
      i++;
    }
    Map<String, String> formData = {
      "name": eventName.text,
      "date_from": dob.text,
      "time": time.text,
      "type": selectedType!.id.toString(),
      "content": desc.text,
      "link_deep": "kk",
      "address": address.text,
      "lat": location!.latitude.toString(),
      "lang": location!.longitude.toString(),
      "draft": draft ? "1" : "0",
      "payment": pay ? "1" : "0",
    };
    if (id == null) {
      formData.addAll({
        "guards": guards.toString(),
        "names": jsonEncode(names),
        "phone": jsonEncode(phones),
      });
    } else {
      formData.addAll({
        "event_id": id,
        // "guards": guards.toString(),
        // "names": jsonEncode(names),
        // "phone": jsonEncode(phones)
      });
    }
    if (!draft) {
      emit(AddEventLoadingState());
    } else {
      emit(AddDraftEventLoadingState());
    }
    try {
      Map<String, dynamic> response = await AddEventRepository.addEvent(
        formData,
        images: eventPhoto == null ? eventPhotoUpload == null ? [] : [eventPhotoUpload!.path] : [eventPhoto!.path],
      );
      if (response['status']) {
        createEvent().catchError((e) {
          // Handle or ignore the error
          print('createEvent failed: $e');
        });
        if (draft) {
          resetEventData();
          if(package){
            names.clear();
            phones.clear();
            contactsCheck.clear();
            return ;
          }
          if (id != null) {
            Navigator.of(context, rootNavigator: true).pop();
            //AppUtil.removeUntilNavigator(context, const LayoutScreen());
          }
          Navigator.of(context, rootNavigator: true).pop();
          //AppUtil.removeUntilNavigator(context, const LayoutScreen());
        } else {
          eventId = response['data']['id'];
          pageIndex = 3;
        }
        AppUtil.successToast(context, response['msg']);
        invitation = phones.length;
        names.clear();
        phones.clear();
        contactsCheck.clear();
        HomeCubit.get(context).getEvents();
      } else {
        AppUtil.errorToast(context, response['msg']);
      }
      if (!draft) {
        emit(AddEventLoadedState());
      } else {
        emit(AddDraftEventLoadedState());
      }
    } catch (e) {
      if (!draft) {
        emit(AddEventLoadedState());
      } else {
        emit(AddDraftEventLoadedState());
      }
      return Future.error(e);
    }
  }

  addVisitorsToEvent(id, context, {String from = ""}) async {
    int i = 0;
    for (var element in phones) {
      if (phones[i].contains("+")) {
        phones[i] = element.substring(1);
      }
      i++;
    }
    Map<String, String> formData = {
      "names": jsonEncode(names),
      "phone": jsonEncode(phones),
      "event_id": id.toString(),
      "type": from != "" ? "edit" : ""
    };

    emit(AddVisitorsLoadingState());
    try {
      Map<String, dynamic> response =
      await AddEventRepository.addVisitorsToEvent(formData);
      if (response['status']) {
        AppUtil.successToast(context, response['msg']);
        int number = names.length;
        eventId = id;
        names.clear();
        phones.clear();

        if (from == "") {
            await EventsCubit.get(context).getDraftEvents();
            await EventsCubit.get(context).getActiveEvents();
            await EventsCubit.get(context).getWaitEvents();
        } else {
          await EventsCubit.get(context).getDraftEvents();
        }
      } else {
        AppUtil.errorToast(context, response['msg']);
      }
      emit(AddVisitorsLoadedState());
    } catch (e) {
      emit(AddVisitorsLoadedState());
      // AppUtil.errorToast(context, e.toString());
    }
  }

  var cardNumber = TextEditingController();
  var expiryDate = TextEditingController();
  var cvv = TextEditingController();
  var holderName = TextEditingController();

  pay(context, {type = "add", from = "add", complete = false}) async {
    Map<String, String> formData = {
      "event_id": eventId.toString(),
      "type": type
    };
    emit(PayLoadingState());
    try {
      Map<String, dynamic> response = await AddEventRepository.pay(formData);
      if (response['status']) {
        if (type == "add") {
          if (from == "add") {
            if (complete) {
              AppUtil.removeUntilNavigator(context, const LayoutScreen());
            } else {
              pageIndex = 4;
            }
          } else {
            AppUtil.removeUntilNavigator(context, const LayoutScreen());
          }
          resetEventData();
          EventsCubit.get(context).getDraftEvents();
        } else if (type == "draft") {
          AppUtil.removeUntilNavigator(context, const LayoutScreen());
        } else {
          AppUtil.removeUntilNavigator(context, const LayoutScreen());
        }
        AppUtil.successToast(context, response['msg']);
      } else {
        AppUtil.errorToast(context, response['msg']);
      }
      emit(PayLoadedState());
    } catch (e) {
      emit(PayLoadedState());
      return Future.error(e);
    }
  }

  bool show = true;
  bool iosD = true;
  int wallet = 0;
  showHidePayment() async {
    try {
      Map<String, dynamic> response =
      await AddEventRepository.showHidePayment();
      show = response['status'];
      iosD = response['ios'];
      wallet = response['wallet'];
    } catch (e) {
      return Future.error(e);
    }
  }
}