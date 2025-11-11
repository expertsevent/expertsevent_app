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
import '../../controller/guards/guards_cubit.dart';
import '../../controller/guards/guards_states.dart';
import '../event_comments/event_comments_screen.dart';
import 'guest_book_screen.dart';
import 'postpone_event_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  Event event;
  final String type;
  EventDetailsScreen({Key? key, required this.event,required this.type}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late final eventCubit = EventsCubit.get(context);
  late final addcubit = AddEventCubit.get(context);
  late final  guardsCubit = GuardsCubit.get(context);

  Country? _selectedCountry = Country(
    phoneCode: '966',
    countryCode: 'SA',
    e164Sc: -1,
    geographic: false,
    level: -1,
    name: 'World Wide',
    example: '',
    displayName: 'World Wide (WW)',
    displayNameNoCountryCode: 'World Wide',
    e164Key: '',
  );
  List<int> contactIndexes = [];

  late final AddEventCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = AddEventCubit.get(context);
    cubit.askPermissions(context);
    GuardsCubit.get(context).getGuards();
    cubit.phones.clear();
    for (var element in widget.event.visitors) {
      guardsCubit.visitorsCheck.add(false);
      guardsCubit.guardsCheck.add(false);
      cubit.phones.add(element.phone);
      cubit.names.add(element.name);
      cubit.contactsCheck.add(element.phone);
      print('hvhvhvhbhjbhjbhbhjjhbjhbhj ${element.phone}');

    }
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
                              //redirect to book page GreetingsPage();
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
                                      Row(
                                        children: [
                                          CustomText(
                                            text: widget.event.name,
                                            color: AppUI.blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const Spacer(),
                                          CustomButton(
                                            text: widget.type,
                                            width: 100,
                                            height: 35,
                                            textColor: AppUI.secondColor,
                                            color:
                                            AppUI.secondColor.withOpacity(0.16),
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
                                              if(widget.type != "cancel".tr() && widget.type != "finished".tr())
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
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: const Color(0xff92C6F9),
                                            child: SvgPicture.asset(
                                                "${AppUI.iconPath}users.svg"),
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
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        CustomText(
                                                          text: "${"visitors".tr()} (${widget.event.visitors.length})",
                                                          color: AppUI.blackColor,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                        const Spacer(),
                                                        InkWell(
                                                          onTap: () {
                                                            if(widget.event.visitors.isNotEmpty) {
                                                              visitorsBottomSheet(context);
                                                            }
                                                          },
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.cancel,color:Colors.red,size:18),
                                                              const SizedBox(
                                                                width: 7,
                                                              ),
                                                              CustomText(
                                                                  text: "delete".tr(),color:Colors.red)
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if(widget.type != "cancel".tr() && widget.type != "finished".tr())
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: (){
                                                              contactsBottomSheet(context);
                                                            },
                                                            child: CustomText(
                                                              text: "+ ${"addVisitors".tr()}".tr(),
                                                              color: AppUI.secondColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  ],
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
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor: const Color(0xffB3D5F6),
                                            child: SvgPicture.asset(
                                                "${AppUI.iconPath}add_gaurd.svg"),
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
                                                      text: "${"guards".tr()} (${widget.event.guards.length})",
                                                      color: AppUI.blackColor,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                    const Spacer(),
                                                    if(widget.event.guards.isNotEmpty)
                                                      InkWell(
                                                        onTap: () {
                                                          if(widget.event.guards.isNotEmpty) {
                                                            guardsBottomSheet(context);
                                                          }
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.cancel,color:Colors.red,size:18),
                                                            const SizedBox(
                                                              width: 7,
                                                            ),
                                                            CustomText(
                                                                text: "delete".tr(),color:Colors.red)
                                                          ],
                                                        ),
                                                      )
                                                  ],
                                                ),
                                              ),
                                              if(widget.type != "cancel".tr() && widget.type != "finished".tr())
                                                InkWell(
                                                  onTap: (){
                                                    addGuardsBottomSheet(context);
                                                  },
                                                  child: Row(
                                                    children: [
                                                      CustomText(
                                                        text: "addGuard".tr(),
                                                        color: AppUI.secondColor,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                            ],
                                          ),
                                        ],
                                      ),
                                      if(widget.type == "cancel".tr() || widget.event.chat!.toString() != 'null')
                                        Container(
                                          width: 1,
                                          height: 30,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          color: AppUI.greyColor,
                                        ),
                                      if(widget.type == "cancel".tr() || widget.event.chat!.toString() != 'null')
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
                                      if ( widget.type == "active".tr()) CustomButton(
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
                                      if ( widget.type == "active".tr())
                                        const SizedBox(
                                          height: 20,
                                        ),
                                      // CustomText(
                                      //   text: "${"description".tr()}:",
                                      //   color: AppUI.blackColor,
                                      //   fontSize: 16,
                                      //   fontWeight: FontWeight.bold,
                                      // ),
                                      // const SizedBox(
                                      //   height: 5,
                                      // ),
                                      // CustomText(
                                      //   text: widget.event.content,
                                      //   color: AppUI.bottomBarColor,
                                      // ),
                                      // const SizedBox(
                                      //   height: 20,
                                      // ),
                                      if ( widget.type == "active".tr())
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
                                      if ( widget.type == "active".tr())
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
                                              // polylines: polyline==null?{}:{
                                              //   Polyline(
                                              //     polylineId: PolylineId('overview_polyline${widget.orderId}'),
                                              //     color: Colors.red,
                                              //     width: 2,
                                              //     points: polyline
                                              //         .map((e) => LatLng(e.latitude, e.longitude))
                                              //         .toList(),
                                              //   ),
                                              // },
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

                                      if(widget.type != "draft".tr())
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(
                                              text: "visitorsStatus".tr(),
                                              color: AppUI.blackColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              width: AppUtil.responsiveWidth(context) * 0.8,
                                              child: Row(
                                                children: [
                                                  CustomText(
                                                    text:
                                                    "${"invitationSentTo".tr()} ${widget.event.countvisitor} ${"users".tr()}",
                                                    color: const Color(0xff8A8D9F),
                                                    fontSize: 12,
                                                  ),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: (){
                                                      invitationsBottomSheet(context);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            "${AppUI.iconPath}eye.svg"),
                                                        const SizedBox(
                                                          width: 7,
                                                        ),
                                                        CustomText(text: "viewAll".tr())
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if(widget.type !="cancel".tr() && widget.type != "draft".tr())

                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SvgPicture.asset("${AppUI.iconPath}bg.svg"),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 30.0,
                                                        lineWidth: 8.0,
                                                        percent: widget.event.acceptvisitorCount==0 || widget.event.countvisitor==0 ?0:widget.event.acceptvisitorCount/widget.event.countvisitor,
                                                        center: const CircleAvatar(
                                                          backgroundColor:
                                                          Color(0xffEDEBF7),
                                                          radius: 12,
                                                          child: Icon(Icons.person,
                                                              color: AppUI.secondColor,
                                                              size: 14),
                                                        ),
                                                        circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                        backgroundColor:
                                                        const Color(0xffEDEBF7),
                                                        progressColor:
                                                        AppUI.secondColor,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      CustomText(
                                                        text: "acceptInvitation".tr(),
                                                        color: AppUI.blackColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      CustomText(
                                                        text: "${widget.event.acceptvisitorCount} ${"users".tr()}",
                                                        color: const Color(0xff8A8D9F),
                                                        fontSize: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 30.0,
                                                        lineWidth: 8.0,
                                                        percent: widget.event.cancelvisitorCount==0 || widget.event.countvisitor==0 ?0:widget.event.cancelvisitorCount/widget.event.countvisitor,
                                                        center: const CircleAvatar(
                                                          backgroundColor:
                                                          Color(0xffEDEBF7),
                                                          radius: 12,
                                                          child: Icon(Icons.person,
                                                              color: AppUI.errorColor,
                                                              size: 14),
                                                        ),
                                                        circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                        backgroundColor:
                                                        const Color(0xffEDEBF7),
                                                        progressColor: AppUI.errorColor,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      CustomText(
                                                        text: "cancelInvitation".tr(),
                                                        color: AppUI.blackColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      CustomText(
                                                        text: "${widget.event.cancelvisitorCount} ${"users".tr()}",
                                                        color: const Color(0xff8A8D9F),
                                                        fontSize: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 30.0,
                                                        lineWidth: 8.0,
                                                        percent: widget.event.pendingvisitorCount==0 || widget.event.countvisitor==0 ?0:widget.event.pendingvisitorCount/widget.event.countvisitor,
                                                        center: const CircleAvatar(
                                                          backgroundColor:
                                                          Color(0xffEDEBF7),
                                                          radius: 12,
                                                          child: Icon(Icons.person,
                                                              color: Color(0xffFEBD4C),
                                                              size: 14),
                                                        ),
                                                        circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                        backgroundColor:
                                                        const Color(0xffEDEBF7),
                                                        progressColor:
                                                        const Color(0xffFEBD4C),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      CustomText(
                                                        text: "waitingReply".tr(),
                                                        color: AppUI.blackColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      CustomText(
                                                        text: "${widget.event.pendingvisitorCount} ${"users".tr()}",
                                                        color: const Color(0xff8A8D9F),
                                                        fontSize: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Column(
                                                    children: [
                                                      CircularPercentIndicator(
                                                        radius: 30.0,
                                                        lineWidth: 8.0,
                                                        percent: widget.event.attendvisitorCount==0 || widget.event.countvisitor==0 ?0:widget.event.attendvisitorCount/widget.event.countvisitor,
                                                        center: const CircleAvatar(
                                                          backgroundColor:
                                                          Color(0xffEDEBF7),
                                                          radius: 12,
                                                          child: Icon(Icons.person,
                                                              color: Color(0xffFEBD4C),
                                                              size: 14),
                                                        ),
                                                        circularStrokeCap:
                                                        CircularStrokeCap.round,
                                                        backgroundColor:
                                                        const Color(0xffEDEBF7),
                                                        progressColor:
                                                        const Color(0xffFEBD4C),
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      CustomText(
                                                        text: "attendInvitation".tr(),
                                                        color: AppUI.blackColor,
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      CustomText(
                                                        text: "${widget.event.attendvisitorCount} ${"users".tr()}",
                                                        color: const Color(0xff8A8D9F),
                                                        fontSize: 12,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        )
                                    ],
                                  ),
                                ),
                                if(widget.type == "draft".tr())
                                  Column(
                                    children: [
                                      CustomButton(text: "Edit Event".tr(),onPressed: (){
                                        cubit.eventId = widget.event.id;
                                        AppUtil.mainNavigator(context, AddEventsScreen(event: widget.event));
                                      },),
                                      const SizedBox(height: 10,),
                                      if(cubit.show)
                                        CustomButton(text: "completeEvent".tr(),onPressed: (){
                                          cubit.eventId = widget.event.id;
                                          // AppUtil.mainNavigator(context, const Payment(type: "add"));
                                          AppUtil.mainNavigator(context, PreviewDraft(event: widget.event.id,countvisitor:widget.event.countvisitor));
                                        },),

                                    ],
                                  ),
                                const SizedBox(
                                  height: 15,
                                ),
                                if(widget.type!="cancel".tr() && widget.type != "draft".tr() &&  widget.type != "finished".tr())
                                  Row(
                                    children: [
                                      Expanded(
                                        child: BlocBuilder<EventsCubit,EventsStates>(
                                            buildWhen: (_,state) => state is CancelEventLoadingSate || state is CancelEventLoadedSate,
                                            builder: (context, state) {
                                              if(state is CancelEventLoadingSate){
                                                return const LoadingWidget();
                                              }
                                              return CustomButton(
                                                text: "cancel".tr(),
                                                color: AppUI.whiteColor,
                                                borderColor: AppUI.errorColor,
                                                textColor: AppUI.errorColor,
                                                onPressed: (){
                                                  AppUtil.dialog2(context, 'The Reason Of Event Cancel'.tr(), [
                                                    CustomInput(controller: eventCubit.reason, textInputType: TextInputType.text),
                                                    const SizedBox(height: 15,),
                                                    CustomButton(text: 'submit'.tr(),onPressed: (){
                                                      Navigator.of(context,rootNavigator: true).pop();
                                                      eventCubit.cancelEvent(context,widget.event.id, 'cancel');
                                                    },)
                                                  ]);
                                                },
                                              );
                                            }
                                        ),
                                      ),
                                      const SizedBox(width: 15,),
                                      Expanded(
                                        child: CustomButton(
                                          text: "postpone".tr(),
                                          color: AppUI.whiteColor,
                                          borderColor: AppUI.buttonColor,
                                          textColor: AppUI.buttonColor,
                                          onPressed: (){
                                            AppUtil.mainNavigator(context, PostponeEventScreen(id: widget.event.id));
                                          },
                                        ),
                                      ),

                                    ],
                                  ),
                                const SizedBox(
                                  height: 20,
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

  visitorsBottomSheet(context){
    return showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
    ), builder: (context){
      return SizedBox(
        height: AppUtil.responsiveHeight(context)*0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context,rootNavigator: true).pop();
                  }, icon: const Icon(Icons.close,color: AppUI.errorColor,)),
                  CustomText(text: "visitors".tr(),color: AppUI.blackColor,fontSize: 17,fontWeight: FontWeight.bold,),
                  const SizedBox(width: 40,)
                ],
              ),
            ),
            Expanded(
              child: VisitorCard(visitors: widget.event.visitors,checkbox : true),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(text: 'done'.tr(),onPressed: () async {
                Navigator.pop(context);
                await guardsCubit.deleteVisitorsFromEvent(widget.event.id, scaffoldKey.currentContext);
              },),
            )
          ],
        ),
      );
    });
  }

  invitationsBottomSheet(context){
    return showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
    ), builder: (context){
      return SizedBox(
        height: AppUtil.responsiveHeight(context)*0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context,rootNavigator: true).pop();
                  }, icon: const Icon(Icons.close,color: AppUI.errorColor,)),
                  CustomText(text: "visitors".tr(),color: AppUI.blackColor,fontSize: 17,fontWeight: FontWeight.bold,),
                  const SizedBox(width: 40,)
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: List.generate(widget.event.visitors.length, (index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                        const SizedBox(width: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          CustomText(text: widget.event.visitors[index].name!,color: AppUI.blackColor,fontWeight: FontWeight.bold,),
                          const SizedBox(height: 5,),
                          CustomText(text: widget.event.visitors[index].phone!,color: AppUI.blackColor,),
                          ],
                        ),
                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                              if(widget.event.visitors[index].status == "1")
                              CustomText(text: "waitApprove".tr(),color: Colors.orange,),
                              if(widget.event.visitors[index].status == "2")
                              CustomText(text: "acceptInvitation".tr(),color: AppUI.activeColor,),
                              if(widget.event.visitors[index].status == "3")
                              CustomText(text: "cancelInvitation".tr(),color: AppUI.errorColor,),
                              if(widget.event.visitors[index].status == "4")
                              CustomText(text: "attendInvitation".tr(),color: AppUI.activeColor,),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider()
                    ],
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(text: 'done'.tr(),onPressed: (){
                Navigator.pop(context);
              },),
            )
          ],
        ),
      );
    });
  }


  addGuardsBottomSheet(context) async {
    final guardsCubit = GuardsCubit.get(context);
    return showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
    ), builder: (context){
      return  BlocBuilder<GuardsCubit,GuardsSates>(
          buildWhen: (_,state) =>  state is GuardsLoadedState,
          builder: (context, state) {
            return SizedBox(
              height: AppUtil.responsiveHeight(context)*0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomText(text: "guards".tr(),color: AppUI.blackColor,fontSize: 17,fontWeight: FontWeight.bold,),
                            const Spacer(),
                            InkWell(
                                onTap: (){
                                  AppUtil.dialog2(context, 'addGuard'.tr(), [
                                    CustomInput(controller: guardsCubit.nameController, hint: "name".tr(), textInputType: TextInputType.text),
                                    const SizedBox(height: 10,),
                                    BlocBuilder<GuardsCubit,GuardsSates>(
                                        buildWhen: (_,state) =>  state is GuardsLoadedState,
                                        builder: (context, state) {
                                          return CustomInput(controller:guardsCubit.phoneController,hint: "phoneNumber".tr(), textInputType: TextInputType.phone,prefixIcon: SizedBox(
                                            width: 50,
                                            child: InkWell(
                                              onTap: (){
                                                showCountryPicker(
                                                  context: context,
                                                  showPhoneCode: true,
                                                  countryListTheme: CountryListThemeData(
                                                    flagSize: 25,
                                                    backgroundColor: Colors.white,
                                                    textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                                                    bottomSheetHeight: 500, // Optional. Country list modal height
                                                    //Optional. Sets the border radius for the bottomsheet.
                                                    borderRadius: const BorderRadius.only(
                                                      topLeft: Radius.circular(20.0),
                                                      topRight: Radius.circular(20.0),
                                                    ),
                                                    //Optional. Styles the search field.
                                                    inputDecoration: InputDecoration(
                                                      labelText: 'Search',
                                                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                                                      hintText: 'Start typing to search',
                                                      prefixIcon: const Icon(Icons.search),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(30),
                                                        borderSide: BorderSide(
                                                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                                                        ),
                                                      ),
                                                    ),
                                                  ),// optional. Shows phone code before the country name.
                                                  onSelect: (Country country) {
                                                    _selectedCountry = country;
                                                    guardsCubit.countryCodeController.text = _selectedCountry!.phoneCode;
                                                    guardsCubit.emit(GuardsLoadedState());
                                                  },
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  if(_selectedCountry!=null)
                                                    CustomText(text:_selectedCountry!.flagEmoji),
                                                  const Icon(Icons.arrow_drop_down,color: AppUI.blackColor,),
                                                  Container(height: 20,width: 0.6,color: AppUI.disableColor,)
                                                ],
                                              ),
                                            ),
                                          ),);
                                        }
                                    ),
                                    const SizedBox(height: 20,),
                                    Row(
                                      children: [
                                        BlocBuilder<GuardsCubit,GuardsSates>(
                                            buildWhen: (_,state) => state is AddGuardsLoadingState || state is AddGuardsLoadedState,
                                            builder: (context, state) {
                                              if(state is AddGuardsLoadingState){
                                                return const LoadingWidget();
                                              }
                                              return Expanded(
                                                child: CustomButton(text: "save".tr(),onPressed: () async {
                                                  await guardsCubit.addGuard(context);
                                                },),
                                              );
                                            }
                                        ),
                                        const SizedBox(width: 10,),
                                        Expanded(
                                          child: CustomButton(text: "cancel".tr(),color: AppUI.whiteColor,textColor: AppUI.buttonColor,borderColor: AppUI.buttonColor,onPressed: (){
                                            Navigator.of(context,rootNavigator: true).pop();
                                          },),
                                        ),
                                      ],
                                    )
                                  ]);
                                },
                                child: SvgPicture.asset("${AppUI.iconPath}add.svg"))
                          ],
                        ),
                        // const SizedBox(height: 20,),
                        // SizedBox(height: 40,child: CustomInput(controller: TextEditingController(), hint: "search".tr(), borderColor: AppUI.secondColor, textInputType: TextInputType.text,prefixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.search,color: AppUI.secondColor,)),)),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            CustomText(text: "${guardsCubit.guardsCheckTrue.length}/${guardsCubit.guardsModel!.data.length} ${"selected".tr()}",fontWeight: FontWeight.bold,),
                            const Spacer(),
                            Row(
                              children: [
                                InkWell(
                                    onTap: (){
                                      guardsCubit.selectAllGuards();
                                    },
                                    child: CustomText(text: "selectAll".tr(),color: AppUI.secondColor,fontWeight: FontWeight.bold,)),
                                const SizedBox(width: 30,),
                                InkWell(
                                    onTap: (){
                                      guardsCubit.unSelectAllGuards();
                                    },
                                    child: CustomText(text: "clear".tr(),color: AppUI.errorColor,fontWeight: FontWeight.bold,)),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(height: 5,color: AppUI.backgroundColor,width: double.infinity,),
                  BlocBuilder<GuardsCubit,GuardsSates>(
                      buildWhen: (_,state) => state is GuardsLoadingState || state is GuardsLoadedState || state is GuardsErrorState || state is GuardsEmptyState,
                      builder: (context, state) {
                        if(state is GuardsLoadingState){
                          return const LoadingWidget();
                        }
                        if(state is GuardsErrorState){
                          return const ErrorFetchWidget();
                        }
                        if(state is GuardsEmptyState){
                          return const EmptyWidget();
                        }

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              shrinkWrap: true,
                              children: List.generate(guardsCubit.guardsModel!.data.length, (index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        // CachedNetworkImage(
                                        //   imageUrl: "",
                                        //   width: 40,
                                        //   height: 40,
                                        //   placeholder: (context, url) => Image.asset("${AppUI.imgPath}logo.png",width: 40,height: 40,fit: BoxFit.fill,),
                                        //   errorWidget: (context, url, error) => Image.asset("${AppUI.imgPath}logo.png",width: 40,height: 40,fit: BoxFit.fill),
                                        // ),
                                        // const SizedBox(width: 10,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomText(text: guardsCubit.guardsModel!.data[index].name,color: AppUI.blackColor,fontWeight: FontWeight.bold,),
                                            const SizedBox(height: 5,),
                                            Text(guardsCubit.guardsModel!.data[index].phone,style: const TextStyle(
                                                color: AppUI.blackColor
                                            ),textDirection: ui.TextDirection.ltr)
                                          ],
                                        ),
                                        const Spacer(),
                                        Checkbox(value: guardsCubit.guardsCheck[index], onChanged: (v){
                                          if(v!){
                                            guardsCubit.selectedGuardsIds.add(guardsCubit.guardsModel!.data[index].id);
                                          }else{
                                            guardsCubit.selectedGuardsIds.remove(guardsCubit.guardsModel!.data[index].id);
                                          }
                                          guardsCubit.setGuardsCheck(index, v);
                                        })
                                      ],
                                    ),
                                    const Divider()
                                  ],
                                );
                              }),
                            ),
                          ),
                        );
                      }
                  ),
                  //const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CustomButton(text: 'done'.tr(),onPressed: () async {
                      Navigator.pop(context);
                      await guardsCubit.addGuardsToEvent(widget.event.id, scaffoldKey.currentContext,from: "add");
                    },),
                  )
                ],
              ),
            );
          }
      );
    });
  }

  guardsBottomSheet(context){
    return showModalBottomSheet(context: context, isScrollControlled: true, shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))
    ), builder: (context){
      return SizedBox(
        height: AppUtil.responsiveHeight(context)*0.75,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: (){
                    Navigator.of(context,rootNavigator: true).pop();
                  }, icon: const Icon(Icons.close,color: AppUI.errorColor,)),
                  CustomText(text: "guards".tr(),color: AppUI.blackColor,fontSize: 17,fontWeight: FontWeight.bold,),
                  const SizedBox(width: 40,)
                ],
              ),
            ),
            Expanded(
              child: VisitorCard(visitors: widget.event.guards,isGuard: true,),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomButton(text: 'done'.tr(),onPressed: () async {
                Navigator.pop(context);
                await guardsCubit.addGuardsToEvent(widget.event.id, scaffoldKey.currentContext,from: "delete");
              },),
            )
          ],
        ),
      );
    });
  }

  contactsBottomSheet(context) async {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25), topRight: Radius.circular(25))),
        builder: (context) {
          return BlocBuilder<AddEventCubit, AddEventState>(
              buildWhen: (_, state) => state is ContactsLoadedState,
              builder: (context, state) {
                return SizedBox(
                  height: AppUtil.responsiveHeight(context) * 0.85,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CustomText(
                                  text: "contacts".tr(),
                                  color: AppUI.blackColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                                height: 40,
                                child: CustomInput(
                                  controller: cubit.searchContact,
                                  onChange: (v) {
                                    // cubit.getContacts(search: v);
                                    cubit.emit(ContactsLoadedState());
                                  },
                                  hint: "search".tr(),
                                  borderColor: AppUI.secondColor,
                                  textInputType: TextInputType.text,
                                  prefixIcon: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.search,
                                        color: AppUI.secondColor,
                                      )),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                            BlocBuilder<AddEventCubit, AddEventState>(
                                buildWhen: (_, state) =>
                                state is ContactChangeState,
                                builder: (context, state) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            text:
                                            "${cubit.phones.isEmpty ? widget.event.visitors.length : cubit.phones.length }/${cubit.contacts.where((element) => (element.displayName ?? '').toLowerCase().contains(cubit.searchContact.text.toLowerCase())).toList().length} ${"selected".tr()}",
                                            fontWeight: FontWeight.bold,
                                          ),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              InkWell(
                                                  onTap: () {
                                                    cubit.unSelectAllContacts();
                                                  },
                                                  child: CustomText(
                                                    text: "clear".tr(),
                                                    color: AppUI.errorColor,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                }),
                          ],
                        ),
                      ),
                      Container(
                        height: 5,
                        color: AppUI.backgroundColor,
                        width: double.infinity,
                      ),
                      BlocBuilder<AddEventCubit, AddEventState>(
                          buildWhen: (_, state) =>
                          state is ContactsLoadingState ||
                              state is ContactsLoadedState ||
                              state is ContactsErrorState ||
                              state is ContactsEmptyState,
                          builder: (context, state) {
                            if (state is ContactsLoadingState) {
                              return const LoadingWidget();
                            }
                            if (state is ContactsErrorState) {
                              return const ErrorFetchWidget();
                            }
                            if (state is ContactsEmptyState) {
                              return const EmptyWidget();
                            }
                            if (widget.event != null) {
                              // cubit.contactsCheck.clear();
                              // cubit.phones.clear();
                              // cubit.names.clear();
                              int i = 0;
                              for (var e in widget.event.visitors) {
                                cubit.contactsCheck.add(e.phone);
                                if (cubit.contacts
                                    .where((element) => element
                                    .displayName!
                                    .toLowerCase()
                                    .contains(cubit
                                    .searchContact
                                    .text
                                    .toLowerCase()))
                                    .toList()[0]
                                    .phones!
                                    .length ==
                                    1) {
                                  // cubit.phones.add(cubit.contacts
                                  //     .where((element) => element.displayName!
                                  //     .toLowerCase()
                                  //     .contains(cubit.searchContact.text
                                  //     .toLowerCase()))
                                  //     .toList()[i]
                                  //     .phones![0]
                                  //     .value!);
                                }else {

                                }
                                // cubit.names.add(cubit.contacts
                                //     .where((element) => element.displayName!
                                //     .toLowerCase()
                                //     .contains(cubit.searchContact.text
                                //     .toLowerCase()))
                                //     .toList()[i]
                                //     .displayName!);
                                i++;
                              }
                            }

                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl: "",
                                              width: 40,
                                              height: 40,
                                              placeholder: (context, url) =>
                                                  Image.asset(
                                                    "${AppUI.imgPath}logo.png",
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.fill,
                                                  ),
                                              errorWidget: (context, url,
                                                  error) =>
                                                  Image.asset(
                                                      "${AppUI.imgPath}logo.png",
                                                      width: 40,
                                                      height: 40,
                                                      fit: BoxFit.fill),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                CustomText(
                                                  text: cubit.contacts
                                                      .where((element) => element
                                                      .displayName!
                                                      .toLowerCase()
                                                      .contains(cubit
                                                      .searchContact
                                                      .text
                                                      .toLowerCase()))
                                                      .toList()[index]
                                                      .displayName ??
                                                      "",
                                                  color: AppUI.blackColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                if (cubit.contacts
                                                    .where((element) => element
                                                    .displayName!
                                                    .toLowerCase()
                                                    .contains(cubit
                                                    .searchContact
                                                    .text
                                                    .toLowerCase()))
                                                    .toList()[index]
                                                    .phones!
                                                    .length ==
                                                    1)
                                                  Text(
                                                    cubit.contacts
                                                        .where((element) => element
                                                        .displayName!
                                                        .toLowerCase()
                                                        .contains(cubit
                                                        .searchContact
                                                        .text
                                                        .toLowerCase()))
                                                        .toList()[index]
                                                        .phones![0]
                                                        .number!,
                                                    style: const TextStyle(
                                                      color: AppUI.blackColor,
                                                    ),
                                                    textDirection:
                                                    ui.TextDirection.ltr,
                                                  ),
                                              ],
                                            ),
                                            const Spacer(),
                                            BlocBuilder<AddEventCubit,
                                                AddEventState>(
                                                buildWhen: (_, state) =>
                                                state is ContactChangeState,
                                                builder: (context, snapshot) {
                                                  if (cubit.contacts
                                                      .where((element) => element
                                                      .displayName!
                                                      .toLowerCase()
                                                      .contains(cubit
                                                      .searchContact
                                                      .text
                                                      .toLowerCase()))
                                                      .toList()[index]
                                                      .phones!
                                                      .length ==
                                                      1) {
                                                    print('gvghvghvghvhg ${cubit.phones}');
                                                    return Checkbox(
                                                        value: cubit.phones.where((element) => element.contains(cubit
                                                            .contacts
                                                            .where((element) => element.displayName!.toLowerCase().contains(cubit
                                                            .searchContact
                                                            .text
                                                            .toLowerCase()))
                                                            .toList()[index].phones![0]
                                                            .number!)).isNotEmpty
                                                            ? true
                                                            : false,
                                                        onChanged: (v) {
                                                          cubit.setContactsCheck(
                                                              index,
                                                              cubit.contacts
                                                                  .where((element) => element
                                                                  .displayName!
                                                                  .toLowerCase()
                                                                  .contains(cubit
                                                                  .searchContact
                                                                  .text
                                                                  .toLowerCase()))
                                                                  .toList()[
                                                              index]
                                                                  .phones![0]
                                                                  .number!);
                                                          if (v!) {
                                                            cubit.names.add(cubit
                                                                .contacts
                                                                .where((element) => element
                                                                .displayName!
                                                                .toLowerCase()
                                                                .contains(cubit
                                                                .searchContact
                                                                .text
                                                                .toLowerCase()))
                                                                .toList()[
                                                            index]
                                                                .displayName ??
                                                                "");
                                                            cubit.phones.add(cubit
                                                                .contacts
                                                                .where((element) => element
                                                                .displayName!
                                                                .toLowerCase()
                                                                .contains(cubit
                                                                .searchContact
                                                                .text
                                                                .toLowerCase()))
                                                                .toList()[
                                                            index]
                                                                .phones!
                                                                .isEmpty
                                                                ? ""
                                                                : cubit.contacts
                                                                .where((element) => element
                                                                .displayName!
                                                                .toLowerCase()
                                                                .contains(
                                                                cubit.searchContact.text.toLowerCase()))
                                                                .toList()[index]
                                                                .phones![0]
                                                                .number!);
                                                          } else {
                                                            cubit.names.remove(cubit
                                                                .contacts
                                                                .where((element) => element
                                                                .displayName!
                                                                .toLowerCase()
                                                                .contains(cubit
                                                                .searchContact
                                                                .text
                                                                .toLowerCase()))
                                                                .toList()[
                                                            index]
                                                                .displayName ??
                                                                "");
                                                            cubit.phones.remove(cubit
                                                                .contacts
                                                                .where((element) => element
                                                                .displayName!
                                                                .toLowerCase()
                                                                .contains(cubit
                                                                .searchContact
                                                                .text
                                                                .toLowerCase()))
                                                                .toList()[
                                                            index]
                                                                .phones!
                                                                .isEmpty
                                                                ? ""
                                                                : cubit.contacts
                                                                .where((element) => element
                                                                .displayName!
                                                                .toLowerCase()
                                                                .contains(
                                                                cubit.searchContact.text.toLowerCase()))
                                                                .toList()[index]
                                                                .phones![0]
                                                                .number!);
                                                          }
                                                          print(cubit.names);
                                                          print(cubit.phones);
                                                        });
                                                  } else {
                                                    return const SizedBox(
                                                      width: 1,
                                                    );
                                                  }
                                                }),
                                          ],
                                        ),
                                        if (cubit.contacts
                                            .where((element) => element
                                            .displayName!
                                            .toLowerCase()
                                            .contains(cubit
                                            .searchContact.text
                                            .toLowerCase()))
                                            .toList()[index]
                                            .phones!
                                            .length >
                                            1)
                                          ListView.builder(
                                            physics:
                                            const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (BuildContext context,
                                                int index2) {
                                              return Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      const SizedBox(
                                                        width: 40,
                                                        height: 40,
                                                      ),
                                                      Text(
                                                        cubit.contacts
                                                            .where((element) => element
                                                            .displayName!
                                                            .toLowerCase()
                                                            .contains(cubit
                                                            .searchContact
                                                            .text
                                                            .toLowerCase()))
                                                            .toList()[index]
                                                            .phones![index2]
                                                            .number!,
                                                        style: const TextStyle(
                                                          color:
                                                          AppUI.blackColor,
                                                        ),
                                                        textDirection: ui
                                                            .TextDirection.ltr,
                                                      ),
                                                      const Spacer(),
                                                      BlocBuilder<AddEventCubit,
                                                          AddEventState>(
                                                          buildWhen: (_,
                                                              state) =>
                                                          state
                                                          is ContactChangeState,
                                                          builder: (context,
                                                              snapshot) {
                                                            return Checkbox(
                                                                value: cubit.phones.where((element) => element == cubit
                                                                    .contacts
                                                                    .where((element) => element.displayName!.toLowerCase().contains(cubit
                                                                    .searchContact
                                                                    .text
                                                                    .toLowerCase()))
                                                                    .toList()[
                                                                index]
                                                                    .phones![
                                                                index2]
                                                                    .number!).isNotEmpty
                                                                    ? true
                                                                    : false,
                                                                onChanged: (v) {
                                                                  cubit.setContactsCheck(
                                                                      index,
                                                                      cubit
                                                                          .contacts
                                                                          .where((element) => element.displayName!.toLowerCase().contains(cubit
                                                                          .searchContact
                                                                          .text
                                                                          .toLowerCase()))
                                                                          .toList()[
                                                                      index]
                                                                          .phones![
                                                                      index2]
                                                                          .number!);
                                                                  if (v!) {
                                                                    cubit.names.add(cubit
                                                                        .contacts
                                                                        .where((element) =>
                                                                        element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase()))
                                                                        .toList()[index]
                                                                        .displayName ??
                                                                        "");
                                                                    cubit.phones.add(cubit
                                                                        .contacts
                                                                        .where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text
                                                                        .toLowerCase()))
                                                                        .toList()[
                                                                    index]
                                                                        .phones!
                                                                        .isEmpty
                                                                        ? ""
                                                                        : cubit
                                                                        .contacts
                                                                        .where((element) =>
                                                                        element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase()))
                                                                        .toList()[index]
                                                                        .phones![index2]
                                                                        .number!);
                                                                  } else {
                                                                    cubit.names.remove(cubit
                                                                        .contacts
                                                                        .where((element) =>
                                                                        element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase()))
                                                                        .toList()[index]
                                                                        .displayName ??
                                                                        "");
                                                                    cubit.phones.remove(cubit
                                                                        .contacts
                                                                        .where((element) => element.displayName!.toLowerCase().contains(cubit.searchContact.text
                                                                        .toLowerCase()))
                                                                        .toList()[
                                                                    index]
                                                                        .phones!
                                                                        .isEmpty
                                                                        ? ""
                                                                        : cubit
                                                                        .contacts
                                                                        .where((element) =>
                                                                        element.displayName!.toLowerCase().contains(cubit.searchContact.text.toLowerCase()))
                                                                        .toList()[index]
                                                                        .phones![index2]
                                                                        .number!);
                                                                  }
                                                                });
                                                          }),
                                                    ],
                                                  )
                                                ],
                                              );
                                            },
                                            itemCount: cubit.contacts
                                                .where((element) => element
                                                .displayName!
                                                .toLowerCase()
                                                .contains(cubit
                                                .searchContact.text
                                                .toLowerCase()))
                                                .toList()[index]
                                                .phones!
                                                .length,
                                          ),
                                      ],
                                    );
                                  },
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const Divider();
                                  },
                                  itemCount: cubit.contacts
                                      .where((element) => element.displayName!
                                      .toLowerCase()
                                      .contains(cubit.searchContact.text
                                      .toLowerCase()))
                                      .length,
                                ),
                              ),
                            );
                          }),
                      //const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CustomButton(
                          text: 'done'.tr(),
                          onPressed: () async {
                              Navigator.of(context).pop();
                              await cubit.addVisitorsToEvent(widget.event.id, scaffoldKey.currentContext,from: widget.type == "draft".tr()?'draft':"");
                              try {
                                widget.event = eventCubit.draftEventsModel!
                                    .data
                                    .where((element) =>
                                element.id == widget.event.id)
                                    .first;
                              }catch(e){
                                try{
                                  widget.event = eventCubit.activeEventsModel!
                                      .data
                                      .where((element) =>
                                  element.id == widget.event.id)
                                      .first;
                                }catch(e){
                                  widget.event = eventCubit.waitEventsModel!
                                      .data
                                      .where((element) =>
                                  element.id == widget.event.id)
                                      .first;
                                }
                              }
                              eventCubit.emit(DraftEventsLoadedState());
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if(cubit.names.isNotEmpty) {
      cubit.names.clear();
      cubit.phones.clear();
    }
  }

}