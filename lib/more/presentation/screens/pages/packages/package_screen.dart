import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/more/presentation/screens/pages/packages/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/app_util.dart';
import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import '../../../../../layout/presentation/screens/layout_screen.dart';
import '../../../controller/wallet/wallet_cubit.dart';
import '../../../controller/wallet/wallet_states.dart';
import 'package:expert_events/auth/presentation/controller/auth/auth_cubit.dart';
import 'package:expert_events/auth/presentation/controller/auth/auth_cubit.dart';
import 'package:expert_events/add_event/presentation/controller/add_event_cubit.dart';
import 'package:dotted_border/dotted_border.dart';


class PackageScreen extends StatefulWidget {
  final bool is_Change;
  const PackageScreen({Key? key, this.is_Change = false}) : super(key: key);

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  late final cubit = WalletCubit.get(context);
  late final authcubit = AuthCubit.get(context);
  late final eventcubit = AddEventCubit.get(context);
  @override
  void initState() {
    super.initState();
    cubit.getPackages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "${AppUI.imgPath}splash.png",
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customAppBar(
                  title: "Packages".tr(),
                  backgroundColor: Colors.transparent,
                  textColor: AppUI.mainColor,
              leading: InkWell(
                  onTap: (){
                    AppUtil.removeUntilNavigator(context, const LayoutScreen());
                  },
                  child: const Icon(Icons.arrow_back_ios),
              ) ),
              if(widget.is_Change)
              SizedBox(height: 10),
              if(widget.is_Change)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 22),
                child : DottedBorder(
                  color: Colors.red,
                  dashPattern: [6, 3],
                  strokeWidth: 1.5,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFE9E9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.red),
                      SizedBox(width: 8),
                      Expanded(
                        child: CustomText(
                          text: '${"You are subscribed to".tr()} ${authcubit.profileModel!.data!.package_name!}. \n ${"You have".tr()} ${eventcubit.wallet}  ${"invitations remaining".tr()} \n ${"we calculate your value from the new package".tr()}',
                          color: AppUI.blackColor,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
               ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: BlocBuilder<WalletCubit, WalletStates>(
                      builder: (context, state) {
                    if (state is PackageLoadingState) {
                      return const Center(child: LoadingWidget());
                    }
                    if (state is PackageErrorState) {
                      return const Center(child: ErrorFetchWidget());
                    }
                    if (state is PackageEmptyState) {
                      return const Center(child: EmptyWidget());
                    }
                    // Safe handling of packageModel
                    if (cubit.packageModel == null || cubit.packageModel!.data == null) {
                      return const Center(child: EmptyWidget());
                    }
                    return ListView(
                      children: List.generate(cubit.packageModel!.data!.length,
                          (index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CardPackage(
                              title: cubit.packageModel!.data![index].title
                                  .toString(),
                              descripton: cubit
                                  .packageModel!.data![index].descripton
                                  .toString(),
                              isRecommended: cubit.packageModel!.data![index].isRecommended.toString(),
                              price: cubit.packageModel!.data![index].price.toString(),
                              visitors: cubit.packageModel!.data![index].visitors.toString(),
                              invitaion_price : cubit.packageModel!.data![index].invitaion_price.toString(),
                              id: cubit.packageModel!.data![index].id,
                              is_Change : widget.is_Change
                            ),
                            const SizedBox(
                              height: 25,
                            )
                          ],
                        );
                      }),
                    );
                  }),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
