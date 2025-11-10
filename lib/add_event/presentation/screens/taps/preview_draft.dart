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
import '../../../../more/presentation/screens/pages/packages/package_screen.dart';
import '../../controller/add_event_cubit.dart';
import '../../controller/add_event_states.dart';
class PreviewDraft extends StatefulWidget {
  final int? event;
  final int? countvisitor;
  const PreviewDraft({Key? key, this.event,this.countvisitor}) : super(key: key);
  @override
  State<PreviewDraft> createState() => _PreviewDraftState();
}

class _PreviewDraftState extends State<PreviewDraft> {
  @override
  Widget build(BuildContext context) {
    final cubit = AddEventCubit.get(context);
    return Scaffold(
      body: Stack(
          children: [
            Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
            Column(
                children: [
                  customAppBar(title: "preview".tr(),backgroundColor: Colors.transparent,),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20,),
                          CustomText(text: "${"Your Send".tr()} ${widget.countvisitor.toString()}  ${"Invitaion".tr()}", color: AppUI.blackColor,fontSize: 20,fontWeight: FontWeight.w600,),
                          const SizedBox(height: 20,),
                          CustomText(text: "${"You Have".tr()} ${cubit.wallet.toString()} ${"invitation from your wallet".tr()}", color: AppUI.blackColor,fontSize: 15,),
                          const SizedBox(height: 25,),
                          Row(
                            children: [
                              Expanded(
                                child: BlocBuilder<AddEventCubit,AddEventState>(
                                    buildWhen: (_,state) => state is PayLoadingState || state is PayLoadedState,
                                    builder: (context, state) {
                                      if(state is PayLoadingState){
                                        return const LoadingWidget();
                                      }
                                        return CustomButton(text: "Pay".tr(),onPressed: (){
                                          cubit.eventId = widget.event;
                                          cubit.pay(context,type: "draft");
                                        },);
                                    }
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
          ]
      ),
    );
  }
}