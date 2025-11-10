import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_util.dart';
import '../../../core/cash_helper.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../controller/auth/auth_cubit.dart';
import '../controller/auth/auth_states.dart';
import 'account_created_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String from;
  const VerificationScreen({Key? key,required this.from}) : super(key: key);

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final AuthCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = AuthCubit.get(context);
    cubit.sec = 59;
    cubit.decrementSec();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customAppBar(title: "verificationCode".tr(),backgroundColor: Colors.transparent),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomCard(
                      height: 220,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            CustomText(text: "codeSentToEmail".tr(),color: AppUI.blackColor,textAlign: TextAlign.center,),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Directionality(
                                textDirection: ui.TextDirection.ltr, // set this propert
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: CustomInput(controller: cubit.verificationCode4, hint: "",maxLength: 1,inputFormatters:  <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ], textInputType: TextInputType.number,radius: 13.0,textAlign: TextAlign.center,autofocus: true,onChange: (value){
                                        if(value.length==1){
                                          FocusScope.of(context).nextFocus();
                                        }
                                        setState(() {});
                                      },),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: CustomInput(controller: cubit.verificationCode3, hint: "",maxLength: 1,inputFormatters:  <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ], textInputType: TextInputType.number,radius: 13.0,textAlign: TextAlign.center,autofocus: true,onChange: (value){
                                        if(value.length==1){
                                          FocusScope.of(context).nextFocus();
                                        }
                                        setState(() {});
                                      },),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: CustomInput(controller: cubit.verificationCode2, hint: "",maxLength: 1,inputFormatters:  <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ], textInputType: TextInputType.number,radius: 13.0,textAlign: TextAlign.center,autofocus: true,onChange: (value){
                                        if(value.length==1){
                                          FocusScope.of(context).nextFocus();
                                        }
                                        setState(() {});
                                
                                      },),
                                    ),
                                    SizedBox(
                                      width: 50,
                                      child: CustomInput(controller: cubit.verificationCode, hint: "",maxLength: 1,inputFormatters:  <TextInputFormatter>[
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ], textInputType: TextInputType.number,radius: 13.0,textAlign: TextAlign.center,autofocus: true,onChange: (value){
                                        if(value.length==1){
                                          FocusScope.of(context).unfocus();
                                          if(widget.from == "forget"){
                                            cubit.verifyForgetPass(context);
                                          }else{
                                            cubit.verifyPhone(context,widget.from);
                                          }
                                        }
                                        setState(() {});
                                      },),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(text: "didntReceiveCode".tr(),color: AppUI.blackColor,fontSize: 16,),
                                BlocBuilder<AuthCubit,AuthState>(
                                    buildWhen: (_,state) => state is SecChangeState,
                                    builder: (context, state) {
                                      return InkWell(
                                        onTap: (){
                                          if(cubit.sec == 0) {
                                            cubit.sec = 59;
                                            cubit.decrementSec();
                                            cubit.forgetPass(
                                                context, type: "resend");
                                          }
                                        },
                                        child: CustomText(text: "resendOTP".tr(),fontSize: 16,fontWeight: FontWeight.bold,color: cubit.sec == 0?AppUI.mainColor:AppUI.disableColor,));
                                  }
                                )
                              ],
                            ),
                            BlocBuilder<AuthCubit,AuthState>(
                              buildWhen: (_,state) => state is SecChangeState,
                              builder: (context, state) {
                                return CustomText(text: "0:${cubit.sec>10?cubit.sec:"0${cubit.sec}"} ${"secLeft".tr()}".tr(),fontSize: 16,fontWeight: FontWeight.bold,color: AppUI.errorColor,);
                              }
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30,),
                    BlocBuilder<AuthCubit,AuthState>(
                        buildWhen: (_,state) => state is CheckLoadingState || state is CheckLoadedState,
                        builder: (context, state) {
                          if(state is CheckLoadingState){
                            return const LoadingWidget();
                          }
                          return CustomButton(text: "verify".tr(),onPressed: () {
                          if(widget.from == "forget"){
                            cubit.verifyForgetPass(context);
                          }else{
                            cubit.verifyPhone(context,widget.from);
                          }
                        },);
                      }
                    )
                  ],
                ),
              ),
              const SizedBox()
            ],
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    cubit.timer!.cancel();
    super.dispose();
  }
}
