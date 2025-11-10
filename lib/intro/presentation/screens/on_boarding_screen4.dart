import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../auth/presentation/screens/register_screen.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';
import '../../../core/app_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import 'guest/guest_en.dart';
class OnBoardingScreen4 extends StatefulWidget {
  const OnBoardingScreen4({Key? key}) : super(key: key);

  @override
  _OnBoardingScreen4State createState() => _OnBoardingScreen4State();
}

class _OnBoardingScreen4State extends State<OnBoardingScreen4> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40,right: 50),
                        child: Image.asset("${AppUI.imgPath}onboarding1_background.png",height: 250,),
                      ),
                      Image.asset("${AppUI.imgPath}onboarding4_gif.gif",height: 230,),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 1,
                  shape: const RoundedRectangleBorder(
                    borderRadius:  BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
                  ),
                  color: AppUI.whiteColor,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
                      color: AppUI.whiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          CustomText(text: "Now you can have a wonderful Event".tr(),fontWeight: FontWeight.w600,fontSize: 26,textAlign: TextAlign.center,),
                          const SizedBox(height: 25,),
                          CustomButton(text: "signIn".tr(),onPressed: (){
                            AppUtil.mainNavigator(context, const SignInScreen());
                          },),
                          const SizedBox(height: 13,),
                          CustomButton(text: "loginAsGuest".tr(),onPressed: (){
                            AppUtil.mainNavigator(context, const GuestScreenEn());
                          },borderColor: AppUI.buttonColor,color: AppUI.secondColor,textColor: AppUI.whiteColor,),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],),
          Image.asset("${AppUI.imgPath}onboarding4_forground.gif",height: AppUtil.responsiveHeight(context)*0.75,width: double.infinity,fit: BoxFit.fill,),
        ],
      ),
    );
  }
}
