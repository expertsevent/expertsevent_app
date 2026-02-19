
import 'dart:async';
import 'dart:io';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:expert_events/event/presentation/screens/details/event_details_screen.dart';
import 'package:expert_events/layout/presentation/controller/bottom_nav_cubit.dart';
import 'package:expert_events/layout/presentation/screens/layout_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../add_event/presentation/controller/add_event_cubit.dart';
import '../../../core/app_util.dart';
import '../../../core/cash_helper.dart';
import '../../../core/ui/app_ui.dart';
import '../../../home/presentation/controller/home_cubit.dart';
import '../../../more/presentation/controller/more_cubit.dart';
import '../controller/intro_cubit.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import '../../../core/calendar_util.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription? _sub;
  late final cubit = HomeCubit.get(context);
  final Smartlook smartlook = Smartlook.instance;
  
  @override
  void initState()  {
    super.initState();
    AddEventCubit.get(context);
    MoreCubit.get(context);
    HomeCubit.get(context).showHideAds();
    smartlook.start();
    smartlook.preferences.setProjectKey('5499f45fab81a50cc61cf8dacc655f5bb3fdfb2b');
    _initAndNavigate();
  }

  void _initAndNavigate() async {
    // Request permissions first
    await AppUtil().getContactPermission();
    await CalendarUtils.requestCalendarPermission();
    
    // Then navigate to next screen
    if (mounted) {
      final cubit = IntroCubit.get(context);
      cubit.navigateToNextScreen(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset("${AppUI.imgPath}splash3.png", height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,),
        Image.asset("${AppUI.imgPath}logo.png", height: 250, width: 250,),
      ],
    );
  }
}
