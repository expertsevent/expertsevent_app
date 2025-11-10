import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/invitations/presentation/controller/invitations_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import 'package:expert_events/add_event/presentation/controller/add_event_cubit.dart';
import '../../../core/app_util.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import 'package:expert_events/invitations/presentation/controller/invitations_cubit.dart';
import 'taps/accepted_tap.dart';
import 'taps/rejected_tap.dart';
import 'taps/upcoming_tap.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({Key? key}) : super(key: key);

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  late final cubit = InvitationsCubit.get(context);
  late final eventCubit = AddEventCubit.get(context);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            customAppBar(title: "invitations".tr()),
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
                          cubit.getInvitations('',
                              filter: cubit.getFilterPath());
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
            length: 3,
            initialIndex: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TabBar(
                    indicatorWeight: 2,
                    indicatorColor: AppUI.mainColor,
                    labelColor: AppUI.mainColor,
                    unselectedLabelColor: AppUI.disableColor,
                    tabs: <Widget>[
                      Tab(
                        child: Text("upComing".tr(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                      Tab(
                        child: Text("accepted".tr(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                      Tab(
                        child: Text("rejected".tr(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center),
                      ),
                    ]),
                const Expanded(
                  child: TabBarView(children: <Widget>[
                    UpComingTap(),
                    AcceptedTap(),
                    RejectedTap(),
                  ]),
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
                      BlocBuilder<InvitationsCubit, InvitationsStates>(
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
                    cubit.getInvitations(cubit.endPoint,
                        filter: cubit.getFilterPath());
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
