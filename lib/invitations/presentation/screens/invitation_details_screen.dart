import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/event/models/events_model.dart';
import 'package:expert_events/event/presentation/controller/events/events_cubit.dart';
import 'package:expert_events/event/presentation/controller/events/events_states.dart';
import 'package:expert_events/event/presentation/screens/details/share_btn_widget.dart';
import 'package:expert_events/event/presentation/screens/details/share_moment_screen.dart';
import 'package:expert_events/more/presentation/components/visitor_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:ui' as ui;
import '../../../../add_event/presentation/controller/add_event_cubit.dart';
import '../../../../add_event/presentation/controller/add_event_states.dart';
import '../../../../add_event/presentation/screens/add_event_screen.dart';
import '../../../../add_event/presentation/screens/taps/preview_draft.dart';
import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../../../more/presentation/screens/pages/packages/package_screen.dart';
import 'package:expert_events/event/presentation/screens/event_comments/event_comments_screen.dart';

import '../../../event/presentation/screens/details/guest_book_screen.dart';

class InvitationDetailsScreen extends StatefulWidget {
  Event event;
  InvitationDetailsScreen({Key? key, required this.event}) : super(key: key);

  @override
  State<InvitationDetailsScreen> createState() => _InvitationDetailsScreenState();
}

class _InvitationDetailsScreenState extends State<InvitationDetailsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final eventCubit = EventsCubit.get(context);
  late final AddEventCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = AddEventCubit.get(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: BlocBuilder<EventsCubit,EventsStates>(
          buildWhen: (_,state) => state is DraftEventsLoadedState,
          builder: (context, snapshot) {
            return Stack(
              children: [
                Image.asset(
                  "${AppUI.imgPath}splash.png",
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.fill,
                ),
                Column(
                  children: [
                    customAppBar(
                        title: "eventDetails".tr(),
                        backgroundColor: Colors.transparent,
                        actions: [
                          InkWell(
                              onTap: (){
                                AppUtil.mainNavigator(context,
                                    GreetingsPage(id: widget.event.id.toString(),)
                                );
                              },
                              child: SvgPicture.asset("${AppUI.iconPath}book.svg")
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                        ]),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          color: AppUI.whiteColor,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        AppUtil.dialog2(context, "preview".tr(), [
                                          CachedNetworkImage(
                                            imageUrl: widget.event.photo,
                                            placeholder: (context, url) => Image.asset(
                                              "${AppUI.imgPath}event.png",
                                              width: double.infinity,
                                              height: 182,
                                              fit: BoxFit.fill,
                                            ),
                                            errorWidget: (context, url, error) =>
                                                Image.asset("${AppUI.imgPath}event.png",
                                                    width: double.infinity,
                                                    height: 182,
                                                    fit: BoxFit.fill),
                                          ),
                                          SizedBox(height: 25,),
                                          CustomButton(width: 120,height: 40,text: "close".tr(),
                                            onPressed: () async {
                                              Navigator.of(context,rootNavigator: true).pop();
                                            },
                                            textColor: AppUI.whiteColor,
                                            borderColor: AppUI.errorColor,
                                            color: AppUI.errorColor,
                                          )
                                        ],);
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl: widget.event.photo,
                                        width: double.infinity,
                                        height: 182,
                                        placeholder: (context, url) => Image.asset(
                                          "${AppUI.imgPath}event.png",
                                          width: double.infinity,
                                          height: 182,
                                          fit: BoxFit.fill,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset("${AppUI.imgPath}event.png",
                                                width: double.infinity,
                                                height: 182,
                                                fit: BoxFit.fill),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50),
                                              color: const Color(0xffFFEFAE)),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 12,
                                                backgroundColor: AppUI.whiteColor,
                                                child: CachedNetworkImage(
                                                  imageUrl: widget.event.type.photo,
                                                  height: 20,
                                                  placeholder: (context, url) =>
                                                      SvgPicture.asset(
                                                        "${AppUI.iconPath}party.svg",
                                                        height: 20,
                                                        fit: BoxFit.fill,
                                                      ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      SvgPicture.asset(
                                                          "${AppUI.iconPath}party.svg",
                                                          height: 20,
                                                          fit: BoxFit.fill),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              CustomText(
                                                text: widget.event.type.name,
                                                fontSize: 11,
                                                color: const Color(0xffE3B800),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        Container(
                                          height: 58,
                                          width: 50,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(50),
                                                bottomRight: Radius.circular(50),
                                              ),
                                              color: AppUI.secondColor),
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              CustomText(
                                                text: "${widget.event.dateFrom.split('-')[2]}\n${widget.event.dateFrom.split('-')[1] == "01"? "Jen" : widget.event.dateFrom.split('-')[1] == "02"? "Feb" : widget.event.dateFrom.split('-')[1] == "03"? "Mar" : widget.event.dateFrom.split('-')[1] == "04"? "Apr" : widget.event.dateFrom.split('-')[1] == "05"? "May" : widget.event.dateFrom.split('-')[1] == "06"? "Jun" : widget.event.dateFrom.split('-')[1] == "07"? "Jul" : widget.event.dateFrom.split('-')[1] == "08"? "Aug" : widget.event.dateFrom.split('-')[1] == "09"? "Sep" : widget.event.dateFrom.split('-')[1] == "10"? "Oct" : widget.event.dateFrom.split('-')[1] == "11"? "Nov" : widget.event.dateFrom.split('-')[1] == "12"? "Dec":""}",
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
                                      CustomText(
                                        text: widget.event.name,
                                        color: AppUI.blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: AppUI.mainColor,
                                            child: SvgPicture.asset(
                                                "${AppUI.iconPath}calendar-alt.svg"),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: widget.event.dateFrom,
                                                color: AppUI.blackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              CustomText(
                                                text: widget.event.timeFrom,
                                                color: AppUI.bottomBarColor,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        width: 1,
                                        height: 30,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        color: AppUI.greyColor,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: const Color(0xff7CACDC),
                                            child: SvgPicture.asset(
                                                "${AppUI.iconPath}location.svg"),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: AppUtil.responsiveWidth(context)*0.6,
                                                child: CustomText(
                                                  text: widget.event.location,
                                                  color: AppUI.blackColor,
                                                  fontWeight: FontWeight.bold,
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
                                        height: 30,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        color: AppUI.greyColor,
                                      ),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: const Color(0xffBAD9F6),
                                            child: SvgPicture.asset(
                                                "${AppUI.iconPath}comment.svg"),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width:
                                                AppUtil.responsiveWidth(context) *
                                                    0.65,
                                                child: Row(
                                                  children: [
                                                    CustomText(
                                                      text: "comments".tr(),
                                                      color: AppUI.blackColor,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    const Spacer(),
                                                    InkWell(
                                                      onTap: () {
                                                        AppUtil.mainNavigator(context,
                                                            EventCommentsScreen(id: widget.event.id.toString(),));
                                                      },
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              "${AppUI.iconPath}eye.svg"),
                                                          const SizedBox(
                                                            width: 7,
                                                          ),
                                                          CustomText(
                                                              text: "viewAll".tr())
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                                InkWell(
                                                  onTap: (){
                                                    var commentController = TextEditingController();
                                                    AppUtil.dialog2(context, 'addComment'.tr(), [
                                                      CustomInput(controller: commentController, textInputType: TextInputType.text),
                                                      const SizedBox(height: 20,),
                                                      BlocBuilder<EventsCubit,EventsStates>(
                                                          buildWhen: (_,state) => state is AddCommentLoadingState || state is AddCommentLoadedState,
                                                          builder: (context, state) {
                                                            if(state is AddCommentLoadingState){
                                                              return const LoadingWidget();
                                                            }
                                                            return CustomButton(text: 'addComment'.tr(),onPressed: (){
                                                              eventCubit.addComment(context,commentController.text,widget.event.id.toString());
                                                            },);
                                                          }
                                                      )
                                                    ]);
                                                  },
                                                  child: CustomText(
                                                    text: "+ ${"addComment".tr()}".tr(),
                                                    color: AppUI.secondColor,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                        Container(
                                          width: 1,
                                          height: 30,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          color: AppUI.greyColor,
                                        ),
                                      if(widget.event.chat!.toString() != 'null')
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: const Color(0xff92C6F9),
                                              child: SvgPicture.asset(
                                                  "${AppUI.iconPath}comment.svg"),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width:
                                                  AppUtil.responsiveWidth(context) * 0.65,
                                                  child: CustomText(
                                                    text: widget.event.chat!,
                                                    color: AppUI.blackColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                       CustomButton(
                                          text: "Share your moment".tr(),
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                shape: const RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .only(topLeft: Radius
                                                        .circular(30),
                                                        topRight: Radius
                                                            .circular(30))
                                                ),
                                                builder: (context) {
                                                  return ShareBtn(
                                                    id: widget.event.id
                                                        .toString(),);
                                                });
                                          }),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        InkWell(
                                          onTap: (){
                                            AppUtil.mainNavigator(context,
                                                ShareMomentScreen(id: widget.event.id.toString(),));
                                          },
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  CustomText(text: "Share your moment".tr(),fontSize: 16,fontWeight: FontWeight.bold,color: AppUI.blackColor,),
                                                  const Spacer(),
                                                  CustomText(text: "${"viewAll".tr()} +",fontWeight: FontWeight.bold,),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 10 ,
                                              ),
                                              Row(
                                                children: [
                                                  CustomCard(
                                                      padding: 0,
                                                      color: Colors.transparent,
                                                      elevation: 2,
                                                      child: Image.network(widget.event.sharePhotoOne!,width: 150,height: 100,fit: BoxFit.fill,)
                                                  ),
                                                  const Spacer(),
                                                  CustomCard(
                                                      padding: 0,
                                                      color: Colors.transparent,
                                                      elevation: 5,
                                                      child: Image.network(widget.event.sharePhotoTwo!,width: 150,height: 100,fit: BoxFit.fill,)
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 40,
                                        ),
                                      SizedBox(
                                        height: 300,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            GoogleMap(
                                              initialCameraPosition: CameraPosition(target: LatLng(double.parse(widget.event.lat.toString()),double.parse(widget.event.lang.toString())), zoom: 8),
                                              onMapCreated: (map){
                                                // googleMapController = map;
                                              },
                                              gestureRecognizers: {
                                                Factory(() => ScaleGestureRecognizer()),
                                              },
                                              myLocationButtonEnabled: false,
                                              myLocationEnabled: true,
                                              onCameraMove: (CameraPosition position) {
                                                // _currentLocation = position.target;
                                              },
                                            ),
                                            SvgPicture.asset(
                                                "${AppUI.iconPath}destination.svg")
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            );
          }
      ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

}