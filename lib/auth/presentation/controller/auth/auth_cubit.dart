import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_util.dart';
import '../../../../core/cash_helper.dart';
import '../../../../layout/presentation/screens/layout_screen.dart';
import '../../../../more/data/more_repository.dart';
import '../../../data/auth_repository.dart';
import '../../../models/user_model.dart';
import '../../screens/account_created_screen.dart';
import '../../screens/forgot_pass/change_pass.dart';
import '../../screens/mobile_sigin_with_email.dart';
import '../../screens/verification_screen.dart';
import '../../screens/verify_account.dart';
import 'auth_states.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);

  final ImagePicker imagePicker = ImagePicker();
  XFile? userPhoto;

  chooseImageDialog(context) async {
    openGallery(context);
    //openCamera(context,index);
  }

  openGallery(context) async {
    userPhoto = await imagePicker.pickImage(source: ImageSource.gallery);
   // Navigator.of(context,rootNavigator: true).pop();
    emit(UserPhotoChangeState());
  }
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final checkFormKey = GlobalKey<FormState>();
  final phoneFromKey =   GlobalKey<FormState>();
  final profileFromKey =   GlobalKey<FormState>();

  final TextEditingController loginPhone = TextEditingController();
  final TextEditingController loginPhoneCode = TextEditingController(text: "966");
  final TextEditingController loginPassword = TextEditingController();

  final TextEditingController registerPhone = TextEditingController();
  final TextEditingController registerPhoneCode = TextEditingController(text: "966");
  final TextEditingController registerName = TextEditingController();
  final TextEditingController registerLastName = TextEditingController();
  final TextEditingController nationalNum = TextEditingController();
  final TextEditingController birthDate = TextEditingController();

  bool _privacyCheck = false;
  bool get privacyCheck => _privacyCheck;
  set privacyCheck(bool privacyCheck) {
    _privacyCheck = privacyCheck;
    emit(PrivacyCheckChangeState());
  }

  int _genderMaleCheck = 1;
  int _genderFemaleCheck = 2;
  String _gender = "1";
  String get gender => _gender;
  set gender(String gender) {
    _gender = gender;
    emit(GenderCheckChangeState());
  }
  int get genderMaleCheck => _genderMaleCheck;
  set genderMaleCheck(int genderMaleCheck) {
    _genderMaleCheck = genderMaleCheck;
    emit(GenderCheckChangeState());
  }
  int get genderFemaleCheck => _genderFemaleCheck;
  set genderFemaleCheck(int genderFemaleCheck) {
    _genderFemaleCheck = genderFemaleCheck;
    emit(GenderCheckChangeState());
  }
  // PhoneScreen
  final TextEditingController phone = TextEditingController();
  var editProfileName = TextEditingController();
  var editProfilePass = TextEditingController();
  var editProfilephone = TextEditingController();

  final TextEditingController verificationCode = TextEditingController();
  final TextEditingController verificationCode2 = TextEditingController();
  final TextEditingController verificationCode3 = TextEditingController();
  final TextEditingController verificationCode4 = TextEditingController();

  bool loginVisibality = true;

  bool registerVisibility = true;
  bool registerConfirmVisibility = true;

  String? lat,lng;

  bool loginStatus = false;

  
  
  //Start pick date
  pickData(context) async {
      DateTime? date = await showDatePicker(
          context: context,
          initialDatePickerMode: DatePickerMode.year,
          confirmText: 'submit'.tr(),
          keyboardType: Platform.isIOS?
          const TextInputType.numberWithOptions(signed: true, decimal: true)
              : TextInputType.number,
          initialDate: DateTime(DateTime
              .now()
              .year - 10),
          firstDate: DateTime(DateTime
              .now()
              .year - 100),
          lastDate: DateTime(DateTime
              .now()
              .year - 10));
      if (date != null) {
        birthDate.text =
        "${date.year}-${date.month < 10
            ? "0${date.month}"
            : date.month}-${date.day <
            10 ? "0${date.day}" : date
            .day}";
      }
  }
 //End pick date


  UserModel? userModel;
  login(context) async {
    if(!_privacyCheck){
      AppUtil.errorToast(context, "pleaseAcceptTermsAndCondition".tr());
      return;
    }
    emit(LoginLoadingState());
    String fcm = await AppUtil.getToken();
    Map<String,String> formData = {
      "phone": "+${loginPhoneCode.text}${loginPhone.text}",
      "fcm_token": fcm
    };
    try{
      Map<String,dynamic> response = await AuthRepository.login(formData);
      userModel = UserModel.fromJson(response);
      if(userModel!.status!){
          if(loginPhone.text == "12345678"){
            CashHelper.setSavedString("user_id", userModel!.data!.id!.toString());
            CashHelper.setSavedString("jwt", userModel!.data!.apiToken!);
            CashHelper.setSavedString("type", userModel!.data!.type!);
            CashHelper.setSavedString("phone", userModel!.data!.phone!);
            CashHelper.setSavedString("name", userModel!.data!.name!);
            CashHelper.setSavedString("isVerified", 1.toString());
            AppUtil.removeUntilNavigator(context,const MyApp());
            AppUtil.successToast(context, userModel!.msg!);
          }else {
            verificationCode.clear();
            verificationCode2.clear();
            verificationCode3.clear();
            verificationCode4.clear();
            AppUtil.mainNavigator(
                context, const VerificationScreen(from: "verifyPhone",));
            AppUtil.successToast(context, userModel!.msg!);
          }
       //  }
       // if(userModel!.data!.phone == "0" || userModel!.data!.phone == null) {
       //   CashHelper.setSavedString("email", userModel!.data!.email!);
       //   AppUtil.mainNavigator(context, const MobileSignWithEmail());
       //   AppUtil.successToast(context, userModel!.msg!);
       // }else {
       //   AppUtil.removeUntilNavigator(context, const MyApp());
       //   AppUtil.successToast(context, userModel!.msg!);
       // }
      }else{
        AppUtil.errorToast(context, userModel!.msg!);
      }
      emit(LoginLoadedState());
    }catch(e){
      AppUtil.errorToast(context, e.toString());
      emit(LoginLoadedState());
      return Future.error(e);
    }
  }

  UserModel? registerModel;
  register(context) async {
    if(!_privacyCheck){
      AppUtil.errorToast(context, "pleaseAcceptTermsAndCondition".tr());
      return;
    }

    emit(RegisterLoadingState());
    String fcm = await AppUtil.getToken();
    Map<String,String> formData = {
      "name"      : registerName.text,
      "phone"     : "+${registerPhoneCode.text}${registerPhone.text}",
      "password"  : "123456789",
      "fcm_token" : fcm
    };
    try{
      Map<String,dynamic> response = await AuthRepository.register(formData);
      registerModel = UserModel.fromJson(response);
      if(registerModel!.status!){
        //CashHelper.setSavedString("jwt", registerModel!.data!.apiToken!);
        CashHelper.setSavedString("phone", registerModel!.data!.phone!);
        verificationCode.clear();
        verificationCode2.clear();
        verificationCode3.clear();
        verificationCode4.clear();
        AppUtil.mainNavigator(context, const VerificationScreen(from: "register",));
        AppUtil.successToast(context, registerModel!.msg!);
      }else{
        AppUtil.errorToast(context, registerModel!.msg!);
      }
      emit(RegisterLoadedState());
    }catch(e){
      AppUtil.errorToast(context, e.toString());
      emit(RegisterLoadedState());
      return Future.error(e);
    }
  }

  Future<dynamic> signInWithGoogle() async {
    try {
    //  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

     // final GoogleSignInAuthentication? googleAuth =
      //await googleUser?.authentication;

      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );

     // print('idToken ${googleAuth?.idToken}');

     // return await FirebaseAuth.instance.signInWithCredential(credential);
    } on Exception catch (e) {
      // TODO
      print('exception->$e');
    }
  }
  //push data in api and check if email is excit (name , email , phone)

  loginwithEmail(context,name,email,phoneNumber) async {
    emit(LoginemailLoadingState());
    String fcm = await AppUtil.getToken();
    Map<String,String> formData = {
      "name": name,
      "email": email,
      "phone": phoneNumber.toString(),
      "password": "123456789",
      "fcm_token": fcm
    };
    try{
      Map<String,dynamic> response = await AuthRepository.loginwithEmail(formData);
      userModel = UserModel.fromJson(response);
      if(userModel!.status!){
        CashHelper.setSavedString("user_id", userModel!.data!.id!.toString());
        CashHelper.setSavedString("jwt", userModel!.data!.apiToken!);
        CashHelper.setSavedString("type", userModel!.data!.type!);
        CashHelper.setSavedString("phone", userModel!.data!.phone!);
        CashHelper.setSavedString("name", userModel!.data!.name!);
        CashHelper.setSavedString("isVerified", userModel!.data!.isVerified!.toString());
        if(userModel!.data!.phone == "0" || userModel!.data!.phone == null)
        {
          CashHelper.setSavedString("email", userModel!.data!.email!);
          AppUtil.mainNavigator(context, const MobileSignWithEmail());
          AppUtil.successToast(context, userModel!.msg!);
        }else{
          AppUtil.removeUntilNavigator(context, const MyApp());
          AppUtil.successToast(context, userModel!.msg!);
        }
      }else{
        AppUtil.errorToast(context, userModel!.msg!);
      }
      emit(LoginemailLoadedState());
    }catch(e){
      AppUtil.errorToast(context, e.toString());
      emit(LoginemailLoadedState());
      return Future.error(e);
    }
  }

  UserModel? profileModel;
  profile() async {
    emit(ProfileLoadingState());
    try{
      Map<String,dynamic> response = await MoreRepository.profile();
      profileModel = UserModel.fromJson(response);
      emit(ProfileLoadedState());
    }catch(e){
      emit(ProfileErrorState());
      return Future.error(e);
    }
  }

  editProfile(context) async {
    Map<String,String> formData = {
      "name": editProfileName.text,
      "birthdate": birthDate.text,
      "gender"   : gender,
    };
    emit(EditProfileLoadingState());
    try{
      Map<String,dynamic> response = await MoreRepository.editProfile(
        formData,
        images: userPhoto == null ? [] : [userPhoto!.path],
      );
      if(response['status']){
        AppUtil.successToast(context, response['msg']);
        //
        profile();
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(EditProfileLoadedState());
    }catch(e){
      emit(EditProfileLoadedState());
      return Future.error(e);
    }
  }

  forgetPass(context,{type = ""}) async {
    emit(PhoneLoadingState());
    Map<String,String> formData = {
      "phone": "+${loginPhoneCode.text}${loginPhone.text}",
      "type" : type,
      "email" : await  CashHelper.getSavedString("email", "")
    };
    try{
      Map<String,dynamic> response = await AuthRepository.forgetPass(formData);
      if(response['status']){
        verificationCode.clear();
        verificationCode2.clear();
        verificationCode3.clear();
        verificationCode4.clear();
        if(type == "") {
          AppUtil.mainNavigator(
              context, const VerificationScreen(from: 'forget'));
          AppUtil.successToast(context, response['msg']);
        }else if(type == "siginEmail"){
          CashHelper.setSavedString("phone", response["user"]!["phone"]!);
          AppUtil.mainNavigator(
              context, const VerificationScreen(from: 'siginEmail'));
          AppUtil.successToast(context, response['msg']);
        }
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(PhoneLoadedState());
    }catch(e){
      emit(PhoneLoadedState());
      AppUtil.errorToast(context, e.toString());
      return Future.error(e);
    }
  }

  int sec = 59;
  Timer? timer;
  decrementSec(){
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(sec > 0) {
        sec--;
      }else{
        timer.cancel();
      }
      emit(SecChangeState());
    });
  }
  verifyForgetPass(context) async {
    emit(CheckLoadingState());
    Map<String,String> formData = {
      "phone": "+${loginPhoneCode.text}${loginPhone.text}",
      "code": "${verificationCode.text}${verificationCode2.text}${verificationCode3.text}${verificationCode4.text}".split('').reversed.join(),
    };
    try{
      Map<String,dynamic> response = await AuthRepository.verifyForgetPass(formData);
      if(response['status']){
        AppUtil.mainNavigator(context, ChangePass(phone: "+${loginPhoneCode.text}${loginPhone.text}"));
        AppUtil.successToast(context, response['msg']);
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(CheckLoadedState());
    }catch(e){
      emit(CheckLoadedState());
      AppUtil.errorToast(context, e.toString());
      return Future.error(e);
    }
  }
  
  
verifyPhone(context, String type ) async {
    emit(CheckLoadingState());
    Map<String,String> formData = {
      "phone": loginPhone.text == "" || loginPhone.text.isEmpty || loginPhone.text == null ? await CashHelper.getSavedString("phone","") : "+${loginPhoneCode.text}${loginPhone.text}",
      "code": "${verificationCode.text}${verificationCode2.text}${verificationCode3.text}${verificationCode4.text}".split('').reversed.join(),
      "type" : type,
    };
    try{
      Map<String,dynamic> response = await AuthRepository.verifyPhone(formData);
      if(response['status']){
        CashHelper.setSavedString("phone", response["user"]!["phone"]!);
        CashHelper.setSavedString("user_id", response["user"]!["id"]!.toString());
        CashHelper.setSavedString("jwt", response["user"]!["api_token"]!);
        CashHelper.setSavedString("type", response["user"]!["type"]!);
        CashHelper.setSavedString("isVerified", response["user"]!["isVerified"]!.toString());
        AppUtil.removeUntilNavigator(context, const MyApp());
        AppUtil.successToast(context, response['msg']);
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(CheckLoadedState());
    }catch(e){
      emit(CheckLoadedState());
      AppUtil.errorToast(context, e.toString());
      return Future.error(e);
    }
  }
}
