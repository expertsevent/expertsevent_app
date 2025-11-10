import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/auth/presentation/controller/auth/auth_cubit.dart';
import 'package:expert_events/auth/presentation/controller/auth/auth_states.dart';
import 'package:expert_events/more/presentation/controller/more_cubit.dart';
import 'package:expert_events/more/presentation/controller/more_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../../../auth/presentation/screens/forgot_pass/change_pass.dart';
import '../../../../../core/app_util.dart';
import '../../../../../core/cash_helper.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import '../../../../../main.dart';
import '../../scan_qr.dart';
import 'delete_account_page.dart';
import 'edit_profile.dart';
import 'dart:ui' as ui;


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cubit = AuthCubit.get(context);
    final morecubit = MoreCubit.get(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "${AppUI.imgPath}splash.png",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (_, state) =>
                  state is ProfileLoadingState ||
                  state is ProfileLoadedState ||
                  state is ProfileErrorState,
              builder: (context, state) {
                if (state is ProfileLoadingState) {
                  return const LoadingWidget();
                }
                if (state is ProfileErrorState) {
                  return const ErrorFetchWidget();
                }
                cubit.editProfileName.text = cubit.profileModel!.data!.name!;
                cubit.editProfilephone.text = cubit.profileModel!.data!.phone!;
                return Column(
                  children: [
                    Container(
                      height: AppUtil.responsiveHeight(context) * 0.32,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40)),
                          color: AppUI.whiteColor),
                      child: Column(
                        children: [
                          customAppBar(title: ""),
                          CachedNetworkImage(
                            imageUrl: cubit.profileModel!.data!.photo.toString(),
                            width: 50,
                            height: 50,
                            placeholder: (context, url) => Image.asset("${AppUI.imgPath}avatar.png",width: 72,height: 72,fit: BoxFit.fill,),
                            errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}avatar.png",width: 72,height: 72,fit: BoxFit.fill),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomText(
                            text: cubit.editProfileName.text,
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: AppUI.blackColor,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(cubit.editProfilephone.text,
                            style : const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppUI.blackColor,
                            ),
                            textDirection:
                            ui.TextDirection.ltr,
                          ),

                          const Spacer(),
                          // Padding(
                          //   padding: const EdgeInsets.all(25.0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //     children: [
                          //       Column(
                          //         children: [
                          //           const CustomText(text: "5",fontSize: 20,fontWeight: FontWeight.bold,color: AppUI.blackColor),
                          //           CustomText(text: "allEvents".tr(),fontSize: 13,color: AppUI.disableColor,)
                          //         ],
                          //       ),
                          //       Column(
                          //         children: [
                          //           const CustomText(text: "2",fontSize: 20,fontWeight: FontWeight.bold,color: AppUI.blackColor),
                          //           CustomText(text: "privateEvents".tr(),fontSize: 13,color: AppUI.disableColor,)
                          //         ],
                          //       ),
                          //       Column(
                          //         children: [
                          //           const CustomText(text: "10",fontSize: 20,fontWeight: FontWeight.bold,color: AppUI.blackColor),
                          //           CustomText(text: "guards".tr(),fontSize: 13,color: AppUI.disableColor,)
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: AppUI.whiteColor),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30)),
                                color: AppUI.buttonColor),
                            child: CustomText(
                              text: "profile".tr(),
                              color: AppUI.whiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                //       InkWell(
                                //         onTap: (){
                                //           AppUtil.mainNavigator(context, const ChangePass(phone: '',));
                                //         },
                                //         child: Row(
                                //           children: [
                                //             SvgPicture.asset("${AppUI.iconPath}lock.svg"),
                                //             const SizedBox(width: 10,),
                                //             CustomText(text: "changePass".tr(),fontSize: 16,fontWeight: FontWeight.w600,color: AppUI.bottomBarColor,),
                                //             const Spacer(),
                                //             const Icon(Icons.arrow_forward_ios,size: 18,)
                                //           ],
                                //         ),
                                //       ),
                                //       const SizedBox(height: 20,),
                                InkWell(
                                  onTap: () {
                                    AppUtil.mainNavigator(
                                        context, const EditProfile());
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "${AppUI.iconPath}person.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        text: "editProfile".tr(),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppUI.bottomBarColor,
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    AppUtil.dialog2(context, 'lang'.tr(), [
                                      InkWell(
                                          onTap: () {
                                            context
                                                .setLocale(const Locale('en'));
                                            CashHelper.setSavedString(
                                                "lang", "en");
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            AppUtil.removeUntilNavigator(
                                                context, const MyApp());
                                          },
                                          child: const CustomText(
                                              text: "English")),
                                      const Divider(),
                                      InkWell(
                                          onTap: () {
                                            context
                                                .setLocale(const Locale('ar'));
                                            CashHelper.setSavedString(
                                                "lang", "ar");
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                            AppUtil.removeUntilNavigator(
                                                context, const MyApp());
                                          },
                                          child: const CustomText(
                                              text: "العربية")),
                                    ]);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "${AppUI.iconPath}lang.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        text: "lang".tr(),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppUI.bottomBarColor,
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                                // const SizedBox(height: 20,),
                                // InkWell(
                                //   onTap: (){
                                //     CashHelper.logOut(context);
                                //   },
                                //   child: Row(
                                //     children: [
                                //       SvgPicture.asset("${AppUI.iconPath}logout.svg"),
                                //       const SizedBox(width: 10,),
                                //       CustomText(text: "logout".tr(),fontSize: 16,fontWeight: FontWeight.w600,color: AppUI.bottomBarColor,),
                                //       const Spacer(),
                                //       const Icon(Icons.arrow_forward_ios,size: 18,)
                                //     ],
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                  onTap: () {
                                    showAlertDialog(context, morecubit);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          "${AppUI.iconPath}logout.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      CustomText(
                                        text: "deleteAccount".tr(),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: AppUI.bottomBarColor,
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                      )
                                    ],
                                  ),
                                ),
                                if (morecubit.userType == "gurad")
                                  const SizedBox(
                                    height: 20,
                                  ),
                                if (morecubit.userType == "gurad")
                                  InkWell(
                                    onTap: () async {
                                      Barcode result =
                                          await AppUtil.mainNavigator(
                                              context, const ScanQr());
                                      if (result.code == null) {
                                        AppUtil.errorToast(context,
                                            'حدث خطأ ما حاول مرة أخرى');
                                        return;
                                      }
                                      morecubit.scanQr(result.code!, context);
                                    },
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "${AppUI.iconPath}qr.svg",
                                          color: AppUI.blackColor,
                                          width: 20,
                                          height: 20,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        CustomText(
                                          text: "scanQr".tr(),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: AppUI.bottomBarColor,
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, MoreCubit moreCubit) {
    AppUtil.dialog2(
        context, 'حذف الحساب', [
      BlocBuilder<MoreCubit,MoreStates>(
          buildWhen: (_,state) => state is deleteCheckChangeState,
          builder: (context, state) {
          return Column(
            children: [
              CustomText(
                text: "هل تريد حذف الحساب ؟",
                color: AppUI.greyColor,
                fontSize: 15,
              ),
              SizedBox(height: 15,),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                ),
                child:  Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        moreCubit.deleteCheck = true;
                        moreCubit.emit(deleteCheckChangeState());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                          vertical: 8
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: moreCubit.deleteCheck ? AppUI.mainColor : Colors.transparent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Image.asset("${AppUI.imgPath}sad.png"),
                            CustomText(
                                text: 'yes'.tr(),
                              color: AppUI.errorColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        moreCubit.deleteCheck = false;
                        moreCubit.emit(deleteCheckChangeState());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: moreCubit.deleteCheck ? Colors.transparent : AppUI.mainColor),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          children: [
                            Image.asset("${AppUI.imgPath}happy.png"),
                            CustomText(
                              text: 'no'.tr(),
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 80,),
                  ],
                ),
              ),
              if(moreCubit.deleteCheck)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "يهمنا نعرف السبب",
                      color: AppUI.mainColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        moreCubit.deleteCheckbox1 = 1;
                        moreCubit.deleteCheckbox2 = 0;
                        moreCubit.deleteCheckbox3 = 0;
                        moreCubit.deleteCheckbox4 = 0;
                        moreCubit.checkboxData = "لم أعد بحاجة للتطبيق";
                      },
                      child: Row(
                        children: [
                          BlocBuilder<MoreCubit,MoreStates>(
                              buildWhen: (_,state) => state is deleteCheckboxChangeState,
                              builder: (context, state) {
                                return SizedBox(
                                  height: 20,width: 23,
                                  child: Radio(value:  moreCubit.deleteCheckbox1,groupValue: 1, onChanged: (v){
                                    moreCubit.deleteCheckbox1 = 1;
                                    moreCubit.deleteCheckbox2 = 0;
                                    moreCubit.deleteCheckbox3 = 0;
                                    moreCubit.deleteCheckbox4 = 0;
                                    moreCubit.checkboxData = "لم أعد بحاجة للتطبيق";
                                  }),
                                );
                              }
                          ),
                          const SizedBox(width: 15,),
                          CustomText(text: "لم أعد بحاجة للتطبيق" ,color: AppUI.greyColor,fontSize: 16,textAlign: TextAlign.center,)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        moreCubit.deleteCheckbox1 = 0;
                        moreCubit.deleteCheckbox2 = 1;
                        moreCubit.deleteCheckbox3 = 0;
                        moreCubit.deleteCheckbox4 = 0;
                        moreCubit.checkboxData = "هناك مشكلة لم يتم حلها";
                      },
                      child: Row(
                        children: [
                          BlocBuilder<MoreCubit,MoreStates>(
                              buildWhen: (_,state) => state is deleteCheckboxChangeState,
                              builder: (context, state) {
                                return SizedBox(
                                  height: 20,width: 23,
                                  child: Radio(value:  moreCubit.deleteCheckbox2,groupValue: 1, onChanged: (v){
                                    moreCubit.deleteCheckbox1 = 0;
                                    moreCubit.deleteCheckbox2 = 1;
                                    moreCubit.deleteCheckbox3 = 0;
                                    moreCubit.deleteCheckbox4 = 0;
                                     moreCubit.checkboxData = "هناك مشكلة لم يتم حلها";
                                  }),
                                );
                              }
                          ),
                          const SizedBox(width: 15,),
                          CustomText(text: "هناك مشكلة لم يتم حلها" ,color: AppUI.greyColor,fontSize: 16,textAlign: TextAlign.center,)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        moreCubit.deleteCheckbox1 = 0;
                        moreCubit.deleteCheckbox2 = 0;
                        moreCubit.deleteCheckbox3 = 1;
                        moreCubit.deleteCheckbox4 = 0;
                        moreCubit.checkboxData = "صعب الاستخدام";
                      },
                      child: Row(
                        children: [
                          BlocBuilder<MoreCubit,MoreStates>(
                              buildWhen: (_,state) => state is deleteCheckboxChangeState,
                              builder: (context, state) {
                                return SizedBox(
                                  height: 20,width: 23,
                                  child: Radio(value:  moreCubit.deleteCheckbox3,groupValue: 1, onChanged: (v){
                                    moreCubit.deleteCheckbox1 = 0;
                                    moreCubit.deleteCheckbox2 = 0;
                                    moreCubit.deleteCheckbox3 = 1;
                                    moreCubit.deleteCheckbox4 = 0;
                                    moreCubit.checkboxData = "صعب الاستخدام";
                                  }),
                                );
                              }
                          ),
                          const SizedBox(width: 15,),
                          CustomText(text: "صعب الاستخدام" ,color: AppUI.greyColor,fontSize: 16,textAlign: TextAlign.center,)
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        moreCubit.deleteCheckbox1 = 0;
                        moreCubit.deleteCheckbox2 = 0;
                        moreCubit.deleteCheckbox3 = 0;
                        moreCubit.deleteCheckbox4 = 1;
                        moreCubit.checkboxData = "أخري";
                      },
                      child: Row(
                        children: [
                          BlocBuilder<MoreCubit,MoreStates>(
                              buildWhen: (_,state) => state is deleteCheckboxChangeState,
                              builder: (context, state) {
                                return SizedBox(
                                  height: 20,width: 23,
                                  child: Radio(value:  moreCubit.deleteCheckbox4,groupValue: 1, onChanged: (v){
                                    moreCubit.deleteCheckbox1 = 0;
                                    moreCubit.deleteCheckbox2 = 0;
                                    moreCubit.deleteCheckbox3 = 0;
                                    moreCubit.deleteCheckbox4 = 1;
                                    moreCubit.checkboxData = "أخري";
                                  }),
                                );
                              }
                          ),
                          const SizedBox(width: 15,),
                          CustomText(text: "أخري" ,color: AppUI.greyColor,fontSize: 16,textAlign: TextAlign.center,)
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    CustomInput(controller: moreCubit.inputReasonDelete,hint: "اكتب لنا", textInputType: TextInputType.name,maxLines: 2,radius: 10,),
                  ],
                ),
              ),
              CustomButton(width: 120,height: 40,text: "send".tr(),
                onPressed: (){
                  if(moreCubit.deleteCheck == false){
                    Navigator.of(context,rootNavigator: true).pop();
                    return ;
                  }
                  moreCubit.deleteAccount(context);
                  //CashHelper.logOut(context);
                },),
            ],
          );
        }
      ),
    ]);


  }
}
