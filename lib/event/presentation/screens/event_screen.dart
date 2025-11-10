import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';
import '../../../add_event/presentation/controller/add_event_cubit.dart';
import '../../../core/app_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../../../layout/presentation/controller/bottom_nav_cubit.dart';
import '../controller/events/events_cubit.dart';
import '../controller/events/events_states.dart';
import 'taps/active_tap.dart';
import 'taps/cancel_tap.dart';
import 'taps/draft_tap.dart';
import 'taps/finished_tap.dart';
import 'taps/wait_approve_tap.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  EventScreenState createState() => EventScreenState();
}

class EventScreenState extends State<EventScreen>
    with SingleTickerProviderStateMixin {
  late final EventsCubit cubit;
  late final AddEventCubit eventCubit;
  late final TabController tabController;
  @override
  void initState() {
    super.initState();
    cubit = EventsCubit.get(context);
    eventCubit = AddEventCubit.get(context);
    tabController = TabController(length: 5, vsync: this);
    tabController.addListener(() {
      BottomNavCubit.get(context).initIndex = tabController.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            customAppBar(title: "events".tr()),
            Container(
              color: AppUI.whiteColor,
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                      flex: 8,
                      child: CustomInput(
                        controller: cubit.name,
                        hint: "search".tr(),
                        prefixIcon: IconButton(
                            onPressed: () {}, icon: const Icon(Icons.search)),
                        textInputType: TextInputType.text,
                        onChange: (v) {
                          if (BottomNavCubit.get(context).initIndex == 0) {
                            cubit.getDraftEvents(filter: cubit.getFilterPath());
                          }
                          if (BottomNavCubit.get(context).initIndex == 1) {
                            cubit.getCancelEvents(
                                filter: cubit.getFilterPath());
                          }
                          if (BottomNavCubit.get(context).initIndex == 2) {
                            cubit.getWaitEvents(filter: cubit.getFilterPath());
                          }
                          if (BottomNavCubit.get(context).initIndex == 3) {
                            cubit.getActiveEvents(
                                filter: cubit.getFilterPath());
                          }
                          if (BottomNavCubit.get(context).initIndex == 4) {
                            cubit.getFinishEvents(
                                filter: cubit.getFilterPath());
                          }
                        },
                      )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: InkWell(
                          onTap: () {
                            filter(context);
                          },
                          child:
                              SvgPicture.asset("${AppUI.iconPath}filter.svg")))
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).padding.top + 120),
          child: DefaultTabController(
            length: 5,
            initialIndex: BottomNavCubit.get(context).initIndex,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                    controller: tabController,
                    indicatorWeight: 2,
                    indicatorColor: AppUI.mainColor,
                    labelColor: AppUI.mainColor,
                    unselectedLabelColor: AppUI.disableColor,
                    isScrollable: true,
                    tabs: <Widget>[
                      Tab(
                        child: Text("draft".tr(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                      Tab(
                        child: Text("canceled".tr(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                      Tab(
                        child: Text("waitApprove".tr(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                      Tab(
                        child: Text("active".tr(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                      Tab(
                        child: Text("finished".tr(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                    ]),
                Expanded(
                  child: TabBarView(
                      controller: tabController,
                      children: const <Widget>[
                        DraftTap(),
                        CancelTap(),
                        WaitApproveTap(),
                        ActiveTap(),
                        FinishedTap(),
                      ]),
                ),
                const SizedBox(
                  height: 60,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  filter(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        builder: (context) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: AppUI.whiteColor,
            ),
            height: AppUtil.responsiveHeight(context) * 0.75,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      width: 30,
                    ),
                    CustomText(
                      text: "filter".tr(),
                      color: AppUI.blackColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppUI.blackColor,
                        ))
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      CustomText(
                        text: "location".tr(),
                        color: AppUI.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      CustomInput(
                          controller: cubit.location,
                          fillColor: AppUI.inputColor,
                          textInputType: TextInputType.text),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomText(
                        text: "eventType".tr(),
                        color: AppUI.blackColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      BlocBuilder<EventsCubit, EventsStates>(
                          buildWhen: (_, state) => state is TypesChangeState,
                          builder: (context, snapshot) {
                            return SizedBox(
                              height: AppUtil.responsiveHeight(context) * 0.3,
                              child: ResponsiveGridList(
                                shrinkWrap: true,
                                horizontalGridSpacing:
                                    10, // Horizontal space between grid items
                                verticalGridSpacing:
                                    10, // Vertical space between grid items
                                horizontalGridMargin:
                                    10, // Horizontal space around the grid
                                verticalGridMargin:
                                    10, // Vertical space around the grid
                                minItemWidth:
                                    300, // The minimum item width (can be smaller, if the layout constraints are smaller)
                                minItemsPerRow:
                                    3, // The minimum items to show in a single row. Takes precedence over minItemWidth
                                maxItemsPerRow:
                                    7, // The maximum items to show in a single row. Can be useful on large screens
                                listViewBuilderOptions:
                                    ListViewBuilderOptions(), // Options that are getting passed to the ListView.builder() function
                                children: List.generate(
                                    eventCubit.eventTypesModel!.types.length,
                                    (index) {
                                  return CustomCard(
                                    onTap: () {
                                      if (cubit.selectedType == null) {
                                        cubit.selectedType = eventCubit
                                            .eventTypesModel!.types[index];
                                      } else {
                                        if (cubit.selectedType ==
                                            eventCubit.eventTypesModel!
                                                .types[index]) {
                                          cubit.selectedType = null;
                                        } else {
                                          cubit.selectedType = eventCubit
                                              .eventTypesModel!.types[index];
                                        }
                                      }
                                      cubit.emit(TypesChangeState());
                                    },
                                    elevation: 0,
                                    radius: 20,
                                    color: cubit.selectedType ==
                                            eventCubit
                                                .eventTypesModel!.types[index]
                                        ? AppUI.secondColor
                                        : AppUI.inputColor,
                                    child: CustomText(
                                      text: eventCubit
                                          .eventTypesModel!.types[index].name,
                                      textAlign: TextAlign.center,
                                      color: cubit.selectedType ==
                                              eventCubit
                                                  .eventTypesModel!.types[index]
                                          ? AppUI.whiteColor
                                          : AppUI.bottomBarColor,
                                      fontSize: 16,
                                    ),
                                  );
                                }), // The list of widgets in the list
                              ),
                            );
                          })
                    ],
                  ),
                ),
                const Spacer(),
                CustomButton(
                  text: "apply".tr(),
                  onPressed: () {
                    if (BottomNavCubit.get(context).initIndex == 0) {
                      cubit.getDraftEvents(filter: cubit.getFilterPath());
                    }
                    if (BottomNavCubit.get(context).initIndex == 1) {
                      cubit.getCancelEvents(filter: cubit.getFilterPath());
                    }
                    if (BottomNavCubit.get(context).initIndex == 2) {
                      cubit.getWaitEvents(filter: cubit.getFilterPath());
                    }
                    if (BottomNavCubit.get(context).initIndex == 3) {
                      cubit.getActiveEvents(filter: cubit.getFilterPath());
                    }
                    if (BottomNavCubit.get(context).initIndex == 4) {
                      cubit.getFinishEvents(filter: cubit.getFilterPath());
                    }
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        });
  }
}
