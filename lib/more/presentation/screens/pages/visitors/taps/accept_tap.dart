import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/ui/components.dart';
import '../../../../components/visitor_card.dart';
import '../../../../controller/more_cubit.dart';
import '../../../../controller/more_states.dart';
class AcceptTap extends StatefulWidget {
  const AcceptTap({Key? key}) : super(key: key);

  @override
  State<AcceptTap> createState() => _AcceptTapState();
}

class _AcceptTapState extends State<AcceptTap> {
  late final MoreCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = MoreCubit.get(context);
    cubit.getVisitors("accept-visitors");
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
            child: VisitorCard(visitors: cubit.visitors!.data!),
          );
        }
    );
  }
}
