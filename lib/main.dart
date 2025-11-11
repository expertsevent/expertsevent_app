import 'dart:io';
import 'package:flutter/material.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expert_events/invitations/presentation/controller/invitations_cubit.dart';
import 'package:expert_events/more/presentation/controller/more_cubit.dart';
import 'package:expert_events/more/presentation/controller/wallet/wallet_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'add_event/presentation/controller/add_event_cubit.dart';
import 'auth/presentation/controller/auth/auth_cubit.dart';
import 'auth/presentation/controller/forget_pass/forget_pass_cubit.dart';
import 'core/app_util.dart';
import 'core/network_connection.dart';
import 'core/ui/app_ui.dart';
import 'event/presentation/controller/events/events_cubit.dart';
import 'event/presentation/controller/guards/guards_cubit.dart';
import 'home/presentation/controller/home_cubit.dart';
import 'intro/presentation/controller/intro_cubit.dart';
import 'intro/presentation/screens/splash_screen.dart';
import 'layout/presentation/controller/bottom_nav_cubit.dart';
import 'core/cash_helper.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'core/calendar_util.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // use Brightness.dark if color is light
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  tzdata.initializeTimeZones();

  await AppUtil().initNotification();
  await AppUtil().getContactPermission();
  await CalendarUtils.requestCalendarPermission();
  // initialize connectivity watcher
  NetworkInfo.initialize();
  afStart();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'lang',
        fallbackLocale: const Locale('ar'),
       // startLocale: const Locale('ar'),
        child: const NetworkListener(child: MyApp())),
  );

  // WidgetsBinding.instance.addPostFrameCallback((_) {
  //   NetworkInfo.stream.listen((connected) {
  //     if (connected) {
  //       print("✅ Internet available");
  //     } else {
  //       print("🚫 No internet connection");
  //     }
  //     //}
  //   });
  // });
}

Future<void> storeDeviceLanguageIfNotChosen(BuildContext context) async {
  // Check if user has already selected a language before
  final hasChosenLanguage = await CashHelper.getSavedString("lang", "") != "" ? true : false;

  if (!hasChosenLanguage) {
    // Get the device-detected language from easy_localization
    final deviceLang = context.locale.languageCode;
    await CashHelper.setSavedString('lang', deviceLang);

    print("Stored default device language: $deviceLang");
  }
}

void afStart() async {
  late AppsflyerSdk _appsflyerSdk;
  Map _deepLinkData = {};
  Map _gcd = {};

  // SDK Options
  final AppsFlyerOptions options = AppsFlyerOptions(
      afDevKey: "HD7GQojLRGobHMFApdaSGZ",
      appId: Platform.isAndroid ? "com.expert_events.expert_events"! : "1661312796"!,
      showDebug: true,
      timeToWaitForATTUserAuthorization: 15,
      manualStart: true);
  /*
    final Map? map = {
      'afDevKey': dotenv.env["DEV_KEY"]!,
      'appId': dotenv.env["APP_ID"]!,
      'isDebug': true,
      'timeToWaitForATTUserAuthorization': 15.0//,
      //'manualStart': false
    };
    _appsflyerSdk = AppsflyerSdk(map);
     */
  _appsflyerSdk = AppsflyerSdk(options);

  /*
    Setting configuration to the SDK:
    _appsflyerSdk.setCurrencyCode("USD");
    _appsflyerSdk.enableTCFDataCollection(true);
    var forGdpr = AppsFlyerConsent.forGDPRUser(hasConsentForDataUsage: true, hasConsentForAdsPersonalization: true);
    _appsflyerSdk.setConsentData(forGdpr);
    var nonGdpr = AppsFlyerConsent.nonGDPRUser();
    _appsflyerSdk.setConsentData(nonGdpr);
     */

  // Init of AppsFlyer SDK
  await _appsflyerSdk.initSdk(
      registerConversionDataCallback: true,
      registerOnAppOpenAttributionCallback: true,
      registerOnDeepLinkingCallback: true);

  // Conversion data callback
  _appsflyerSdk.onInstallConversionData((res) {
    print("onInstallConversionData res: " + res.toString());
    // setState(() {
      _gcd = res;
    // });
  });

  // App open attribution callback
  _appsflyerSdk.onAppOpenAttribution((res) {
    print("onAppOpenAttribution res: " + res.toString());
    // setState(() {
      _deepLinkData = res;
    // });
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
    // setState(() {
      _deepLinkData = dp.toJson();
    // });
  });

  //_appsflyerSdk.anonymizeUser(true);
  if (Platform.isAndroid) {
    _appsflyerSdk.performOnDeepLinking();
  }
  // setState(() {}); // Call setState to rebuild the widget
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    storeDeviceLanguageIfNotChosen(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => IntroCubit()),
        BlocProvider(create: (context) => AuthCubit()..profile()),
        BlocProvider(create: (context) => ForgetPassCubit()),
        BlocProvider(create: (context) => BottomNavCubit()),
        BlocProvider(
            create: (context) => AddEventCubit()
              ..eventTypes()
              ..showHidePayment()),
        BlocProvider(create: (context) => GuardsCubit()),
        BlocProvider(
            create: (context) => HomeCubit()
              ..getEvents()
              ..getUsertype()
              ..getUserPhone()..showHideAds),
        BlocProvider(create: (context) => InvitationsCubit()),
        BlocProvider(create: (context) => EventsCubit()),
        BlocProvider(
            create: (context) => MoreCubit()
              ..getUserEvents()
              ..getUsertype()
              ..getUserPhone()),
        BlocProvider(create: (context) => WalletCubit()..getWallet()),
      ],
      child: MaterialApp(
        title: 'Experts Event',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          scaffoldBackgroundColor: AppUI.whiteColor,
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              iconTheme: IconThemeData(color: AppUI.disableColor)),
          primarySwatch: AppUI.mainColor,
          primaryColor: AppUI.mainColor,
          textTheme:
              GoogleFonts.robotoTextTheme(Theme.of(context).textTheme).copyWith(
            bodyLarge: GoogleFonts.roboto(
                textStyle: Theme.of(context).textTheme.bodyLarge),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

/// A small top-level widget that listens to `NetworkInfo.stream` and shows
/// a persistent SnackBar when the device goes offline and a brief message
/// when it comes back online.
class NetworkListener extends StatefulWidget {
  final Widget child;
  const NetworkListener({Key? key, required this.child}) : super(key: key);

  @override
  State<NetworkListener> createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  late final StreamSubscription<bool> _sub;
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>? _offlineSnack;

  @override
  void initState() {
    super.initState();
    _sub = NetworkInfo.stream.listen((connected) {
      if (!mounted) return;
      final messenger = ScaffoldMessenger.of(context);
      if (!connected) {
        // show a persistent offline message
        _offlineSnack = messenger.showSnackBar(const SnackBar(
          content: Text('No internet connection'),
          duration: Duration(days: 1), // effectively persistent until dismissed
        ));
      } else {
        // dismiss offline snack if present and show a short online message
        _offlineSnack?.close();
        messenger.showSnackBar(const SnackBar(
          content: Text('Back online'),
          duration: Duration(seconds: 2),
        ));
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
