import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/events/events_cubit.dart';
import '../../controller/events/events_states.dart';
class ActiveTap extends StatefulWidget {
  const ActiveTap({Key? key}) : super(key: key);

  @override
  State<ActiveTap> createState() => _ActiveTapState();
}

class _ActiveTapState extends State<ActiveTap> {
  late final EventsCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = EventsCubit.get(context);
    cubit.getActiveEvents();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = EventsCubit.get(context);
    return Stack(
      children: [
        Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
        BlocBuilder<EventsCubit,EventsStates>(
            buildWhen: (_,state) => state is ActiveEventsLoadingState || state is ActiveEventsLoadedState || state is ActiveEventsErrorState || state is ActiveEventsEmptyState,
            builder: (context, state) {
              if(state is ActiveEventsLoadingState){
                return const LoadingWidget();
              }
              if(state is ActiveEventsErrorState){
                return const ErrorFetchWidget();
              }
              if(cubit.activeEventsModel!.data.isEmpty){
                return const EmptyWidget();
              }

              return ListView(
                children: List.generate(cubit.activeEventsModel!.data.length, (index) {
                  return Column(
                    children: [
                      EventCard(event: cubit.activeEventsModel!.data[index], type: 'active'.tr(),),
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
