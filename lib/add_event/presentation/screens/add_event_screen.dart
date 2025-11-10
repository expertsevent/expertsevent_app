import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/add_event/presentation/screens/taps/design.dart';
import 'package:expert_events/core/app_util.dart';
import 'package:expert_events/event/models/events_model.dart';
import 'package:expert_events/layout/presentation/screens/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import '../controller/add_event_cubit.dart';
import '../controller/add_event_states.dart';
import 'taps/event_info/event_info.dart';
import 'taps/finish.dart';
import 'taps/payment.dart';
import 'taps/preview.dart';

class AddEventsScreen extends StatefulWidget {
  final Event? event;
  const AddEventsScreen({Key? key, this.event}) : super(key: key);

  @override
  State<AddEventsScreen> createState() => _AddEventsScreenState();
}

class _AddEventsScreenState extends State<AddEventsScreen> {
  late final cubit = AddEventCubit.get(context);

  @override
  void initState() {
    super.initState();
    cubit.pageIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (bool value) async {
        AppUtil.removeUntilNavigator(context, const LayoutScreen());
      },
      child: Scaffold(
        key: cubit.scaffoldKey,
        body: BlocBuilder<AddEventCubit, AddEventState>(
            buildWhen: (_, state) => state is PageChangeState,
            builder: (context, state) {
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
                        title: widget.event == null ? "createEvent".tr() : "Edit Event".tr(),
                        backgroundColor: Colors.transparent,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppUI.whiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: CircleAvatar(
                                        backgroundColor: AppUI.mainColor,
                                        child: SvgPicture.asset(
                                            "${AppUI.iconPath}cal.svg")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                CustomText(
                                  text: "eventInfo".tr(),
                                  fontSize: 11,
                                  color: AppUI.mainColor,
                                )
                              ],
                            ),
                            const CustomText(text: "---------\n"),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppUI.whiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: CircleAvatar(
                                        backgroundColor: cubit.pageIndex >= 1
                                            ? AppUI.mainColor
                                            : AppUI.backgroundColor,
                                        child: SvgPicture.asset(
                                            "${AppUI.iconPath}gallary.svg")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                CustomText(
                                  text: "design".tr(),
                                  fontSize: 11,
                                  color: cubit.pageIndex >= 1
                                      ? AppUI.mainColor
                                      : AppUI.bottomBarColor,
                                )
                              ],
                            ),
                            const CustomText(text: "---------\n"),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppUI.whiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: CircleAvatar(
                                        backgroundColor: cubit.pageIndex >= 2
                                            ? AppUI.mainColor
                                            : AppUI.backgroundColor,
                                        child: SvgPicture.asset(
                                            "${AppUI.iconPath}preview.svg")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                CustomText(
                                  text: "preview".tr(),
                                  fontSize: 11,
                                  color: cubit.pageIndex >= 2
                                      ? AppUI.mainColor
                                      : AppUI.bottomBarColor,
                                )
                              ],
                            ),
                            const CustomText(text: "---------\n"),
                            if (cubit.show)
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppUI.whiteColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CircleAvatar(
                                          backgroundColor: cubit.pageIndex >= 3
                                              ? AppUI.mainColor
                                              : AppUI.backgroundColor,
                                          child: SvgPicture.asset(
                                              "${AppUI.iconPath}payment.svg")),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                  CustomText(
                                    text: "payment".tr(),
                                    fontSize: 11,
                                    color: cubit.pageIndex >= 3
                                        ? AppUI.mainColor
                                        : AppUI.bottomBarColor,
                                  )
                                ],
                              ),
                            if (cubit.show)
                              const CustomText(text: "---------\n"),
                            Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: AppUI.whiteColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: CircleAvatar(
                                        backgroundColor: cubit.show
                                            ? cubit.pageIndex == 4
                                                ? AppUI.mainColor
                                                : AppUI.backgroundColor
                                            : cubit.pageIndex == 2
                                                ? AppUI.mainColor
                                                : AppUI.backgroundColor,
                                        child: SvgPicture.asset(
                                            "${AppUI.iconPath}check.svg")),
                                  ),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                CustomText(
                                  text: "finish".tr(),
                                  fontSize: 11,
                                  color: cubit.show
                                      ? cubit.pageIndex == 4
                                          ? AppUI.mainColor
                                          : AppUI.bottomBarColor
                                      : cubit.pageIndex == 3
                                          ? AppUI.mainColor
                                          : AppUI.disableColor,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (cubit.pageIndex == 0)
                        Expanded(child: EventInfo(event: widget.event)),
                      if (cubit.pageIndex == 1)
                        Expanded(child: Design(event: widget.event)),
                      if (cubit.pageIndex == 2)
                        Expanded(child: Preview(event: widget.event)),
                      if (cubit.show)
                        if (cubit.pageIndex == 3)
                          const Expanded(child: Payment()),
                      if (cubit.show)
                        if (cubit.pageIndex == 4)
                          const Expanded(child: Finish())
                        else
                          const SizedBox()
                      else if (cubit.pageIndex == 4)
                        const Expanded(child: Finish())
                    ],
                  )
                ],
              );
            }),
      ),
    );
  }
}
