import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_util.dart';
import '../../../data/guards_repository.dart';
import '../../../models/guards_model.dart';
import 'guards_states.dart';
import 'package:expert_events/event/presentation/controller/events/events_cubit.dart';


class GuardsCubit extends Cubit<GuardsSates>{
  GuardsCubit():super(GuardsInitState());
  static GuardsCubit get(context) => BlocProvider.of(context);


  List<bool> _guardsCheck = [];
  List<bool> guardsCheckTrue = [];
  List<int> selectedGuardsIds = [];

  List<bool> _visitorsCheck = [];
  List<bool> visitorsCheckTrue = [];
  List<int> selectedvisitorsIds = [];

  List<bool> get guardsCheck => _guardsCheck;
  setGuardsCheck(index,bool guardsCheck) {
    _guardsCheck[index] = guardsCheck;
    guardsCheckTrue = _guardsCheck.where((element) => element==true).toList();
    emit(GuardsLoadedState());
  }


  List<bool> get visitorsCheck => _visitorsCheck;
  setvisitorsCheck(index,bool visitorsCheck) {
    _visitorsCheck[index] = visitorsCheck;
    visitorsCheckTrue = _visitorsCheck.where((element) => element==true).toList();
  }

  selectAllGuards(){
    int i = 0;
    for (var _ in _guardsCheck) {
      _guardsCheck[i] = true;
      i++;
    }
    guardsCheckTrue = _guardsCheck;
    emit(GuardsLoadedState());
  }

  unSelectAllGuards(){
    int i = 0;
    for (var _ in _guardsCheck) {
      _guardsCheck[i] = false;
      i++;
    }
    guardsCheckTrue = _guardsCheck.where((element) => element==true).toList();
    emit(GuardsLoadedState());
  }

  GuardsModel? guardsModel;
  Guard? selectedGuard;
  getGuards({String? filter}) async {
    _guardsCheck.clear();
    selectedGuardsIds.clear();
    emit(GuardsLoadingState());
    try{
      Map<String,dynamic> response = await GuardsRepository.getGuards(filter: filter??"");
      guardsModel = GuardsModel.fromJson(response);
      if(guardsModel!.data.isEmpty){
        emit(GuardsEmptyState());
      }else {
        for (var _ in guardsModel!.data) {
          _guardsCheck.add(false);
        }
        emit(GuardsLoadedState());
      }
    }catch(e){
      emit(GuardsErrorState());
      return Future.error(e);
    }
  }


  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var countryCodeController = TextEditingController();

  resetGuardData(){
    nameController.clear();
    phoneController.clear();
    countryCodeController.clear();
  }

  addGuard(context) async {
    Map<String,String> formData = {
      "name": nameController.text,
      "phone": "+${countryCodeController.text}${phoneController.text}",
    };
    emit(AddGuardsLoadingState());
    try{
      Map<String,dynamic> response = await GuardsRepository.addGuard(formData);
      if(response['status']){
        resetGuardData();
        Navigator.of(context,rootNavigator: true).pop();
        getGuards();
        AppUtil.successToast(context, response['msg']);
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(AddGuardsLoadedState());
    }catch(e){
      AppUtil.errorToast(context, e.toString());
      emit(AddGuardsLoadedState());
      return Future.error(e);
    }
  }


  editGuard(context,id,name,phone) async {
    Map<String,String> formData = {
      "name": name,
      "phone": "+$phone",
    };
    emit(AddGuardsLoadingState());
    try{
      Map<String,dynamic> response = await GuardsRepository.editGuard(formData,id);
      if(response['status']){
        Navigator.of(context,rootNavigator: true).pop();
        getGuards();
        AppUtil.successToast(context, response['msg']);
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(AddGuardsLoadedState());
    }catch(e){
      AppUtil.errorToast(context, e.toString());
      emit(AddGuardsLoadedState());
      return Future.error(e);
    }
  }


  deleteGuard(context,id) async {
    try{
      Map<String,dynamic> response = await GuardsRepository.deleteGuard(id);
      if(response['status']){
        Navigator.of(context,rootNavigator: true).pop();
        getGuards();
        AppUtil.successToast(context, response['msg']);
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
    }catch(e){
      AppUtil.errorToast(context, e.toString());
      return Future.error(e);
    }
  }

  addGuardsToEvent(id, context,{String from = ""}) async {
    Map<String, String> formData = {
      "guards": selectedGuardsIds.toString(),
      "event_id": id.toString(),
      "type" : from
    };
    try{
      Map<String,dynamic> response = await GuardsRepository.addGuardToEvent(formData);
      if(response['status']){
        await EventsCubit.get(context).getDraftEvents();
        await EventsCubit.get(context).getActiveEvents();
        await EventsCubit.get(context).getWaitEvents();
        AppUtil.successToast(context, response['msg']);
        _guardsCheck.clear();
        selectedGuardsIds.clear();
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
    }catch(e){
      AppUtil.errorToast(context, e.toString());
      return Future.error(e);
    }
  }

  deleteVisitorsFromEvent(id, context) async {
    Map<String, String> formData = {
      "visitors":  selectedvisitorsIds.toString(),
      "event_id": id.toString(),
    };
    try{
      Map<String,dynamic> response = await GuardsRepository.deleteVisitorsFromEvent(formData);
      if(response['status']){
        await EventsCubit.get(context).getDraftEvents();
        await EventsCubit.get(context).getActiveEvents();
        await EventsCubit.get(context).getWaitEvents();
        AppUtil.successToast(context, response['msg']);
        _visitorsCheck.clear();
        selectedvisitorsIds.clear();
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
    }catch(e){
      AppUtil.errorToast(context, e.toString());
      return Future.error(e);
    }
  }


  List<Contact> contacts = [];
  var contactName = TextEditingController();
  var contactPhone = TextEditingController();
  var contactCountryCode = TextEditingController();
  var searchContact = TextEditingController();

  getContacts({String search = ""}) async {
    contacts.clear();
    // contactsCheck.clear();
    // contactsCheckTrue.clear();
    emit(ContactsGuardLoadingState());
    try {
      contacts = await FlutterContacts.getContacts(
        withThumbnail: false,
        withPhoto: true,
        withProperties: true,
      );
      final filtered = search.isEmpty
          ? contacts
          : contacts.where((c) =>
          c.displayName.toLowerCase().contains(search.toLowerCase())).toList();

      filtered.removeWhere((element) => element.phones == null || element.phones!.isEmpty || element.displayName == null);
      int i = 0;
      for (var _ in filtered) {
        int y = 0;
        for (var element2 in filtered[i].phones!) {
          filtered[i].phones![y].number = element2.number!.replaceAll(" ", "");
          y++;
        }
        i++;
      }
      i = 0;
      for (var element in filtered) {
        filtered[i].phones = [...{...element.phones!}];
        i++;
      }
      if (filtered.isEmpty) {
        emit(ContactsGuardEmptyState());
      } else {
        emit(ContactsGuardLoadedState());
      }
    } catch (e) {
      emit(ContactsGuardErrorState());
      return Future.error(e);
    }
  }
  addContact() async {
    Contact newContact = Contact(
        displayName: contactName.text,
        phones: [Phone("+${contactCountryCode.text}${contactPhone.text}")]
    );
    try {
      await FlutterContacts.insertContact(newContact);
      getContacts();
      emit(ContactsGuardLoadedState());
    } catch (e) {
      emit(ContactsGuardErrorState());
      return Future.error(e);
    }
  }
}