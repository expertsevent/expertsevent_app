import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/add_event/presentation/controller/add_event_cubit.dart';
import 'package:expert_events/auth/presentation/controller/auth/auth_cubit.dart';
import 'package:expert_events/core/cash_helper.dart';
import 'package:expert_events/more/presentation/screens/pages/packages/package_screen.dart';
import 'package:expert_events/more/presentation/screens/pages/profile/edit_profile.dart';
import 'package:expert_events/more/presentation/screens/pages/wallet/wallet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../add_event/presentation/screens/add_event_screen.dart';
import '../../../auth/presentation/controller/auth/auth_states.dart';
import '../../../auth/presentation/screens/mobile_sigin_with_email.dart';
import '../../../core/app_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../../../event/presentation/screens/guards/guards_screen.dart';
import '../../../home/presentation/screens/notification_screen.dart';
import '../../../layout/presentation/controller/bottom_nav_cubit.dart';
import '../../../layout/presentation/screens/layout_screen.dart';
import '../../../main.dart';
import '../controller/more_cubit.dart';
import 'pages/contact_us/contact_us.dart';
import 'pages/dashboard_screen.dart';
import 'pages/profile/profile_screen.dart';
import 'pages/static_page/static_page.dart';
import 'pages/visitors/visitors_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  MoreScreenState createState() => MoreScreenState();
}

class MoreScreenState extends State<MoreScreen> {
  late final bottomNavProvider = BottomNavCubit.get(context);
  late final cubit = MoreCubit.get(context);
  late final authcubit = AuthCubit.get(context);
  late final eventcubit = AddEventCubit.get(context);

  @override
  void initState() {
    super.initState();
    cubit.getUsertype();
    cubit.getUserName();
    authcubit.profile();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
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
              return InkWell(
                onTap: (){
                  AppUtil.mainNavigator(context, const EditProfile());

                },
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: authcubit.profileModel!.data!.photo.toString(),
                      width: 60,
                      height: 60,
                      placeholder: (context, url) => Image.asset("${AppUI.imgPath}avatar.png",width: 72,height: 72,fit: BoxFit.fill,),
                      errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}avatar.png",width: 72,height: 72,fit: BoxFit.fill),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "${authcubit.profileModel!.data!.name}",
                          fontSize: 18,
                          color: AppUI.blackColor,
                        ),
                        Row(
                          children: [
                            CustomText(
                              text: authcubit.profileModel!.data!.package_name!,
                              fontSize: 12,
                              color: AppUI.disableColor,
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                if(authcubit.profileModel!.data!.package_id!.toString() != "0" ) {
                                  AppUtil.dialog2(
                                      context, '(change Plan)'.tr(), [
                                    Column(
                                      children: [
                                        CustomText(
                                          text: '${"You are subscribed to".tr()} ${authcubit.profileModel!.data!.package_name!} ${"You have".tr()} ${eventcubit.wallet} ${"invitations remaining".tr()} ${"Do you want to calculate your value from the new package?".tr()}',
                                          color: AppUI.disableColor,
                                          fontSize: 15,
                                        ),
                                        SizedBox(height: 25,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomButton(width: 120,height: 40,text: "yes".tr(),
                                              onPressed: (){
                                                Navigator.of(context,rootNavigator: true).pop();
                                                AppUtil.mainNavigator(context,
                                                    const PackageScreen(is_Change:true));
                                              },),
                                            SizedBox(width: 10,),
                                            CustomButton(width: 120,height: 40,text: "no".tr(),
                                              onPressed: (){
                                                Navigator.of(context,rootNavigator: true).pop();
                                                AppUtil.mainNavigator(context,
                                                    const PackageScreen());
                                              },textColor: AppUI.mainColor,
                                              borderColor:AppUI.mainColor ,
                                              color: Colors.white,),
                                          ],
                                        )
                                      ],
                                    ),
                                  ]);
                                }else {
                                  AppUtil.mainNavigator(context,
                                      const PackageScreen());
                                }
                              },
                              child: CustomText(
                                text: authcubit.profileModel!.data!.package_id!.toString() != "0" ? '(change Plan)'.tr() : '(${'Packages'.tr()})' ,
                                fontSize: 12,
                                color: AppUI.errorColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () async {
                    BottomNavCubit.get(context).currentIndex = 2;
                    AppUtil.mainNavigator(context, const LayoutScreen());
                  },
                  child: Container(
                    height: 100,
                    width: 300,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppUI.whiteColor,
                          child: SvgPicture.asset("${AppUI.iconPath}home.svg",color: AppUI.blackColor,width: 25,height: 25,),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomText(
                          text: "History".tr(),
                          color: AppUI.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (AddEventCubit.get(context).show)
              Expanded(
                child: InkWell(
                  onTap: () {
                    AppUtil.mainNavigator(context, const WalletScreen());
                  },
                  child: Container(
                    height: 100,
                    width: 300,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppUI.whiteColor,
                          child: SvgPicture.asset("${AppUI.iconPath}wallet.svg",width: 25,height: 25,),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomText(
                          text: "Wallet".tr(),
                          color: AppUI.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (AddEventCubit.get(context).show)
              Expanded(
                child: InkWell(
                  onTap: () {
                    AppUtil.mainNavigator(context, const PackageScreen());
                  },
                  child: Container(
                    height: 100,
                    width: 300,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppUI.whiteColor,
                          child: SvgPicture.asset("${AppUI.iconPath}packages.svg",width: 30,height: 30,color: AppUI.blackColor,),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomText(
                          text: "Packages".tr(),
                          color: AppUI.blackColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 80,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppUtil.mainNavigator(context, const DashboardScreen());
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "${AppUI.iconPath}dashboard.svg",
                          color: AppUI.blackColor,
                          height: 25,
                          width: 25,
                        ),
                        title: CustomText(
                          text: "dashboard".tr(),
                          color: AppUI.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        subtitle: CustomText(
                          text: "Tack details, updates, and attendance in one place".tr(),
                          color: AppUI.blackColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 80,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppUtil.mainNavigator(context, const ProfileScreen());
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "${AppUI.iconPath}user-edit.svg",
                          color: AppUI.blackColor,
                          height: 30,
                          width: 30,
                        ),
                        title: CustomText(
                          text: "settings".tr(),
                          color: AppUI.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        subtitle: CustomText(
                          text: "Update your account details ,change language and delete account".tr(),
                          color: AppUI.blackColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomText(
                    text: "Get More Info".tr(),
                    color: AppUI.blackColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppUtil.mainNavigator(
                            context, const StaticPage(title: "aboutUs"));
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "${AppUI.iconPath}info.svg",
                          color: AppUI.blackColor,
                          height: 20,
                          width: 20,
                        ),
                        title: CustomText(
                          text: "aboutUs".tr(),
                          color: AppUI.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppUtil.mainNavigator(context, const ContactUs()); //Help()
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "${AppUI.iconPath}help.svg",
                          color: AppUI.blackColor,
                          height: 20,
                          width: 20,
                        ),
                        title: CustomText(
                          text: "help".tr(),
                          color: AppUI.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppUtil.mainNavigator(
                            context, const StaticPage(title: "terms"));
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "${AppUI.iconPath}terms.svg",
                          color: AppUI.blackColor,
                          height: 20,
                          width: 20,
                        ),
                        title: CustomText(
                          text: "terms".tr(),
                          color: AppUI.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppUtil.mainNavigator(context, const VisitorsScreen());
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "${AppUI.iconPath}visitors.svg",
                          color: AppUI.blackColor,
                          height: 20,
                          width: 20,
                        ),
                        title: CustomText(
                          text: "visitors".tr(),
                          color: AppUI.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppUtil.mainNavigator(context, const GuardsScreen());
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "${AppUI.iconPath}guards.svg",
                          color: AppUI.blackColor,
                          height: 20,
                          width: 20,
                        ),
                        title: CustomText(
                          text: "guards".tr(),
                          color: AppUI.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        AppUtil.dialog2(
                            context, 'logout'.tr(), [
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30,right: 30),
                                child: Lottie.asset("${AppUI.imgPath}1717510460425.json",width: 100,height: 100),
                              ),
                              CustomText(
                                text: "Do you want to exit the application ?".tr(),
                                color: AppUI.mainColor,
                                fontSize: 15,
                              ),
                              SizedBox(height: 25,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomButton(width: 120,height: 40,text: "yes".tr(),
                                    onPressed: (){
                                      CashHelper.logOut(context);
                                      Navigator.of(context,rootNavigator: true).pop();
                                    },),
                                  SizedBox(width: 10,),
                                  CustomButton(width: 120,height: 40,text: "no".tr(),
                                    onPressed: (){
                                      Navigator.of(context,rootNavigator: true).pop();                                },textColor: AppUI.mainColor,
                                    borderColor:AppUI.mainColor ,
                                    color: Colors.white,),
                                ],
                              )
                            ],
                          ),
                        ]);
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          "${AppUI.iconPath}logout.svg",
                          color: AppUI.blackColor,
                          height: 20,
                          width: 20,
                        ),
                        title: CustomText(
                          text: "logout".tr(),
                          color: AppUI.blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 65,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
