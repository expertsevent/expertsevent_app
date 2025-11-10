import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/events/events_cubit.dart';
import '../../controller/events/events_states.dart';
class FinishedTap extends StatefulWidget {
  const FinishedTap({Key? key}) : super(key: key);

  @override
  State<FinishedTap> createState() => _FinishedTapState();
}

class _FinishedTapState extends State<FinishedTap> {
  late final EventsCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = EventsCubit.get(context);
    cubit.getFinishEvents();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = EventsCubit.get(context);
    return Stack(
      children: [
        Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
        BlocBuilder<EventsCubit,EventsStates>(
            buildWhen: (_,state) => state is FinishEventsLoadingState || state is FinishEventsLoadedState || state is FinishEventsErrorState || state is FinishEventsEmptyState,
            builder: (context, state) {
              if(state is FinishEventsLoadingState){
                return const LoadingWidget();
              }
              if(state is FinishEventsErrorState){
                return const ErrorFetchWidget();
              }
              if(cubit.finishEventsModel!.data.isEmpty){
                return const EmptyWidget();
              }

              return ListView(
                children: List.generate(cubit.finishEventsModel!.data.length, (index) {
                  return Column(
                    children: [
                      EventCard(event: cubit.finishEventsModel!.data[index], type: "finished".tr(),),
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
