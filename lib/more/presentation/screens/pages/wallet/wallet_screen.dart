import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../core/app_util.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import '../../../controller/wallet/wallet_cubit.dart';
import '../../../controller/wallet/wallet_states.dart';
import '../packages/package_screen.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final cubit = WalletCubit.get(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit.getWallet();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customAppBar(title: "Wallet".tr(),backgroundColor: Colors.transparent,textColor: AppUI.mainColor),
                  // const SizedBox(height: 20,),
                  CustomButton(text: "ChargePackage".tr(),onPressed: () {
                  AppUtil.mainNavigator(context, const PackageScreen());
                 },height: 35),
                  const SizedBox(height: 10,),
                  BlocBuilder<WalletCubit,WalletStates>(
                      builder:  (context, state) {
                        if(state is WalletLoadingState){
                          return const Center(child: LoadingWidget());
                        }
                        if(state is WalletErrorState){
                          return const Center(child: ErrorFetchWidget());
                        }
                      return CustomCard(
                        elevation: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomText(text: "You Have".tr(),color: AppUI.blackColor,fontSize: 10),
                              const SizedBox(height: 5,),
                              CustomText(text: "${cubit.walletModel!.wallet!.toString()} ${"Invitaions".tr()}",color: AppUI.blackColor,fontSize: 15,fontWeight: FontWeight.bold,),
                              const SizedBox(height: 5,),
                              LinearPercentIndicator(
                                percent: cubit.walletModel!.wallet!.toDouble() / 1000,
                                center: CustomText(text: cubit.walletModel!.wallet!.toString(),color: const Color(0xff8A8D9F),fontSize: 12,),
                                backgroundColor: const Color(0xffEDEBF7),
                                progressColor: AppUI.mainColor,
                              ),
                              const SizedBox(height: 5,),
                              CustomText(text: "${"there are".tr()} ${cubit.walletModel!.remain!.toString()} ${"invitations left".tr()}",color: AppUI.shimmerColor,fontSize: 10,),
                            ],
                          ),
                      );
                    }
                  ),
                  BlocBuilder<WalletCubit,WalletStates>(
                      builder:  (context, state) {
                        if(state is WalletLoadingState){
                          return const Center(child: LoadingWidget());
                        }
                        if(state is WalletErrorState){
                          return const Center(child: ErrorFetchWidget());
                        }
                      return CustomCard(
                        elevation: 0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 30.0,
                                    lineWidth: 8.0,
                                    percent: cubit.walletModel!.spent!.toDouble() / 1000,
                                    center: CustomText(text: cubit.walletModel!.spent!.toString(),color: const Color(0xff8A8D9F),fontSize: 14,),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: AppUI.errorColor,
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "Spent Invitation".tr(),color: AppUI.blackColor,fontSize: 10),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 30.0,
                                    lineWidth: 8.0,
                                    percent: cubit.walletModel!.wallet!.toDouble() / 1000,
                                    center: CustomText(text: cubit.walletModel!.wallet!.toString(),color: const Color(0xff8A8D9F),fontSize: 14,),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: AppUI.activeColor,
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "Total Invitation".tr(),color: AppUI.blackColor,fontSize: 10),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 30.0,
                                    lineWidth: 8.0,
                                    percent: cubit.walletModel!.back!.toDouble() / 1000,
                                    center: CustomText(text: cubit.walletModel!.back!.toString(),color: const Color(0xff8A8D9F),fontSize: 14,),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    backgroundColor: const Color(0xffEDEBF7),
                                    progressColor: AppUI.secondColor,
                                  ),
                                  const SizedBox(height: 5,),
                                  CustomText(text: "Returned Invitation".tr(),color: AppUI.blackColor,fontSize: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 20,),
                  CustomText(text: "Recent Transactions".tr(),color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.bold,),
                  const SizedBox(height: 5,),
                  BlocBuilder<WalletCubit,WalletStates>(
                      builder:  (context, state) {
                        if(state is WalletLoadingState){
                          return const Center(child: LoadingWidget());
                        }
                        if(state is WalletErrorState){
                          return const Center(child: ErrorFetchWidget());
                        }
                        if(state is TransactionsWalletEmptyState){
                          return const Center(child: EmptyWidget());
                        }
                      return ListView(
                        padding:  const EdgeInsets.all(16.0),
                          shrinkWrap: true,
                          children: List.generate(cubit.walletModel!.transactions!.length, (index) {
                            return Column(
                              children: [
                                ListTile(
                                  title: CustomText(text: cubit.walletModel!.transactions![index].reason!,color: AppUI.blackColor,fontSize: 16,fontWeight: FontWeight.bold,),
                                  subtitle: CustomText(text: cubit.walletModel!.transactions![index].createdAt!,color: AppUI.shimmerColor,fontSize: 10),
                                  trailing: CustomText(text: cubit.walletModel!.transactions![index].price.toString(),color: cubit.walletModel!.transactions![index].type! == "add"? AppUI.activeColor : AppUI.errorColor,fontSize: 16,fontWeight: FontWeight.bold,),
                                  leading: SvgPicture.network(cubit.walletModel!.transactions![index].icon!,width: 30,height: 30),
                                ),
                                const Divider()
                              ],
                            );
                          }),
                        );
                    }
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
