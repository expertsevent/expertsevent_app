import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../auth/presentation/screens/sign_in_screen.dart';
import '../../../../core/app_util.dart';
import '../../../../core/ui/app_ui.dart';
import '../../controller/intro_cubit.dart';
import '../../controller/intro_states.dart';

class GuestScreenEn extends StatefulWidget {
  const GuestScreenEn({Key? key}) : super(key: key);

  @override
  _GuestScreenEnState createState() => _GuestScreenEnState();
}

class _GuestScreenEnState extends State<GuestScreenEn> {
  late final cubit = IntroCubit.get(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          body: BlocBuilder<IntroCubit,IntroStates>(
              buildWhen: (_,state) => state is GuestPageChangeState ,
              builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("${AppUI.imgPath}splash.png", height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fill,),
                  InkWell(
                      onTap: ()  {
                        cubit.increasePageStep();
                        if(cubit.step == 16){
                          AppUtil.mainNavigator(context, const SignInScreen());
                          cubit.step = 1;
                          //CashHelper.getSavedString( "lang","");
                        }
                      },
                      child: Image.asset("${AppUI.imgPath}guest_${context.locale.languageCode.toString()}_${cubit.step}.png", height: double.infinity, width: double.infinity, fit: BoxFit.fill,)),
                ],
              );
            }
          ),
        );
      }
}
