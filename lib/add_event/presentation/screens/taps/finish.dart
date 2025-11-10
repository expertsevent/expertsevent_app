import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/add_event_cubit.dart';
class Finish extends StatelessWidget {
  const Finish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = AddEventCubit.get(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("${AppUI.imgPath}success.png",height: 200,),
        const SizedBox(height: 40,),
        CustomText(text: "paymentSuccessful".tr(),fontSize: 22,fontWeight: FontWeight.bold,color: AppUI.blackColor,),
        const SizedBox(height: 20,),
        SizedBox(
          width: AppUtil.responsiveWidth(context)*0.85,
            child: CustomText(text: "your event under review , We Will Announce you when Approved".tr(),fontSize: 16,color: AppUI.disableColor,textAlign: TextAlign.center,)),
        const SizedBox(height: 40,),
        CustomButton(text: "done".tr(),onPressed: (){
          cubit.pageIndex = 0;
          Navigator.pop(context);
        },)
      ],
    );
  }
}
