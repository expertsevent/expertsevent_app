import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/more/presentation/controller/more_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/ui/app_ui.dart';
import '../../../../../core/ui/components.dart';
import '../../../add_event/presentation/screens/add_event_screen.dart';
import '../../../core/app_util.dart';

class BottomNavBar extends StatelessWidget {
  final Function() onTap0,onTap1,onTap2,onTap3;
  final int currentIndex;
  const BottomNavBar({Key? key,required this.currentIndex,required this.onTap0,required this.onTap1,required this.onTap2,required this.onTap3}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Stack(
        children: [
          Image.asset("${AppUI.imgPath}tabbar.png",width: double.infinity,fit: BoxFit.fill,height: 75,),
          //if(MoreCubit.get(context).userType != "gurad")
            Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 7),
              child: InkWell(
                onTap: (){
                  AppUtil.mainNavigator(context, const AddEventsScreen());
                },
                child: const CircleAvatar(
                  radius: 25,
                  backgroundColor: AppUI.secondColor,
                  child: Icon(Icons.add,color: AppUI.whiteColor,size: 30,),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                SizedBox(
                  width: AppUtil.responsiveWidth(context)*0.3,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: onTap0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20,),
                            SvgPicture.asset("${AppUI.iconPath}home.svg",color: currentIndex==0?AppUI.mainColor:AppUI.bottomBarColor,),
                            const SizedBox(height: 3,),
                            CustomText(text: "home".tr(),textAlign: TextAlign.center,color: currentIndex==0?AppUI.mainColor:AppUI.bottomBarColor,fontSize: 12)
                          ],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onTap1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20,),
                            SvgPicture.asset("${AppUI.iconPath}invitation.svg",color: currentIndex==1?AppUI.mainColor:AppUI.bottomBarColor,),
                            CustomText(text: "invitations".tr(),textAlign: TextAlign.center,color: currentIndex==1?AppUI.mainColor:AppUI.bottomBarColor,fontSize: 12)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: AppUtil.responsiveWidth(context)*0.3,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: onTap2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20,),
                            SvgPicture.asset("${AppUI.iconPath}event.svg",color: currentIndex==2?AppUI.mainColor:AppUI.bottomBarColor,),
                            const SizedBox(height: 3,),
                            CustomText(text: "events".tr(),textAlign: TextAlign.center,color: currentIndex==2?AppUI.mainColor:AppUI.bottomBarColor,fontSize: 12,)
                          ],
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: onTap3,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 20,),
                            SvgPicture.asset("${AppUI.iconPath}user.svg",color: currentIndex==3?AppUI.mainColor:AppUI.bottomBarColor,),
                            const SizedBox(height: 3,),
                            CustomText(text: "Account".tr(),textAlign: TextAlign.center,color: currentIndex==3?AppUI.mainColor:AppUI.bottomBarColor,fontSize: 12)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
