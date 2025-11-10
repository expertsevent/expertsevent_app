import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../../../more/presentation/screens/pages/packages/package_screen.dart';
import '../../controller/add_event_cubit.dart';
import '../../controller/add_event_states.dart';

class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late final cubit = AddEventCubit.get(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.showHidePayment();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = AddEventCubit.get(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            CustomText(text: "${"Your Send".tr()} ${cubit.invitation.toString()} ${"Invitaion".tr()} ", color: AppUI.blackColor,fontSize: 20,fontWeight: FontWeight.w600,),
              const SizedBox(height: 20,),
            CustomText(text: "${"You Have".tr()} ${cubit.wallet.toString()} ${"invitation from your wallet"}", color: AppUI.blackColor,fontSize: 15,),
            const SizedBox(height: 25,),
            Row(
              children: [
                Expanded(
                  child: CustomButton(text: "previous".tr(),color: AppUI.whiteColor,textColor: AppUI.buttonColor,borderColor: AppUI.buttonColor,onPressed: (){
                    cubit.pageIndex = 2;
                  },),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  child: BlocBuilder<AddEventCubit,AddEventState>(
                      buildWhen: (_,state) => state is PayLoadingState || state is PayLoadedState,
                      builder: (context, state) {
                        if(state is PayLoadingState){
                          return const LoadingWidget();
                        }
                          return CustomButton(text: "next".tr(),onPressed: (){
                            cubit.pay(context);
                          },);
                      }
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
