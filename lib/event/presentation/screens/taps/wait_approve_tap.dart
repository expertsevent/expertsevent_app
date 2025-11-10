import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/events/events_cubit.dart';
import '../../controller/events/events_states.dart';
class WaitApproveTap extends StatefulWidget {
  const WaitApproveTap({Key? key}) : super(key: key);

  @override
  State<WaitApproveTap> createState() => _WaitApproveTapState();
}

class _WaitApproveTapState extends State<WaitApproveTap> {
  late final EventsCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = EventsCubit.get(context);
    cubit.getWaitEvents();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = EventsCubit.get(context);
    return Stack(
      children: [
        Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
        BlocBuilder<EventsCubit,EventsStates>(
            buildWhen: (_,state) => state is WaitEventsLoadingState || state is WaitEventsLoadedState || state is WaitEventsErrorState || state is WaitEventsEmptyState,
            builder: (context, state) {
              if(state is WaitEventsLoadingState){
                return const LoadingWidget();
              }
              if(state is WaitEventsErrorState){
                return const ErrorFetchWidget();
              }
              if(cubit.waitEventsModel!.data.isEmpty){
                return const EmptyWidget();
              }

              return ListView(
                children: List.generate(cubit.waitEventsModel!.data.length, (index) {
                  return Column(
                    children: [
                      EventCard(event: cubit.waitEventsModel!.data[index], type: 'waitApprove'.tr(),),
                      const SizedBox(height: 15,)
                    ],
                  );
                }),
              );
            }
        )
      ],
    );
  }
}
