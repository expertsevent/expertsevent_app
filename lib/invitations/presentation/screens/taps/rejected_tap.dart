import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/invitations_cubit.dart';
import '../../controller/invitations_states.dart';
class RejectedTap extends StatefulWidget {
  const RejectedTap({Key? key}) : super(key: key);

  @override
  State<RejectedTap> createState() => _RejectedTapState();
}

class _RejectedTapState extends State<RejectedTap> {
  late final cubit = InvitationsCubit.get(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.endPoint = 'reject';
    cubit.getInvitations(cubit.endPoint);
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
        BlocBuilder<InvitationsCubit,InvitationsStates>(
            buildWhen: (_,state) => state is InvitationsLoadingState || state is InvitationsLoadedState || state is InvitationsEmptyState || state is InvitationsErrorState ,
            builder: (context, state) {
              if(state is InvitationsLoadingState){
                return const LoadingWidget();
              }
              if(state is InvitationsErrorState){
                return const ErrorFetchWidget();
              }
              if(state is InvitationsEmptyState){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("${AppUI.imgPath}logo.png",width: 100,height: 100,fit: BoxFit.fill,),
                    EmptyWidget(text: "Here you will find your received invitations".tr(),),
                  ],
                );
              }
              return ListView(
                children: List.generate(cubit.invitationsModel!.data.length, (index) {
                  return Column(
                    children: [
                      InvitationCard(event: cubit.invitationsModel!.data[index]),
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
