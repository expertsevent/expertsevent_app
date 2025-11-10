import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../auth/presentation/screens/register_screen.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';
import '../../../core/app_util.dart';
import '../../../core/cash_helper.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../../../main.dart';
import 'on_boarding_screen4.dart';
class OnBoardingScreen3 extends StatefulWidget {
  const OnBoardingScreen3({Key? key}) : super(key: key);

  @override
  _OnBoardingScreen3State createState() => _OnBoardingScreen3State();
}

class _OnBoardingScreen3State extends State<OnBoardingScreen3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: MediaQuery.of(context).padding.top),
            child: CircleAvatar(
              backgroundColor: AppUI.whiteColor,
              child: IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back,color: AppUI.greyColor,)),
            ),
          ),
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
                        padding: const EdgeInsets.only(right: 40,left: 40,bottom: 30),
                        child: Image.asset("${AppUI.imgPath}onboarding1_background.png"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 40,right: 40),
                        child: Lottie.asset("${AppUI.imgPath}lf30.json"),
                      ),
                      Align(alignment: AlignmentDirectional.topEnd,child: Row(
                        children: [
                          const SizedBox(),
                          const Spacer(),
                          Padding(
                            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 10,right: 10),
                            child: InkWell(onTap: (){
                              AppUtil.dialog2(context, 'lang'.tr(), [
                                InkWell(
                                    onTap: (){
                                      context.setLocale(const Locale('en'));
                                      CashHelper.setSavedString("lang", "en");
                                      Navigator.of(context,rootNavigator: true).pop();
                                      AppUtil.removeUntilNavigator(context, const MyApp());
                                    },
                                    child: const CustomText(text: "English")),
                                const Divider(),
                                InkWell(
                                    onTap: (){
                                      context.setLocale(const Locale('ar'));
                                      CashHelper.setSavedString("lang", "ar");
                                      Navigator.of(context,rootNavigator: true).pop();
                                      AppUtil.removeUntilNavigator(context, const MyApp());
                                    },
                                    child: const CustomText(text: "العربية")),

                              ]);
                            },child: Row(
                              children: [
                                const Icon(Icons.language,size: 35,color: AppUI.mainColor,),
                                const SizedBox(width: 5,),
                                CustomText(text: "lang".tr(),fontSize: 18,fontWeight: FontWeight.bold,)
                              ],
                            )),
                          ),
                        ],
                      )),
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
                          CustomText(text: "Send invites choose design and pay".tr(),fontWeight: FontWeight.w600,fontSize: 26,textAlign: TextAlign.center,),
                          const SizedBox(height: 30,),
                          CustomButton(text: "next".tr(),onPressed: (){
                            AppUtil.removeUntilNavigator(context, const OnBoardingScreen4());
                          },)
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],)
        ],
      ),
    );
  }
}
