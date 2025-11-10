import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../add_event/data/add_event_repository.dart';
import '../../../core/app_util.dart';
import '../../../core/cash_helper.dart';
import '../../../core/ui/app_ui.dart';
import '../../../core/ui/components.dart';
import 'bottom_nav_states.dart';
import 'package:package_info_plus/package_info_plus.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(BottomNavInit());

  static BottomNavCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  setCurrentIndex(index) {
    currentIndex = index;
    emit(ChangeState());
  }

  bool _menuOpen = false;

  bool get menuOpen => _menuOpen;

  set menuOpen(bool menuOpen) {
    _menuOpen = menuOpen;
    emit(MenuChangeState());
  }

  double tranX = 0,
      tranY = 0,
      scale = 1.0;


  int initIndex = 0;

  int initVisitorIndex = 0;

  showPopUpdate(context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    try{
      Map<String,dynamic> response = await AddEventRepository.showHidePayment();
        if(Platform.isAndroid) {
          print('hbhjbhjbhj ${response['version_num_andoriod']}');
          print('hbhjbhjbhj ${packageInfo.version.toString()}');
          print('hbhjbhjbhj ${response['build_num_andoriod']}');
          print('hbhjbhjbhj ${packageInfo.buildNumber.toString()}');
          if (response['version_num_andoriod'].toString() != packageInfo.version.toString() || response['build_num_andoriod'].toString() != packageInfo.buildNumber.toString()){
            await AppUtil.dialog2(context, "pleaseUpdateApp".tr(), [
              SvgPicture.asset("${AppUI.iconPath}update.svg",height: 150),
              const SizedBox(height: 20,),
              CustomButton(text: 'update'.tr(),onPressed: (){
                launch(response['android_url']);
              },)
            ],barrierDismissible: false);
            exit(0);
          }
        }
        else if(Platform.isIOS){
          if (response['version_num_ios'].toString() != packageInfo.version.toString() || response['build_num_ios'].toString() != packageInfo.buildNumber.toString()){
            await AppUtil.dialog2(context, 'pleaseUpdateApp'.tr(), [
              SvgPicture.asset("${AppUI.iconPath}update.svg",height: 150,),
              const SizedBox(height: 20,),
              CustomButton(text: 'update'.tr(),onPressed: (){
                launch(response['ios_url']);
              },)
            ],barrierDismissible: false);
            exit(0);
          }
        }
    }catch(e){
      return Future.error(e);
    }
  }
}

