import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/event/presentation/controller/guards/guards_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/guards/guards_cubit.dart';
import 'add_guard_screen.dart';
class GuardsScreen extends StatefulWidget {
  const GuardsScreen({Key? key}) : super(key: key);

  @override
  State<GuardsScreen> createState() => _GuardsScreenState();
}

class _GuardsScreenState extends State<GuardsScreen> {
  Country? _selectedCountry = Country(
    phoneCode: '966',
    countryCode: 'SA',
    e164Sc: -1,
    geographic: false,
    level: -1,
    name: 'World Wide',
    example: '',
    displayName: 'World Wide (WW)',
    displayNameNoCountryCode: 'World Wide',
    e164Key: '',
  );

  late final GuardsCubit guardsCubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    guardsCubit = GuardsCubit.get(context);
    guardsCubit.getGuards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          customAppBar(title: "guards".tr()),
          Container(
            color: AppUI.whiteColor,
            padding: const EdgeInsets.only(left: 16,right: 16,bottom: 10),
            child: Row(
              children: [
                Expanded(flex: 8,child: CustomInput(controller: TextEditingController(),hint: "search".tr(),prefixIcon: IconButton(onPressed: (){}, icon: const Icon(Icons.search)), textInputType: TextInputType.text, onChange: (v){
                  guardsCubit.getGuards(filter: 'name=$v');
                })),
                const SizedBox(width: 10,),
                Expanded(child: CircleAvatar(
                  backgroundColor: AppUI.secondColor,
                  child: IconButton(onPressed: (){
                    AppUtil.mainNavigator(context, const AddGuardScreen());
                  }, icon: const Icon(Icons.add,color: AppUI.whiteColor,)),
                ))
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: "guardList".tr(),fontSize: 20,),
                      const SizedBox(height: 10,),
                      Expanded(
                        child: BlocBuilder<GuardsCubit,GuardsSates>(
                          buildWhen: (_,state) => state is GuardsLoadingState || state is GuardsLoadedState || state is GuardsEmptyState || state is GuardsErrorState,
                          builder: (context, state) {
                            if(state is GuardsLoadingState){
                              return const LoadingWidget();
                            }
                            if(state is GuardsEmptyState){
                              return const EmptyWidget();
                            }
                            if(state is GuardsErrorState){
                              return const ErrorFetchWidget();
                            }

                            return ListView(
                              padding: const EdgeInsets.all(0),
                              shrinkWrap: true,
                              children: List.generate(guardsCubit.guardsModel!.data.length, (index) {
                                return CustomCard(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(Icons.person,color: AppUI.mainColor,),
                                          const SizedBox(width: 10,),
                                          CustomText(text: guardsCubit.guardsModel!.data[index].name,color: AppUI.mainColor,fontSize: 20,fontWeight: FontWeight.bold,)
                                        ],
                                      ),
                                      const SizedBox(height: 16,),
                                      Row(
                                        children: [
                                          SvgPicture.asset("${AppUI.iconPath}mobile.svg"),
                                          const SizedBox(width: 16,),
                                          CustomText(text: guardsCubit.guardsModel!.data[index].phone,color: AppUI.iconColor,)
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          InkWell(
                                            onTap: (){
                                              var nameEditController = TextEditingController();
                                              var phoneEditController = TextEditingController();
                                              var passwordEditController = TextEditingController();
                                              nameEditController.text = guardsCubit.guardsModel!.data[index].name;
                                              phoneEditController.text = guardsCubit.guardsModel!.data[index].phone;
                                              AppUtil.dialog2(context, 'editGuard'.tr(), [
                                                CustomInput(controller: nameEditController,textInputType: TextInputType.name),
                                                const SizedBox(height: 10,),
                                                StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return CustomInput(controller: phoneEditController,hint: "phoneNumber".tr(), textInputType: TextInputType.phone);
                                                  }
                                                ),
                                                const SizedBox(height: 10,),
                                                CustomInput(controller: passwordEditController,hint: "pass".tr(), textInputType: TextInputType.visiblePassword),
                                                const SizedBox(height: 20,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Expanded(child: BlocBuilder<GuardsCubit,GuardsSates>(
                                                      buildWhen: (_,state) => state is AddGuardsLoadingState || state is AddGuardsLoadedState,
                                                      builder: (context, state) {
                                                        if(state is AddGuardsLoadingState){
                                                          return const LoadingWidget();
                                                        }
                                                        return CustomButton(text: "save",onPressed: (){
                                                          guardsCubit.editGuard(context, guardsCubit.guardsModel!.data[index].id,nameEditController.text,phoneEditController.text);
                                                        },);
                                                      }
                                                    )),
                                                    const SizedBox(width: 10,),
                                                    Expanded(child: CustomButton(text: "cancel",borderColor: AppUI.mainColor,textColor: AppUI.mainColor,color: AppUI.whiteColor,onPressed: (){
                                                      Navigator.of(context,rootNavigator: true).pop();
                                                    },)),
                                                  ],
                                                )
                                              ]);
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(Icons.edit,color: AppUI.secondColor,),
                                                const SizedBox(width: 10,),
                                                CustomText(text: "edit".tr(),color: AppUI.secondColor,)
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: (){
                                              AppUtil.dialog2(context, '', [
                                                const LoadingWidget(),
                                                const SizedBox(height: 30,)
                                              ]);
                                              guardsCubit.deleteGuard(context, guardsCubit.guardsModel!.data[index].id);
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(Icons.edit,color: AppUI.errorColor,),
                                                const SizedBox(width: 10,),
                                                CustomText(text: "delete".tr(),color: AppUI.errorColor,)
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            );
                          }
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
