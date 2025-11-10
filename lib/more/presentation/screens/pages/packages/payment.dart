import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/add_event/presentation/controller/add_event_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import '../../../../../core/app_util.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import '../../../controller/wallet/wallet_cubit.dart';
import '../../../controller/wallet/wallet_states.dart';
import 'package:expert_events/add_event/presentation/controller/add_event_cubit.dart';


class PaymentPackage extends StatefulWidget {
  final dynamic packageId;
  final String name;
  final List<String> Visitors ;
  final List<String> Prices ;
  final bool is_Change;
  final String invitaion_price;
  const PaymentPackage({Key? key, required  this.is_Change, required  this.invitaion_price, required  this.packageId, required  this.name, required  this.Prices, required  this.Visitors}) : super(key: key);
  @override
  State<PaymentPackage> createState() => _PaymentPackageState();
}

class _PaymentPackageState extends State<PaymentPackage> {
  late final cubit = WalletCubit.get(context);
  late final cubitEvent = AddEventCubit.get(context);
  late String price ;
  late double total;
  late int vat;
  late String numVisitors;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vat = 15;
    total = widget.is_Change ? (int.parse(widget.Prices[0]) + int.parse(widget.Prices[0]) * vat/100) + (cubitEvent.wallet * double.parse(widget.invitaion_price)): int.parse(widget.Prices[0]) + int.parse(widget.Prices[0]) * vat/100;
    price = widget.Prices[0];
    numVisitors = widget.Visitors[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'payment'.tr()),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                 TextSpan(
                  text: 'You have chosen'.tr(),
                  style: const TextStyle(fontSize: 16),
                  children: [
                    TextSpan(
                      text: widget.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppUI.secondColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              CustomText(text: "Select the number of invitations".tr(), color: AppUI.blackColor,fontSize: 15,fontWeight: FontWeight.w600),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                for (int i = 0; i < widget.Visitors.length; i++)
                  InkWell(
                    onTap: () {
                      numVisitors = widget.Visitors[i];
                      price = widget.Prices[i];
                      total = widget.is_Change ? (int.parse(widget.Prices[i]) + int.parse(widget.Prices[i]) * vat/100) + (cubitEvent.wallet * double.parse(widget.invitaion_price)): int.parse(widget.Prices[i]) + int.parse(widget.Prices[i]) * vat/100;
                      setState(() {});
                    },
                    child: Container(
                      width: 100,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: (numVisitors == widget.Visitors[i])  ? Colors.teal : Colors.grey.shade300, width: 1.5),
                        borderRadius: BorderRadius.circular(12),
                        color: (numVisitors == widget.Visitors[i])  ? Color(0xFFDDF7F9) : Colors.white,
                      ),
                      child: Column(
                        children: [
                          Text('${widget.Visitors[i]} ${'Invitaion'.tr()}', style: const TextStyle(fontSize: 13)),
                          const SizedBox(height: 4),
                          Text('${widget.Prices[i]} ${"sar".tr()}',
                              style: TextStyle(
                                  color: (numVisitors == widget.Visitors[i]) ? Colors.teal: Colors.black,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomText(text: "details".tr(), color: AppUI.blackColor,fontSize: 15,fontWeight: FontWeight.w600),
              _PriceDetails(
                  price : price,
                  total : total,
                  vat : int.parse(price) * vat/100,
                  wallet : widget.is_Change ? cubitEvent.wallet * double.parse(widget.invitaion_price): 0,
                  is_change : widget.is_Change
              ),
              const SizedBox(height: 20,),
              CustomText(text: "choosePaymentMethods".tr(), color: AppUI.blackColor,fontSize: 15,fontWeight: FontWeight.w600),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  BlocBuilder<WalletCubit,WalletStates>(
                      buildWhen: (_,state) => state is PaymentBrandChangeState,
                      builder: (context, snapshot) {
                      return InkWell(
                        onTap: (){
                          cubit.paymentBrand = "MADA";
                        },
                        child: Container(
                            height: 75,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: cubit.paymentBrand == "MADA"? Colors.teal[200]: AppUI.whiteColor),
                            child: Image.asset("${AppUI.imgPath}mada.png",width:  AppUtil.responsiveWidth(context)*0.2000)
                        ),
                      );
                    }
                  ),
                  // const SizedBox(width: 10),
                  // Container(
                  //     height: 75,
                  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: AppUI.whiteColor),
                  //     child: Image.asset("${AppUI.imgPath}apple.png",width: AppUtil.responsiveWidth(context)*0.285)
                  // ),
                  BlocBuilder<WalletCubit,WalletStates>(
                      buildWhen: (_,state) => state is PaymentBrandChangeState,
                      builder: (context, snapshot) {
                      return InkWell(
                        onTap: (){
                          cubit.paymentBrand = "VISA MASTER";
                        },
                        child: Container(
                            height: 75,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: cubit.paymentBrand == "VISA MASTER" ? Colors.teal[200]: AppUI.whiteColor),
                            child: Image.asset("${AppUI.imgPath}visa.png",width: AppUtil.responsiveWidth(context)*0.2200)
                        ),
                      );
                    }
                  ),
                  if (Platform.isIOS)
                  BlocBuilder<WalletCubit,WalletStates>(
                      buildWhen: (_,state) => state is PaymentBrandChangeState,
                      builder: (context, snapshot) {
                        return InkWell(
                          onTap: (){
                            cubit.paymentBrand = "APPLEPAY";
                          },
                          child: Container(
                              height: 75,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: cubit.paymentBrand == "APPLEPAY"? Colors.teal[200]: AppUI.whiteColor),
                              child: Image.asset("${AppUI.imgPath}apple.png",width: AppUtil.responsiveWidth(context)*0.2000)
                          ),
                        );
                      }
                  ),

                  BlocBuilder<WalletCubit,WalletStates>(
                      buildWhen: (_,state) => state is PaymentBrandChangeState,
                      builder: (context, snapshot) {
                        return InkWell(
                          onTap: (){
                            cubit.paymentBrand = "TABBY";
                          },
                          child: Container(
                              height: 75,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: cubit.paymentBrand == "TABBY"? Colors.teal[200]: AppUI.whiteColor),
                              child: Image.asset("${AppUI.imgPath}tabby.png",width: AppUtil.responsiveWidth(context)*0.2000,fit: BoxFit.cover,)
                          ),
                        );
                      }
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              CustomText(text: "email".tr(), color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w600),
              const SizedBox(height: 5,),
              CustomInput(controller: cubit.email, textInputType: TextInputType.emailAddress,borderColor: AppUI.mainColor,
              hint: "e.g. email@domain.com",),
              const SizedBox(height: 10,),
              CustomText(text: "phone".tr(), color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w600),
              const SizedBox(height: 5,),
              CustomInput(controller: cubit.phone, textInputType: TextInputType.phone,borderColor: AppUI.mainColor,
              hint: "e.g. 05XXXXXXXX",),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "firstName".tr(), color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w600,),
                        const SizedBox(height: 5,),
                        CustomInput(controller: cubit.firstName,hint: "firstName".tr(), textInputType: TextInputType.text,borderColor: AppUI.mainColor,),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "lastName".tr(), color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.w600,),
                        const SizedBox(height: 5,),
                        CustomInput(controller: cubit.lastName, hint: "lastName".tr(),textInputType: TextInputType.text,borderColor: AppUI.mainColor,),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40,),
              Row(
                children: [
                  Expanded(
                    child: BlocBuilder<WalletCubit,WalletStates>(
                        buildWhen: (_,state) => state is PayLoadingState || state is PayLoadedState,
                        builder: (context, state) {
                          if(state is PayLoadingState){
                            return const LoadingWidget();
                          }
                          return CustomButton(text:"$total ${"sar".tr()}",onPressed: () async {
                            await cubit.pay(context,price : total,packageId : widget.packageId,numVisitors: numVisitors,is_Change:widget.is_Change ? 'yes' : 'no');
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
              ),
              const SizedBox(height: 40,),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceDetails extends StatelessWidget {
  final String price;
  final double wallet;
  final double total;
  final double vat;
  final bool is_change;
  const _PriceDetails({
    required this.price,
    required this.wallet,
    required this.total,
    required this.vat,
    required this.is_change,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = TextStyle(color: Colors.grey[700]);
    TextStyle valueStyle = TextStyle(color: Colors.black);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        _PriceRow('Package value'.tr(), "${price} ${'sar'.tr()}", labelStyle, valueStyle),
        if(is_change)
        _PriceRow('remaining invitations'.tr(), "${wallet} ${'sar'.tr()}",
            labelStyle, TextStyle(color: Colors.red)),
        _PriceRow('${"tax".tr()} (15%)', "${vat} ${'sar'.tr()}", labelStyle, valueStyle),
        Divider(),
        _PriceRow(
          'Total'.tr(),
          "${total} ${'sar'.tr()}",
          TextStyle(fontWeight: FontWeight.bold),
          TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ],
    );
  }

  Widget _PriceRow(String label, String value, TextStyle labelStyle,
      TextStyle valueStyle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: labelStyle),
          Text(value, style: valueStyle),
        ],
      ),
    );
  }
}
