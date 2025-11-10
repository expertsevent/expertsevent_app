import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/ui/app_ui.dart';
import '../../../../../../core/ui/components.dart';
import '../../../../components/visitor_card.dart';
import '../../../../controller/more_cubit.dart';
import '../../../../controller/more_states.dart';
class PendingTap extends StatefulWidget {
  const PendingTap({Key? key}) : super(key: key);

  @override
  State<PendingTap> createState() => _PendingTapState();
}

class _PendingTapState extends State<PendingTap> {
  late final MoreCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = MoreCubit.get(context);
    cubit.getVisitors("pending-visitors");
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoreCubit,MoreStates>(
        buildWhen: (_,state) => state is VisitorsLoadingState || state is VisitorsLoadedState || state is VisitorsEmptyState || state is VisitorsErrorState,
        builder: (context, state) {
          if(state is VisitorsLoadingState){
            return const LoadingWidget();
          }
          if(state is VisitorsErrorState){
            return const ErrorFetchWidget();
          }
          if(state is VisitorsEmptyState){
            return const EmptyWidget();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child:VisitorCard(visitors: cubit.visitors!.data!),
          );
        }
    );
  }
}
