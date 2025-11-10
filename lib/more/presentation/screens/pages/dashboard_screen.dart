import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/more/presentation/controller/more_cubit.dart';
import 'package:expert_events/more/presentation/controller/more_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../../../layout/presentation/controller/bottom_nav_cubit.dart';
import '../../../../layout/presentation/screens/layout_screen.dart';
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final cubit = MoreCubit.get(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.getDashboard();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          BlocBuilder<MoreCubit,MoreStates>(
            buildWhen: (_,state) => state is DashboardLoadingState || state is DashboardLoadedState || state is DashboardErrorState ,
            builder: (context, state) {
              if(state is DashboardLoadingState){
                return const LoadingWidget();
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customAppBar(title: "dashboard".tr(),backgroundColor: Colors.transparent),
                      const SizedBox(height: 20,),
                      CustomText(text: "eventsStatus".tr(),color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.bold,),
                      const SizedBox(height: 5,),
                      CustomCard(
                        elevation: 0,
                        child: ResponsiveGridList(
                          shrinkWrap: true,
                          horizontalGridSpacing: 10, // Horizontal space between grid items
                          verticalGridSpacing: 20, // Vertical space between grid items
                          horizontalGridMargin: 10, // Horizontal space around the grid
                          verticalGridMargin: 10, // Vertical space around the grid
                          minItemWidth: 300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                          minItemsPerRow: 3, // The minimum items to show in a single row. Takes precedence over minItemWidth
                          maxItemsPerRow: 7, // The maximum items to show in a single row. Can be useful on large screens
                          listViewBuilderOptions: ListViewBuilderOptions(), // Options that are getting passed to the ListView.builder() function
                          children: [
                            InkWell(
                              onTap: (){
                                BottomNavCubit.get(context).menuOpen = false;
                                BottomNavCubit.get(context).scale = 1.0;
                                BottomNavCubit.get(context).tranX = 0;
                                BottomNavCubit.get(context).tranY = 0;
                                BottomNavCubit.get(context).menuOpen = false;
                                BottomNavCubit.get(context).setCurrentIndex(2);
                                BottomNavCubit.get(context).initIndex = 3;
                                AppUtil.removeUntilNavigator(context, const LayoutScreen());
                              },
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 8.0,
                                    percent: cubit.dashboardModel!.activeevent!.toDouble() / cubit.dashboardModel!.allevents!.toInt(),
                                    center: const CircleAvatar(
                                      backgroundColor: Color(0xffEDEBF7),
                                      radius: 12,
                                      child: Icon(Icons.book,color: AppUI.secondColor,size: 14),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: AppUI.secondColor,
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "activeEvents".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "${cubit.dashboardModel!.activeevent} ${"Event".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                BottomNavCubit.get(context).menuOpen = false;
                                BottomNavCubit.get(context).scale = 1.0;
                                BottomNavCubit.get(context).tranX = 0;
                                BottomNavCubit.get(context).tranY = 0;
                                BottomNavCubit.get(context).menuOpen = false;
                                BottomNavCubit.get(context).setCurrentIndex(2);
                                BottomNavCubit.get(context).initIndex = 2;
                                AppUtil.removeUntilNavigator(context, const LayoutScreen());
                              },
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 8.0,
                                    percent: cubit.dashboardModel!.pendingevent!.toDouble() / cubit.dashboardModel!.allevents!.toInt(),
                                    center: const CircleAvatar(
                                      backgroundColor: Color(0xffEDEBF7),
                                      radius: 12,
                                      child: Icon(Icons.book,color: const Color(0xffFEBD4C),size: 14),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor:  const Color(0xffFEBD4C),
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "pending".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "${cubit.dashboardModel!.pendingevent} ${"Event".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                InkWell(
                                  onTap: (){
                                    BottomNavCubit.get(context).menuOpen = false;
                                    BottomNavCubit.get(context).scale = 1.0;
                                    BottomNavCubit.get(context).tranX = 0;
                                    BottomNavCubit.get(context).tranY = 0;
                                    BottomNavCubit.get(context).menuOpen = false;
                                    BottomNavCubit.get(context).setCurrentIndex(2);
                                    BottomNavCubit.get(context).initIndex = 4;
                                    AppUtil.removeUntilNavigator(context, const LayoutScreen());
                                  },
                                  child: CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 8.0,
                                    percent: cubit.dashboardModel!.finishevent!.toDouble() / cubit.dashboardModel!.allevents!.toInt(),
                                    center: const CircleAvatar(
                                      backgroundColor: Color(0xffEDEBF7),
                                      radius: 12,
                                      child: Icon(Icons.book,color: AppUI.activeColor,size: 14),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: AppUI.activeColor,
                                  ),
                                ),
                                const SizedBox(height: 5,),
                                CustomText(text: "finishedEvents".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                                const SizedBox(height: 5,),
                                CustomText(text: "${cubit.dashboardModel!.finishevent} ${"Event".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                              ],
                            ),
                            InkWell(
                              onTap: (){
                                BottomNavCubit.get(context).menuOpen = false;
                                BottomNavCubit.get(context).scale = 1.0;
                                BottomNavCubit.get(context).tranX = 0;
                                BottomNavCubit.get(context).tranY = 0;
                                BottomNavCubit.get(context).menuOpen = false;
                                BottomNavCubit.get(context).setCurrentIndex(2);
                                BottomNavCubit.get(context).initIndex = 1;
                                AppUtil.removeUntilNavigator(context, const LayoutScreen());
                              },
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 8.0,
                                    percent: cubit.dashboardModel!.cancelevent!.toDouble() / cubit.dashboardModel!.allevents!.toInt(),
                                    center: const CircleAvatar(
                                      backgroundColor: Color(0xffEDEBF7),
                                      radius: 12,
                                      child: Icon(Icons.book,color: AppUI.errorColor,size: 14),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: AppUI.errorColor,
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "canceledEvents".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "${cubit.dashboardModel!.cancelevent} ${"Event".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                                ],
                              ),
                            ),

                            InkWell(
                              onTap: (){
                                BottomNavCubit.get(context).menuOpen = false;
                                BottomNavCubit.get(context).scale = 1.0;
                                BottomNavCubit.get(context).tranX = 0;
                                BottomNavCubit.get(context).tranY = 0;
                                BottomNavCubit.get(context).menuOpen = false;
                                BottomNavCubit.get(context).setCurrentIndex(2);
                                BottomNavCubit.get(context).initIndex = 0;
                                AppUtil.removeUntilNavigator(context, const LayoutScreen());
                              },
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 8.0,
                                    percent: cubit.dashboardModel!.draftevent!.toDouble() / cubit.dashboardModel!.allevents!.toInt(),
                                    center: const CircleAvatar(
                                      backgroundColor: Color(0xffEDEBF7),
                                      radius: 12,
                                      child: Icon(Icons.book,color: AppUI.bottomBarColor,size: 14),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: AppUI.bottomBarColor,
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "draftEvents".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "${cubit.dashboardModel!.draftevent} ${"Event".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                                ],
                              ),
                            ),

                          ]
                        ),


                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child:
                        //       Column(
                        //         children: [
                        //           CircularPercentIndicator(
                        //             radius: 60.0,
                        //             lineWidth: 8.0,
                        //             percent: 0.60,
                        //             center: const CircleAvatar(
                        //               backgroundColor: Color(0xffEDEBF7),
                        //               radius: 12,
                        //               child: Icon(Icons.person,color: AppUI.secondColor,size: 14),
                        //             ),
                        //             circularStrokeCap: CircularStrokeCap.round,
                        //             backgroundColor: const Color(0xffEDEBF7),
                        //             progressColor: AppUI.secondColor,
                        //           ),
                        //           const SizedBox(height: 5,),
                        //           CustomText(text: "activeEvents".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                        //           const SizedBox(height: 5,),
                        //           CustomText(text: "50 ${"users".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                        //         ],
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child:
                        //       Column(
                        //         children: [
                        //           CircularPercentIndicator(
                        //             radius: 60.0,
                        //             lineWidth: 8.0,
                        //             percent: 0.60,
                        //             center: const CircleAvatar(
                        //               backgroundColor: Color(0xffEDEBF7),
                        //               radius: 12,
                        //               child: Icon(Icons.person,color: AppUI.errorColor,size: 14),
                        //             ),
                        //             circularStrokeCap: CircularStrokeCap.round,
                        //             backgroundColor: const Color(0xffEDEBF7),
                        //             progressColor: AppUI.errorColor,
                        //           ),
                        //           const SizedBox(height: 5,),
                        //           CustomText(text: "waitPay".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                        //           const SizedBox(height: 5,),
                        //           CustomText(text: "15 ${"users".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                        //         ],
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child:
                        //       Column(
                        //         children: [
                        //           CircularPercentIndicator(
                        //             radius: 60.0,
                        //             lineWidth: 8.0,
                        //             percent: 0.60,
                        //             center: const CircleAvatar(
                        //               backgroundColor: Color(0xffEDEBF7),
                        //               radius: 12,
                        //               child: Icon(Icons.person,color: Color(0xffFEBD4C),size: 14),
                        //             ),
                        //             circularStrokeCap: CircularStrokeCap.round,
                        //             backgroundColor: const Color(0xffEDEBF7),
                        //             progressColor: const Color(0xffFEBD4C),
                        //           ),
                        //           const SizedBox(height: 5,),
                        //           CustomText(text: "finishedEvents".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                        //           const SizedBox(height: 5,),
                        //           CustomText(text: "10 ${"users".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                        //         ],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ),
                       const SizedBox(height: 20,),
                      CustomText(text: "visitorsStatus".tr(),color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.bold,),
                      const SizedBox(height: 5,),
                      CustomCard(
                        elevation: 0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 8.0,
                                    percent: cubit.dashboardModel!.attendvisitor!.toDouble() / cubit.dashboardModel!.allvisitor!.toInt(),
                                    center: const CircleAvatar(
                                      backgroundColor: Color(0xffEDEBF7),
                                      radius: 12,
                                      child: Icon(Icons.person,color: AppUI.secondColor,size: 14),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: AppUI.secondColor,
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "attendInvitation".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "${cubit.dashboardModel!.attendvisitor} ${"visitor".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 8.0,
                                    percent: cubit.dashboardModel!.cancelvisitor!.toDouble() / cubit.dashboardModel!.allvisitor!.toInt(),
                                    center: const CircleAvatar(
                                      backgroundColor: Color(0xffEDEBF7),
                                      radius: 12,
                                      child: Icon(Icons.person,color: AppUI.errorColor,size: 14),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: AppUI.errorColor,
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "cancelInvitation".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "${cubit.dashboardModel!.cancelvisitor} ${"visitor".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 50.0,
                                    lineWidth: 8.0,
                                    percent: cubit.dashboardModel!.waitingvisitor!.toDouble() / cubit.dashboardModel!.allvisitor!.toInt(),
                                    center: const CircleAvatar(
                                      backgroundColor: Color(0xffEDEBF7),
                                      radius: 12,
                                      child: Icon(Icons.person,color: Color(0xffFEBD4C),size: 14),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: const Color(0xffFEBD4C),
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "waitingReply".tr(),color: AppUI.blackColor,fontSize: 12,fontWeight: FontWeight.bold,),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "${cubit.dashboardModel!.waitingvisitor} ${"visitor".tr()}",color: const Color(0xff8A8D9F),fontSize: 12,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CustomText(text: "eventsSummary".tr(),color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.bold,),
                      const SizedBox(height: 5,),
                      CustomCard(
                        elevation: 0,
                        child: ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(cubit.dashboardModel!.eventsSummary!.length, (index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(text: cubit.dashboardModel!.eventsSummary![index].name!,fontSize: 16,color: AppUI.blackColor,),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person,color: AppUI.secondColor,size: 18,),
                                        const SizedBox(width: 10,),
                                        CustomText(text: "${cubit.dashboardModel!.eventsSummary![index].invites!} ${"invites".tr()}",color: AppUI.bottomBarColor,)
                                      ],
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        SvgPicture.asset("${AppUI.iconPath}comment.svg",color: AppUI.buttonColor,),
                                        const SizedBox(width: 10,),
                                        CustomText(text: "${cubit.dashboardModel!.eventsSummary![index].comments!} ${"comments".tr()}",color: AppUI.bottomBarColor,)
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider()
                              ],
                            );
                          }),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }
}
