
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

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription? _sub;
  late final cubit = HomeCubit.get(context);
  late AppsflyerSdk _appsflyerSdk;
  Map _deepLinkData = {};
  Map _gcd = {};
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final cubit = IntroCubit.get(context);
    AddEventCubit.get(context);
    MoreCubit.get(context);
    cubit.navigateToNextScreen(context);
    HomeCubit.get(context).showHideAds();
    afStart();
  }

  void afStart() async {
    // SDK Options
    final AppsFlyerOptions options = AppsFlyerOptions(
        afDevKey: "HD7GQojLRGobHMFApdaSGZ"!,
        appId: Platform.isAndroid
            ? "com.expert_events.expert_events"!
            : "1661312796"!,
        showDebug: true,
        timeToWaitForATTUserAuthorization: 15,
        manualStart: true);
    _appsflyerSdk = AppsflyerSdk(options);

    // Init of AppsFlyer SDK
    await _appsflyerSdk.initSdk(
        registerConversionDataCallback: true,
        registerOnAppOpenAttributionCallback: true,
        registerOnDeepLinkingCallback: true);

    // Conversion data callback
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: " + res.toString());
      setState(() {
        _gcd = res;
      });
    });

    // App open attribution callback
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: " + res.toString());
      setState(() {
        _deepLinkData = res;
      });
    });

    // Deep linking callback
    _appsflyerSdk.onDeepLinking((DeepLinkResult dp) {
      switch (dp.status) {
        case Status.FOUND:
          print(dp.deepLink?.toString());
          print("deep link value: ${dp.deepLink?.deepLinkValue}");
          break;
        case Status.NOT_FOUND:
          print("deep link not found");
          break;
        case Status.ERROR:
          print("deep link error: ${dp.error}");
          break;
        case Status.PARSE_ERROR:
          print("deep link status parsing error");
          break;
      }
      print("onDeepLinking res: " + dp.toString());
      setState(() {
        _deepLinkData = dp.toJson();
      });
    });


    _appsflyerSdk.startSDK(
      onSuccess: () {
        print("AppsFlyer SDK initialized successfully.");
      },
      onError: (int errorCode, String errorMessage) {
        print(
            "Error initializing AppsFlyer SDK: Code $errorCode - $errorMessage");
      },
    );
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
