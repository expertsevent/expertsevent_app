
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/events/events_cubit.dart';
import '../../controller/events/events_states.dart';

class DraftTap extends StatefulWidget {
  const DraftTap({Key? key}) : super(key: key);

  @override
  State<DraftTap> createState() => _DraftTapState();
}

class _DraftTapState extends State<DraftTap> {
  late final EventsCubit cubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = EventsCubit.get(context);
    cubit.getDraftEvents();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = EventsCubit.get(context);
    return Stack(
      children: [
        Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
        BlocBuilder<EventsCubit,EventsStates>(
          buildWhen: (_,state) => state is DraftEventsLoadingState || state is DraftEventsLoadedState || state is DraftEventsErrorState || state is DraftEventsEmptyState,
          builder: (context, state) {
            if(state is DraftEventsLoadingState){
              return const LoadingWidget();
            }
            if(state is DraftEventsErrorState){
              return const ErrorFetchWidget();
            }
            if(cubit.draftEventsModel!.data.isEmpty){
              return const EmptyWidget();
            }

            return ListView(
              children: List.generate(cubit.draftEventsModel!.data.length, (index) {
                return Column(
                  children: [
                    EventCard(event: cubit.draftEventsModel!.data[index], type: "draft".tr(),),
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
