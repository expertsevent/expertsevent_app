import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/events/events_cubit.dart';
import '../../controller/events/events_states.dart';
class CancelTap extends StatefulWidget {
  const CancelTap({Key? key}) : super(key: key);

  @override
  State<CancelTap> createState() => _CancelTapState();
}

class _CancelTapState extends State<CancelTap> {
  late final EventsCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = EventsCubit.get(context);
    cubit.getCancelEvents();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = EventsCubit.get(context);
    return Stack(
      children: [
        Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
        BlocBuilder<EventsCubit,EventsStates>(
            buildWhen: (_,state) => state is CancelEventsLoadingState || state is CancelEventsLoadedState || state is CancelEventsErrorState || state is CancelEventsEmptyState,
            builder: (context, state) {
              if(state is CancelEventsLoadingState){
                return const LoadingWidget();
              }
              if(state is CancelEventsErrorState){
                return const ErrorFetchWidget();
              }
              if(cubit.cancelEventsModel!.data.isEmpty){
                return const EmptyWidget();
              }

              return ListView(
                children: List.generate(cubit.cancelEventsModel!.data.length, (index) {
                  return Column(
                    children: [
                      EventCard(event: cubit.cancelEventsModel!.data[index], type: 'cancel'.tr(),),
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
