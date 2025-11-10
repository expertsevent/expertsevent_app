import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/app_util.dart';
import '../../../core/cash_helper.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../../../main.dart';
import 'on_boarding_screen2.dart';
class OnBoardingScreen1 extends StatefulWidget {
  const OnBoardingScreen1({Key? key}) : super(key: key);

  @override
  _OnBoardingScreen1State createState() => _OnBoardingScreen1State();
}

class _OnBoardingScreen1State extends State<OnBoardingScreen1> {
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Image.asset("${AppUI.imgPath}onboarding1_background.png"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40,left: 40,right: 40),
                      child: Image.asset("${AppUI.imgPath}onboarding1_gif.gif"),
                    ),
                    Align(alignment: AlignmentDirectional.topCenter,child: Row(
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
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
                      color: AppUI.whiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          CustomText(text: "Welcome to Expert Event App".tr(),fontWeight: FontWeight.w600,fontSize: 26,textAlign: TextAlign.center,),
                          const SizedBox(height: 8,),
                          CustomText(text: "Create Your Event and Send Invitation with just one of best app".tr(),fontSize: 18,color: AppUI.disableColor,textAlign: TextAlign.center,),
                          const SizedBox(height: 30,),
                          CustomButton(text: "next".tr(),onPressed: (){
                            AppUtil.mainNavigator(context, const OnBoardingScreen2());
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
