
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_util.dart';
import '../../../data/auth_repository.dart';
import '../../screens/sign_in_screen.dart';
import 'forget_pass_states.dart';

class ForgetPassCubit extends Cubit<ForgetPassStates>{
  ForgetPassCubit():super(ForgetPassInitState());
  static ForgetPassCubit get(context) => BlocProvider.of(context);
  bool _passVisibility = false;

  var passController = TextEditingController();
  bool get passVisibility => _passVisibility;

  set passVisibility(bool passVisibility) {
    _passVisibility = passVisibility;
    emit(PassChangeVisibility());
  }

  resetPass(context,phone) async {
    emit(ResetPassLoadingState());
    Map<String,String> formData = {
      "phone": phone,
      "password": passController.text,
    };
    try{
      Map<String,dynamic> response = await AuthRepository.resetPass(formData);
      if(response['status']){
        AppUtil.mainNavigator(context, const SignInScreen());
        AppUtil.successToast(context, response['msg']);
      }else{
        AppUtil.errorToast(context, response['msg']);
      }
      emit(ResetPassLoadedState());
    }catch(e){
      emit(ResetPassLoadedState());
      AppUtil.errorToast(context, e.toString());
      return Future.error(e);
    }
  }

}