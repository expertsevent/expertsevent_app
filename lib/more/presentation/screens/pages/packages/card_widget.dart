import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/more/presentation/screens/pages/packages/payment.dart';
import 'package:flutter/material.dart';

import '../../../../../core/app_util.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
class CardPackage extends StatelessWidget {
  final String title,descripton,visitors,price;
  final String isRecommended;
  final dynamic id;
  final bool is_Change;
  final String invitaion_price;
  const CardPackage({Key? key ,required this.is_Change,required this.invitaion_price,required this.title , required this.descripton , required this.isRecommended , required this.price , this.id, required this.visitors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> decodedDescription = List<String>.from(jsonDecode(descripton));
    List<String> decodedVisitors = List<String>.from(jsonDecode(visitors));
    List<String> decodedPrices = List<String>.from(jsonDecode(price));

    return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isRecommended == "1" ? AppUI.secondColor.withOpacity(0.1): Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: isRecommended == "1" ? Colors.transparent : Colors.black12, blurRadius: 10),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isRecommended == "1")
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.yellow[700],
                borderRadius: BorderRadius.circular(10),
              ),
              child: CustomText(text: 'Recommended'.tr(),fontSize: 15,fontWeight: FontWeight.bold,color: AppUI.whiteColor,),
            ),
          const SizedBox(height: 10),
          CustomText(text: title,fontSize: 22,fontWeight: FontWeight.bold,color: AppUI.secondColor,),
          CustomText(text: "start from".tr(),color: AppUI.disableColor,),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(text:  "${'Invitaion'.tr()} ${decodedVisitors[0]} ",fontSize: 18,fontWeight: FontWeight.bold,color: AppUI.blackColor,),
              CustomText(text:  " / ${'sar'.tr()} ${decodedPrices[0]}",fontSize: 18,fontWeight: FontWeight.bold,color: AppUI.secondColor,),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: decodedDescription
                .map<Widget>((des) => Row(
              children: [
                const Icon(Icons.check_circle_outline, size: 20, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    des.toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ))
                .toList(),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Get this package'.tr(),
            width: 280,
            color: AppUI.buttonColor ,
            borderColor:  AppUI.buttonColor ,
            textColor:  AppUI.whiteColor,
            onPressed: () {
              AppUtil.mainNavigator(context,
                  PaymentPackage(
                      packageId: id,
                      name : title,
                      Visitors : decodedVisitors,
                      Prices : decodedPrices,
                      is_Change : is_Change,
                      invitaion_price : invitaion_price
                  ),
              );
            },
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

