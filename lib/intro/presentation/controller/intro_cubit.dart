
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/models/user_model.dart';
import '../../../auth/presentation/screens/mobile_sigin_with_email.dart';
import '../../../auth/presentation/screens/verification_screen.dart';
import '../../../core/app_util.dart';
import '../../../core/cash_helper.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../../../home/data/home_repository.dart';
import '../../../layout/presentation/screens/layout_screen.dart';
import '../screens/on_boarding_scree3.dart';
import '../screens/on_boarding_screen1.dart';
import 'intro_states.dart';
import 'package:flutter/cupertino.dart';

class IntroCubit extends Cubit<IntroStates>{
  IntroCubit(): super(IntroInitState());
  static IntroCubit get(context) => BlocProvider.of(context);

  navigateToNextScreen(context) async {
    try{
      String jwt = await CashHelper.getSavedString("jwt", "");
      String phone = await CashHelper.getSavedString("phone","");
      String isVerified = await CashHelper.getSavedString("isVerified","");
      print("phone in intro page ${phone}");

      Future.delayed(const Duration(seconds: 3),(){
        if( jwt != "") {
          if(isVerified == "0" && phone != "+96612345678") {
            AppUtil.mainNavigator(context, const VerificationScreen(from: "verifyPhone",));
            AppUtil.successToast(context, "verify Your Number");
          }else{
            sendToken();
            AppUtil.removeUntilNavigator(context,const LayoutScreen());
          }
        }else {
          sendToken();
          AppUtil.removeUntilNavigator(context, const OnBoardingScreen1());
        }
      });
    } catch (e) {
      AppUtil.errorToast(context, e.toString());
      CashHelper.logOut(context);
    }
  }

  showAlertDialogAd(BuildContext context , text , photo){
    AppUtil.dialog2(context, "Promotion".tr(), [
      Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30,right: 30),
            child: CachedNetworkImage(
              imageUrl: photo.toString(),
              width: 200,
              height: 200,
              fit: BoxFit.fill,
            ),
          ),
          CustomText(
            text: text,
            color: AppUI.mainColor,
            fontSize: 15,
          ),
          SizedBox(height: 25,),
          CustomButton(width: 120,height: 40,text: "close".tr(),
            onPressed: () async {
              await CashHelper.setSavedString("ad_id", "");
              Navigator.of(context,rootNavigator: true).pop();
            },
            textColor: AppUI.mainColor,
            borderColor: AppUI.mainColor,
            color: Colors.white,
          ),
        ],
      )
    ]);

  }


  sendToken() async {
    String? deviceId = await AppUtil.getId();
    String deviceToken = await AppUtil.getToken();
    Map<String,String> formData = {
      "device_id": deviceId??"",
      "device_token": deviceToken
    };
    print('FCM TOKEN GUEST : $deviceToken');
    await HomeRepository.sendToken(formData);
  }

  int step = 1;

  increasePageStep() async {
    step =  step + 1;
    emit(GuestPageChangeState());
  }



}