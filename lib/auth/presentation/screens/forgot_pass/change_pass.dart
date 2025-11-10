import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../../../core/ui/components.dart';
import '../../controller/forget_pass/forget_pass_cubit.dart';
import '../../controller/forget_pass/forget_pass_states.dart';
class ChangePass extends StatelessWidget {
  final String phone;
  const ChangePass({Key? key, required this.phone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = ForgetPassCubit.get(context);
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("${AppUI.imgPath}splash.png",height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              customAppBar(title: "changePass".tr(),backgroundColor: Colors.transparent),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: CustomCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CustomText(text: "Choose a secure password that will be easy for you to remember.".tr(),fontSize: 16,color: AppUI.bottomBarColor,textAlign: TextAlign.center,),
                            const SizedBox(height: 40,),
                            BlocBuilder<ForgetPassCubit,ForgetPassStates>(
                              buildWhen: (_,state) => state is PassChangeVisibility,
                              builder: (context, state) {
                                return CustomInput(controller: cubit.passController, textInputType: TextInputType.visiblePassword,obscureText: !cubit.passVisibility,suffixIcon: InkWell(
                                  onTap: (){
                                    cubit.passVisibility = !cubit.passVisibility;
                                  },
                                    child: Icon(cubit.passVisibility?Icons.visibility_outlined:Icons.visibility_off_outlined)),);
                              }
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  BlocBuilder<ForgetPassCubit,ForgetPassStates>(
                    buildWhen: (_,state) => state is ResetPassLoadingState || state is ResetPassLoadedState,
                    builder: (context, state) {
                      if(state is ResetPassLoadingState){
                        return const LoadingWidget();
                      }
                      return CustomButton(text: "submit".tr(),onPressed: (){
                        cubit.resetPass(context,phone);
                      },);
                    }
                  ),
                ],
              ),
              const SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}
