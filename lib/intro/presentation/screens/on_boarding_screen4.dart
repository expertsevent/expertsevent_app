import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../auth/presentation/screens/sign_in_screen.dart';
import '../../../core/app_util.dart';
import '../../../core/cash_helper.dart';
import '../../../core/guest_mode.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../../../layout/presentation/screens/layout_screen.dart';
import '../../../main.dart';
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
          Image.asset(
            "${AppUI.imgPath}splash.png",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: 20.0, vertical: MediaQuery.of(context).padding.top),
            child: CircleAvatar(
              backgroundColor: AppUI.whiteColor,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: AppUI.greyColor,
                  )),
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
                        padding: const EdgeInsets.only(left: 40, right: 50),
                        child: Image.asset(
                          "${AppUI.imgPath}onboarding1_background.png",
                          height: 250,
                        ),
                      ),
                      Image.asset(
                        "${AppUI.imgPath}onboarding4_gif.gif",
                        height: 230,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Card(
                  elevation: 1,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50)),
                  ),
                  color: AppUI.whiteColor,
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(50),
                          topLeft: Radius.circular(50)),
                      color: AppUI.whiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomText(
                            text: "Now you can have a wonderful Event".tr(),
                            fontWeight: FontWeight.w600,
                            fontSize: 26,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          CustomButton(
                            text: "signIn".tr(),
                            onPressed: () {
                              AppUtil.mainNavigator(
                                  context, const SignInScreen());
                            },
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          CustomButton(
                            text: "tutorial".tr(),
                            onPressed: () {
                              AppUtil.mainNavigator(
                                  context, const GuestScreenEn());
                            },
                            borderColor: AppUI.buttonColor,
                            color: AppUI.secondColor,
                            textColor: AppUI.whiteColor,
                          ),
                          const SizedBox(
                            height: 13,
                          ),
                          CustomButton(
                            text: "loginAsGuest".tr(),
                            onPressed: () async {
                              await GuestMode.enter();
                              if (!context.mounted) return;
                              AppUtil.removeUntilNavigator(
                                  context, const LayoutScreen());
                            },
                            borderColor: AppUI.mainColor,
                            color: AppUI.whiteColor,
                            textColor: AppUI.mainColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Image.asset(
            "${AppUI.imgPath}onboarding4_forground.gif",
            height: AppUtil.responsiveHeight(context) * 0.75,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          PositionedDirectional(
            top: MediaQuery.of(context).padding.top,
            end: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  AppUtil.dialog2(context, 'lang'.tr(), [
                    InkWell(
                      onTap: () {
                        context.setLocale(const Locale('en'));
                        CashHelper.setSavedString("lang", "en");
                        Navigator.of(context, rootNavigator: true).pop();
                        AppUtil.removeUntilNavigator(
                            context, const MyApp());
                      },
                      child: const CustomText(text: "English"),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {
                        context.setLocale(const Locale('ar'));
                        CashHelper.setSavedString("lang", "ar");
                        Navigator.of(context, rootNavigator: true).pop();
                        AppUtil.removeUntilNavigator(
                            context, const MyApp());
                      },
                      child: const CustomText(text: "العربية"),
                    ),
                  ]);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.language,
                      size: 35,
                      color: AppUI.mainColor,
                    ),
                    const SizedBox(width: 5),
                    CustomText(
                      text: "lang".tr(),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
