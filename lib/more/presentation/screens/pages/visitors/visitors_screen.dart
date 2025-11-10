import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/core/app_util.dart';
import 'package:expert_events/more/presentation/controller/more_cubit.dart';
import 'package:flutter/material.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import '../../../../../layout/presentation/controller/bottom_nav_cubit.dart';
import 'package:expert_events/more/presentation/screens/pages/visitors/taps/accept_tap.dart';
import 'package:expert_events/more/presentation/screens/pages/visitors/taps/attend_tap.dart';
import 'package:expert_events/more/presentation/screens/pages/visitors/taps/pending_tap.dart';
import 'package:expert_events/more/presentation/screens/pages/visitors/taps/reject_tap.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({Key? key}) : super(key: key);

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> with SingleTickerProviderStateMixin{
  late final MoreCubit cubit;
  late final TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = MoreCubit.get(context);
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      BottomNavCubit.get(context).initVisitorIndex = tabController.index;
    });
  }
  @override
  Widget build(BuildContext context) {
    final cubit = MoreCubit.get(context);

    return Scaffold(
      body: Column(
        children: [
          customAppBar(title: "visitors".tr()),
          Container(
            color: AppUI.whiteColor,
            padding: const EdgeInsets.only(left: 16,right: 16,bottom: 10),
            child: CustomInput(controller: cubit.filterController,hint: "search".tr(),prefixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_drop_down)), textInputType: TextInputType.text,readOnly: true,onTap: (){
              AppUtil.dialog2(context, "eventType".tr(), [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(cubit.eventsModel!.data.length, (index) {
                    return InkWell(
                      onTap: (){
                        cubit.selectedEvent = cubit.eventsModel!.data[index];
                        cubit.filterController.text = cubit.eventsModel!.data[index].name;
                        if(BottomNavCubit.get(context).initVisitorIndex == 1){
                          cubit.getVisitors('pending-visitors',filter: 'event_id=${cubit.eventsModel!.data[index].id}');
                        }
                        if(BottomNavCubit.get(context).initVisitorIndex == 3){
                          cubit.getVisitors('reject-visitors',filter: 'event_id=${cubit.eventsModel!.data[index].id}');
                        }
                        if(BottomNavCubit.get(context).initVisitorIndex == 2){
                          cubit.getVisitors('accept-visitors',filter: 'event_id=${cubit.eventsModel!.data[index].id}');
                        }
                        if(BottomNavCubit.get(context).initVisitorIndex == 0){
                          cubit.getVisitors('attend-visitors',filter: 'event_id=${cubit.eventsModel!.data[index].id}');
                        }
                        Navigator.of(context,rootNavigator: true).pop();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(text: cubit.eventsModel!.data[index].name,fontWeight: FontWeight.w600,color: AppUI.bottomBarColor,),
                          if(index + 1 != cubit.eventsModel!.data.length)
                            const Divider(),
                        ],
                      ),
                    );
                  }),
                )
              ]);
            },),
          ),
          Expanded(
            child: DefaultTabController(
              length: 4,
              initialIndex:  0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    controller: tabController,
                      indicatorWeight: 2,
                      indicatorColor: AppUI.mainColor,
                      labelColor: AppUI.mainColor,
                      unselectedLabelColor: AppUI.disableColor,
                      // isScrollable: true,
                      tabs: <Widget>[
                        // Tab(child: Text("allVisitors".tr(),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.center),),
                        Tab(child: Text("pending".tr(),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.center),),
                        Tab(child: Text("reject".tr(),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.center),),
                        Tab(child: Text("accept".tr(),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.center),),
                        Tab(child: Text("attend".tr(),style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.center),),

                      ]
                  ),

                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                        children: const <Widget> [
                          // AllVisitorsTap(),
                          PendingTap(),
                          RejectTap(),
                          AcceptTap(),
                          AttendTap(),
                        ]),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
