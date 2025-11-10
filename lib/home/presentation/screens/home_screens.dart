import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../add_event/presentation/controller/add_event_cubit.dart';
import '../../../add_event/presentation/controller/add_event_states.dart';
import '../../../add_event/presentation/screens/add_event_screen.dart';
import '../../../core/app_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../../../layout/presentation/controller/bottom_nav_cubit.dart';
import '../../../more/presentation/screens/pages/packages/package_screen.dart';
import '../../../more/presentation/screens/pages/profile/edit_profile.dart';
import '../controller/home_cubit.dart';
import '../controller/home_states.dart';
import 'notification_screen.dart';
import 'package:expert_events/auth/presentation/controller/auth/auth_cubit.dart';
import 'package:expert_events/auth/presentation/controller/auth/auth_states.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:math';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final cubit = HomeCubit.get(context);
  late final authcubit = AuthCubit.get(context);
  late final eventcubit = AddEventCubit.get(context);
  var templateIds = [1,2,3,4,5];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.getEvents();
    cubit.getInvitations();
    cubit.showHideAds();
    authcubit.profile();
    if (templateIds.isNotEmpty) {
      int randomIndex = Random().nextInt(templateIds.length - 1);
      print('templateIds: $templateIds');
      print('randomIndex: $randomIndex');
      eventcubit.eventSubTypes(context, templateIds[randomIndex]);
    }

    BottomNavCubit.get(context).showPopUpdate(context);

  }
  late List<String> icons = ['add_guard.png','add_guest.png','change_date.png','change_location.png','delete_event.png','edit_event.png','share_event.png'];
  late List<String> names = ['Add Guard'.tr(),'Add Guest'.tr(),'Change Date'.tr(),'Change Location'.tr(),'Delete Event'.tr(),'Edit Event'.tr(),'Share Event'.tr()];

  late List<String> banners = ['banner_1.jpg','banner_2.jpg','banner_3.jpg'];

  @override
  Widget build(BuildContext context) {
    print("photo is a aaaa :${cubit.photoAd}");

    if(cubit.showAd){
      Future.delayed(Duration.zero, () async =>
          AppUtil.dialog2(context, "Promotion".tr(), [
            Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: CachedNetworkImage(
                  imageUrl: cubit.photoAd,
                  height: 220,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 10,),
              CustomText(
                text: cubit.textAd,
                color: AppUI.mainColor,
                fontSize: 15,
              ),
              const SizedBox(height: 25,),
              CustomButton(width: 120,
                height: 40,
                text: "close".tr(),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                textColor: AppUI.mainColor,
                borderColor: AppUI.mainColor,
                color: Colors.white,
              ),
            ],
          )
        ]),);
    }
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top,),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
            child: Row(
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
                    return Row(
                      children: [
                        InkWell(
                          onTap: (){
                            AppUtil.mainNavigator(context, const EditProfile());
                          },
                          child: CachedNetworkImage(
                            imageUrl: authcubit.profileModel!.data!.photo.toString(),
                            width: 50,
                            height: 50,
                            placeholder: (context, url) => Image.asset("${AppUI.imgPath}avatar.png",width: 40,height: 40,fit: BoxFit.fill,),
                            errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}avatar.png",width: 40,height: 40,fit: BoxFit.fill),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: "${authcubit.profileModel!.data!.name}",
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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
                    );
                  }
                ),
                const Spacer(),
                InkWell(
                  onTap: (){
                    AppUtil.mainNavigator(context, const NotificationScreen());
                  },
                  child: CircleAvatar(
                    backgroundColor: AppUI.whiteColor,
                    child: SvgPicture.asset("${AppUI.iconPath}more_noti.svg"),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
            child: CustomText(
              text: "Discover Amazing Events".tr(),
              color: AppUI.blackColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15,),
          CarouselSlider(
            options: CarouselOptions(
              height: 175,
              aspectRatio: 16/9,
              viewportFraction: 0.95,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
            ),
            items: banners.map((i) => Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: "",
                    width: double.infinity,
                    height: 160,
                    placeholder: (context, url) => Image.asset("${AppUI.imgPath}${i.toString()}",width: double.infinity,height: 192,fit: BoxFit.fill,),
                    errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}${i.toString()}",width: double.infinity,height: 192,fit: BoxFit.fill),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: const Color(0xff606060).withOpacity(0.4),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(text: "Create Your Event and Send Invitation with just one of best app".tr(),fontWeight: FontWeight.bold,color: AppUI.whiteColor,fontSize: 25,),
                      const SizedBox(height: 10,),
                      CustomButton(text: "Create your event now".tr(),color: AppUI.buttonColor,textColor: AppUI.whiteColor,width: 190,
                        onPressed: (){
                          AppUtil.mainNavigator(context, const AddEventsScreen());
                        },),
                    ],
                  ),
                ),
              ],
            ),
            ).toList(),
          ),
          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 16,right: 16),
            child: CustomButton(text: "Create your event now".tr(),color: AppUI.secondColor,textColor: AppUI.whiteColor,width: double.infinity,
              onPressed: (){
                AppUtil.mainNavigator(context, const AddEventsScreen());
              },),
          ),
          const SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomText(text: "Our Features".tr(),fontSize: 18,fontWeight: FontWeight.bold,color: AppUI.blackColor,),
          ),
          const SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: SizedBox(
              height: 100,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: List.generate(icons.length, (index) {
                  return Row(
                    children: [
                      SizedBox(
                        width: AppUtil.responsiveWidth(context)*0.268,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Container(
                            height: 90,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment : MainAxisAlignment.center,
                              crossAxisAlignment : CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                "${AppUI.imgPath}${icons[index]}",
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.fill,
                                ),
                                Stack(
                                  alignment: AppUtil.rtlDirection(context)
                                      ? Alignment.topLeft
                                      : Alignment.topRight,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: Text(
                                        names[index],
                                        style: const TextStyle(
                                          color: AppUI.mainColor,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                ),
              ),
            ),
          ),
          const SizedBox(height: 5,),
          InkWell(
            onTap: (){
              BottomNavCubit.get(context).setCurrentIndex(2);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CustomText(text: "myLatestEvents".tr(),fontSize: 18,fontWeight: FontWeight.bold,color: AppUI.blackColor,),
                  const Spacer(),
                  CustomText(text: "${"viewAll".tr()} +",fontWeight: FontWeight.bold,color: AppUI.secondColor),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,),
          SizedBox(
            height: 305,
            child: BlocBuilder<HomeCubit,HomeStates>(
              buildWhen: (_,state) => state is EventsLoadingState || state is EventsLoadedState || state is EventsEmptyState || state is EventsErrorState,
              builder: (context, state) {
                if(state is EventsLoadingState || cubit.eventsModel==null){
                  return const LoadingWidget();
                }
                if(state is EventsEmptyState){
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("${AppUI.imgPath}logo.png",width: 100,height: 100,fit: BoxFit.fill,),
                      EmptyWidget(text: "Here you will find your created events".tr(),),
                    ],
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(cubit.eventsModel!.data.length, (index) {
                    return Row(
                      children: [
                        SizedBox(
                            width: AppUtil.responsiveWidth(context)*0.85,
                            child: EventCard(event: cubit.eventsModel!.data[index], type: cubit.eventsModel!.data[index].eventStatus.tr(),)),
                        const SizedBox(width: 20,)
                      ],
                    );
                  }),
                );
              }
            ),
          ),
          const SizedBox(height: 38,),
          InkWell(
            onTap: (){
              BottomNavCubit.get(context).setCurrentIndex(1);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CustomText(text: "invitations".tr(),fontSize: 18,fontWeight: FontWeight.bold,color: AppUI.blackColor,),
                  const Spacer(),
                  CustomText(text: "${"viewAll".tr()} +",fontWeight: FontWeight.bold,color: AppUI.secondColor,),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15,),
          SizedBox(
            height: 133,
            child: BlocBuilder<HomeCubit,HomeStates>(
                buildWhen: (_,state) => state is InvitationsLoadingState || state is InvitationsLoadedState || state is InvitationsEmptyState || state is InvitationsErrorState ,
                builder: (context, state) {
                  if(state is InvitationsLoadingState){
                    return const LoadingWidget();
                  }
                  if(state is InvitationsEmptyState){
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("${AppUI.imgPath}logo.png",width: 100,height: 100,fit: BoxFit.fill,),
                        EmptyWidget(text: "Here you will find your received invitations".tr(),),
                      ],
                    );
                  }

                  return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(cubit.invitationsModel!.data.length, (index) {
                    return Row(
                      children: [
                        SizedBox(
                            width: AppUtil.responsiveWidth(context)*0.93,
                            child: InvitationCard(event: cubit.invitationsModel!.data[index], wait: true,)
                        ),
                        const SizedBox(width: 20,)
                      ],
                    );
                  }
                  ),
                );
              }
            ),
          ),
          const SizedBox(height: 38,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: CustomText(text: "myLatestTemplate".tr(),fontSize: 18,fontWeight: FontWeight.bold,color: AppUI.blackColor,),
          ),
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 350,
              child: BlocBuilder<AddEventCubit,AddEventState>(
                  buildWhen: (_,state) => state is EventSubTypesLoadingState || state is EventSubTypesLoadedState || state is EventSubTypesEmptyState || state is EventSubTypesErrorState,
                  builder: (context, state) {
                    if(state is EventSubTypesLoadingState){
                      return const LoadingWidget();
                    }
                    if(state is EventSubTypesEmptyState){
                      return EmptyWidget(text: "noDataAvailable".tr(),);
                    }
                    if(state is EventSubTypesErrorState){
                      return const ErrorFetchWidget();
                    }
                  return ListView(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(8, (index) {
                            return Row(
                              children: [
                                SizedBox(
                                    width: AppUtil.responsiveWidth(context)*0.60,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap:(){
                                            AppUtil.mainNavigator(context, const AddEventsScreen());
                                          },
                                          child: CachedNetworkImage(
                                            imageUrl: eventcubit.eventSubTypesModel!.types[0].templates![index].photo.toString(),
                                            width: double.infinity,
                                            height: 350,
                                            placeholder: (context, url) => Image.network(
                                              eventcubit.eventSubTypesModel!.types[0].templates![index].photo.toString(),
                                              width: double.infinity,
                                              height: 350,
                                              fit: BoxFit.fill,
                                            ),
                                            errorWidget: (context, url, error) => Image.asset(
                                                "${AppUI.imgPath}template_home.png",
                                                width: double.infinity,
                                                height: 350,
                                                fit: BoxFit.fill),
                                          ),
                                        ),
                                      ],
                                    ),
                                ),
                                const SizedBox(width: 20,)
                              ],
                            );
                          }
                          ),
                        );
                }
              ),
            ),
          ),
          const SizedBox(height: 100,),
        ],
      ),
    );
  }
}
