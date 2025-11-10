import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../add_event/presentation/controller/add_event_cubit.dart';
import '../../../../add_event/presentation/controller/add_event_states.dart';
import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';

class Payment extends StatelessWidget {
  final String type;
  const Payment({Key? key, required  this.type,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = AddEventCubit.get(context);

    return Scaffold(
      appBar: customAppBar(title: 'payment'.tr()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset("${AppUI.imgPath}mada.png",fit: BoxFit.fill,width: AppUtil.responsiveWidth(context)*0.285),
                  const SizedBox(width: 10),
                  Container(
                      height: 75,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppUI.whiteColor),
                      child: Image.asset("${AppUI.imgPath}apple.png",width: AppUtil.responsiveWidth(context)*0.285)),
                  const SizedBox(width: 10),
                  Container(
                      height: 75,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppUI.whiteColor),
                      child: Image.asset("${AppUI.imgPath}stc.png",width: AppUtil.responsiveWidth(context)*0.285)),
                ],
              ),
              const SizedBox(height: 40,),
              CustomText(text: "cardNumber".tr(), color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w600,),
              const SizedBox(height: 5,),
              CustomInput(controller: cubit.cardNumber, textInputType: TextInputType.number,borderColor: AppUI.mainColor,),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "expiryDate".tr(), color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w600,),
                        const SizedBox(height: 5,),
                        CustomInput(controller: cubit.expiryDate, textInputType: TextInputType.number,borderColor: AppUI.mainColor,),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "CVV".tr(), color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w600,),
                        const SizedBox(height: 5,),
                        CustomInput(controller: cubit.cvv, textInputType: TextInputType.number,borderColor: AppUI.mainColor,),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              CustomText(text: "NameOfCardholder".tr(), color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w600,),
              const SizedBox(height: 5,),
              CustomInput(controller: cubit.holderName, textInputType: TextInputType.name,borderColor: AppUI.mainColor,),
              const SizedBox(height: 40,),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<AddEventCubit,AddEventState>(
                        buildWhen: (_,state) => state is PayLoadingState || state is PayLoadedState,
                        builder: (context, state) {
                          if(state is PayLoadingState){
                            return const LoadingWidget();
                          }
                          return CustomButton(text: "next".tr(),onPressed: () async {
                            await cubit.pay(context,type: type,complete: true);
                          },);
                        }
                    ),
                  ),
                  // const SizedBox(width: 10,),
                  // Expanded(
                  //   child: CustomButton(text: "previous".tr(),color: AppUI.whiteColor,textColor: AppUI.buttonColor,borderColor: AppUI.buttonColor,onPressed: (){
                  //     cubit.pageIndex = 1;
                  //   },),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
