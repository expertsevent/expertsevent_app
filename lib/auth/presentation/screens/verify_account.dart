import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/auth/presentation/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/app_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({Key? key}) : super(key: key);

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset("${AppUI.iconPath}success.svg"),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomCard(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        CustomText(text: "accountVerified".tr(),fontSize: 22,fontWeight: FontWeight.bold,),
                        const SizedBox(height: 20,),
                        CustomText(text: "Your account had been verified successfully.".tr(),fontSize: 16,color: AppUI.disableColor,textAlign: TextAlign.center,),
                        const SizedBox(height: 5,),
                        CustomText(text: "Please sign in to use your account and enjoy".tr(),fontSize: 16,color: AppUI.disableColor,textAlign: TextAlign.center,),
                        const SizedBox(height: 20,),
                        CustomButton(text: "signIn".tr(),onPressed: (){
                          AppUtil.mainNavigator(context, const SignInScreen());
                        },)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
