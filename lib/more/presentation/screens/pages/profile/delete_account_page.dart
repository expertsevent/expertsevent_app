import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/main.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../../core/app_util.dart';
import '../../../../../core/cash_helper.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({Key? key}) : super(key: key);

  @override
  _DeleteAccountPageState createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 140.0,vertical: MediaQuery.of(context).padding.top),
            child:  CustomText(text: "تم حذف الحساب",fontSize: 15,fontWeight: FontWeight.bold,color: AppUI.mainColor,),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40,right: 40),
                child: Lottie.asset("${AppUI.imgPath}1716992810172.json"),
              ),
              SizedBox(height: 80,),
              const CustomText(text: "موجودين وفي انتظار عودتكم في أقرب وقت",fontSize: 15,color: AppUI.mainColor,),
              SizedBox(height: 80,),
              CustomButton(text: "موافق",
                onPressed: (){
                  AppUtil.mainNavigator(context, const MyApp());
                  CashHelper.logOut(context);
                },),
              //description
            ],)
        ],
      ),
    );
  }
}
