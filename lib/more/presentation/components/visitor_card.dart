import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/event/models/events_model.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import 'package:expert_events/event/presentation/controller/guards/guards_cubit.dart';

import '../../../event/presentation/controller/events/events_cubit.dart';

class VisitorCard extends StatefulWidget {
  final List<dynamic> visitors;
  final bool isGuard;
  final bool checkbox;

  const VisitorCard({Key? key, required this.visitors, this.isGuard = false,this.checkbox = false})
      : super(key: key);


  @override
  State<VisitorCard> createState() => _VisitorCardScreenState();
}
class _VisitorCardScreenState extends State<VisitorCard> {
  late final guardsCubit = GuardsCubit.get(context);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(widget.visitors.length, (index) {
        return Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: widget.visitors[index].name!,
                      color: AppUI.blackColor,
                      fontWeight: FontWeight.bold,),
                    const SizedBox(height: 5,),
                    Text(widget.visitors[index].phone!
                      ,style: const TextStyle(
                        color: AppUI.blackColor
                      ),textDirection: ui.TextDirection.ltr),
                  ],
                ),
                const Spacer(),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      if(!widget.isGuard)
                        CustomText(
                          text: widget.visitors[index].status == "1" ? "waitApprove".tr() : "", color: Colors.orange,),
                      if(!widget.isGuard)
                        CustomText(text: widget.visitors[index].status == "2" ? "acceptInvitation".tr() : "",
                          color: AppUI.activeColor,),
                      if(!widget.isGuard)
                        CustomText(text: widget.visitors[index].status == "3" ? "cancelInvitation".tr() : "",
                          color: AppUI.errorColor,),
                      if(!widget.isGuard)
                        CustomText(text: widget.visitors[index].status == "4" ? "attendInvitation".tr() : "",
                          color: AppUI.activeColor,),
                      if(widget.isGuard)
                        Checkbox(value: guardsCubit.guardsCheck[index],
                            onChanged: (v) {
                              if (v!) {
                                guardsCubit.selectedGuardsIds.add(
                                    widget.visitors[index].id);
                              } else {
                                guardsCubit.selectedGuardsIds.remove(
                                    widget.visitors[index].id);
                              }
                              guardsCubit.setGuardsCheck(index, v);
                            }),
                      if(!widget.isGuard && widget.checkbox)
                        Checkbox(value: guardsCubit.visitorsCheck[index],
                            onChanged: (v) {
                              if (v!) {
                                guardsCubit.selectedvisitorsIds.add(
                                    widget.visitors[index].id);
                              } else {
                                guardsCubit.selectedvisitorsIds.remove(
                                    widget.visitors[index].id);
                              }
                              guardsCubit.setvisitorsCheck(index, v);
                              setState(() { });
                            }),
                    ],
                  ),
                ),
              ],
            ),
            const Divider()
          ],
        );
      }),
    );
  }
}
