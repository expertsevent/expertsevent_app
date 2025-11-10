import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/event/models/events_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../../../event/presentation/controller/guards/guards_cubit.dart';
import '../../../../layout/presentation/screens/layout_screen.dart';
import '../../../../more/presentation/screens/pages/packages/package_screen.dart';
import '../../controller/add_event_cubit.dart';
import '../../controller/add_event_states.dart';

class Preview extends StatelessWidget {
  final Event? event;
  const Preview({Key? key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = AddEventCubit.get(context);
    return Container(
        color: AppUI.whiteColor,
        margin: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Column(children: [
              Stack(
                children: [
                  if (cubit.eventPhotoUpload != null)
                    Image.file(File(cubit.eventPhotoUpload!.path,),
                        width: double.infinity, height: 350,fit: BoxFit.fill)
                  else
                    if (cubit.eventPhoto != null)
                      Image.file(cubit.eventPhoto!,
                          width: double.infinity, fit: BoxFit.fill)
                    else
                      CachedNetworkImage(
                        imageUrl: "",
                        width: double.infinity,
                        height: 182,
                        placeholder: (context, url) => Image.asset(
                          "${AppUI.imgPath}event.png",
                          width: double.infinity,
                          height: 182,
                          fit: BoxFit.fill,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                            "${AppUI.imgPath}event.png",
                            width: double.infinity,
                            height: 182,
                            fit: BoxFit.fill),
                      ),
                  Row(
                    children: [
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: const Color(0xffFFEFAE)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // CircleAvatar(
                            //   radius: 12,
                            //   backgroundColor: AppUI.whiteColor,
                            //   child: CachedNetworkImage(
                            //     imageUrl: "",
                            //     height: 20,
                            //     placeholder: (context, url) => SvgPicture.asset(
                            //       "${AppUI.iconPath}party.svg",
                            //       height: 20,
                            //       fit: BoxFit.fill,
                            //     ),
                            //     errorWidget: (context, url, error) =>
                            //         SvgPicture.asset("${AppUI.iconPath}party.svg",
                            //             height: 20, fit: BoxFit.fill),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   width: 5,
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CustomText(
                                text: cubit.eventType.text,
                                fontSize: 11,
                                color: const Color(0xffE3B800),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: 58,
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                            color: AppUI.secondColor),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text:
                              "${cubit.dob.text.split('-')[2]}\n${cubit.dob.text.split('-')[1] == "01" ? "Jen" : cubit.dob.text.split('-')[1] == "02" ? "Feb" : cubit.dob.text.split('-')[1] == "03" ? "Mar" : cubit.dob.text.split('-')[1] == "04" ? "Apr" : cubit.dob.text.split('-')[1] == "05" ? "May" : cubit.dob.text.split('-')[1] == "06" ? "Jun" : cubit.dob.text.split('-')[1] == "07" ? "Jul" : cubit.dob.text.split('-')[1] == "08" ? "Aug" : cubit.dob.text.split('-')[1] == "09" ? "Sep" : cubit.dob.text.split('-')[1] == "10" ? "Oct" : cubit.dob.text.split('-')[1] == "11" ? "Nov" : cubit.dob.text.split('-')[1] == "12" ? "Dec" : ""}",
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              textAlign: TextAlign.center,
                              color: AppUI.whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: cubit.eventName.text,
                          color: AppUI.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const Spacer(),
                        CustomButton(
                          text: "draft".tr(),
                          width: 100,
                          height: 35,
                          textColor: AppUI.secondColor,
                          color: AppUI.secondColor.withOpacity(0.16),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppUI.mainColor,
                          child:
                          SvgPicture.asset("${AppUI.iconPath}calendar-alt.svg"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: cubit.dob.text,
                              color: AppUI.blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomText(
                              text: cubit.time.text,
                              color: AppUI.bottomBarColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: AppUI.greyColor,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xff7CACDC),
                          child: SvgPicture.asset("${AppUI.iconPath}location.svg"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cubit.address.text,
                              style: const TextStyle(
                                color: AppUI.blackColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.clip,
                              ),
                            ),
                            // CustomText(
                            //   text: "viewMap".tr(),
                            //   color: AppUI.bottomBarColor,
                            // ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 1,
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      color: AppUI.greyColor,
                    ),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: const Color(0xff92C6F9),
                          child: SvgPicture.asset("${AppUI.iconPath}users.svg"),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: AppUtil.responsiveWidth(context) * 0.65,
                              child: Row(
                                children: [
                                  CustomText(
                                    text: "visitors".tr(),
                                    color: AppUI.blackColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  const Spacer(),
                                  // InkWell(
                                  //   onTap: (){
                                  //     contactsBottomSheet(context);
                                  //   },
                                  //   child: Row(
                                  //     children: [
                                  //       const Icon(Icons.edit,color: AppUI.buttonColor,size: 17,),
                                  //       const SizedBox(
                                  //         width: 7,
                                  //       ),
                                  //       CustomText(text: "editGuests".tr(),textDecoration: TextDecoration.underline,)
                                  //     ],
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            CustomText(
                              text:
                              "${cubit.contactsCheck.length.toString()} ${"guestsAdded".tr()}",
                            )
                          ],
                        ),
                      ],
                    ),
                    if (cubit.show)
                      Container(
                        width: 1,
                        height: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        color: AppUI.greyColor,
                      ),
                    if (cubit.show)
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xffB3D5F6),
                            child: SvgPicture.asset("${AppUI.iconPath}payment.svg"),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: AppUtil.responsiveWidth(context) * 0.65,
                                child: CustomText(
                                  text: "payment".tr(),
                                  color: AppUI.blackColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              CustomText(
                                text: AppUtil.rtlDirection(context)
                                    ? "عدد ${cubit.contactsCheck.length} ضيوف "
                                    : "Number of ${cubit.contactsCheck.length} guests",
                              )
                            ],
                          ),
                        ],
                      ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomText(
                      text: "${"description".tr()}:",
                      color: AppUI.blackColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomText(
                      text: cubit.desc.text,
                      color: AppUI.bottomBarColor,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    BlocBuilder<AddEventCubit, AddEventState>(
                        buildWhen: (_, state) =>
                        state is AddDraftEventLoadingState ||
                            state is AddDraftEventLoadedState,
                        builder: (context, state) {
                          if (state is AddDraftEventLoadingState) {
                            return const LoadingWidget();
                          }
                          return CustomButton(
                            text: "saveAsDraft".tr(),
                            onPressed: () {
                               cubit.addEvent(
                                  GuardsCubit.get(context).selectedGuardsIds,
                                  context,
                                  draft: true,
                                  id: event == null ? null : event!.id.toString());
                            },
                          );
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: "previous".tr(),
                            color: AppUI.whiteColor,
                            textColor: AppUI.buttonColor,
                            borderColor: AppUI.buttonColor,
                            onPressed: () {
                              cubit.pageIndex = 1;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: BlocBuilder<AddEventCubit, AddEventState>(
                              buildWhen: (_, state) =>
                              state is AddEventLoadingState ||
                                  state is AddEventLoadedState,
                              builder: (context, state) {
                                if (state is AddEventLoadingState) {
                                  return const LoadingWidget();
                                }
                                return CustomButton(
                                  text: "next".tr(),
                                  onPressed: () {
                                      AppUtil.dialog2(
                                          context, 'How would you like to pay'.tr(), [
                                        Row(
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  Navigator.of(context,rootNavigator: true).pop();
                                                  cubit.addEvent(
                                                      GuardsCubit.get(context)
                                                          .selectedGuardsIds,
                                                      context,
                                                      draft: false,
                                                      id: event == null
                                                          ? null
                                                          : event!.id.toString(),
                                                      pay: true);
                                                },
                                                child: CustomText(
                                                    text: 'Wallet'.tr())),
                                          ],
                                        ),
                                        const Divider(),
                                        Row(
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  Navigator.of(context,rootNavigator: true).pop();
                                                  await cubit.addEvent(
                                                      GuardsCubit.get(context)
                                                          .selectedGuardsIds,
                                                      context,
                                                      draft: true,
                                                      id: event == null
                                                          ? null
                                                          : event!.id.toString(),
                                                      pay: false,package:true);
                                                  AppUtil.mainNavigator(context, const PackageScreen());
                                                  AppUtil.successToast(context, 'eventAddedtoDraftUntilPay'.tr());
                                                },
                                                child: CustomText(
                                                    text: 'Buy Package'.tr())),
                                          ],
                                        ),
                                      ]);
                                  },
                                );
                              }),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ])));
  }
}