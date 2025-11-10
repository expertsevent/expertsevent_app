import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/core/app_util.dart';
import 'package:expert_events/home/presentation/controller/home_cubit.dart';
import 'package:expert_events/home/presentation/controller/home_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late final cubit = HomeCubit.get(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.notification();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Column(
            children: [
              customAppBar(title: 'notification'.tr(),backgroundColor: Colors.transparent),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocBuilder<HomeCubit,HomeStates>(
                    buildWhen: (_,state) => state is NotificationLoadingState || state is NotificationLoadedState || state is NotificationEmptyState || state is NotificationErrorState,
                    builder: (context, state) {
                      if(state is NotificationLoadingState){
                        return const LoadingWidget();
                      }
                      if(state is NotificationEmptyState){
                        return const EmptyWidget();
                      }
                      if(state is NotificationErrorState){
                        return const ErrorFetchWidget();
                      }

                      return ListView(
                        children: List.generate(cubit.notificationModel!.invites!.length, (index) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.circle_notifications,size: 50,color: AppUI.mainColor,),
                                  const SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(text: cubit.notificationModel!.invites![index].eventname==null?"":cubit.notificationModel!.invites![index].eventname!.name!,fontSize: 20,fontWeight: FontWeight.bold,),
                                      SizedBox(width:  AppUtil.responsiveWidth(context)*0.70,
                                          child: CustomText(text: cubit.notificationModel!.invites![index].message!,color: AppUI.bottomBarColor,)
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              const Divider()
                            ],
                          );
                        }),
                      );
                    }
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
